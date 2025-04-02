import os
import requests
import zipfile
import dotenv
import re
from neo4j import GraphDatabase
import json
import chromadb
from sentence_transformers import SentenceTransformer
import requests


embedding_model = SentenceTransformer("all-MiniLM-L6-v2")

# ✅ Initialize ChromaDB (Persistent Storage)
client = chromadb.PersistentClient(path="./api_vector_db")
collection = client.get_or_create_collection("api_metadata")


# 🔹 Replace these with your details
GITHUB_TOKEN = "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"
REPO_OWNER = "Vedant180"
REPO_NAME = "Bank-of-Bharat-BOB"
BRANCH = "master"

# GitHub API Headers
HEADERS = {"Authorization": f"token {GITHUB_TOKEN}"}

def get_last_two_commits():
    """Fetch the last two commit SHAs."""
    url = f"https://api.github.com/repos/{REPO_OWNER}/{REPO_NAME}/commits?sha={BRANCH}&per_page=2"
    response = requests.get(url, headers=HEADERS)
    commits = response.json()

    if len(commits) < 2:
        return None, None  # Not enough commits
    
    # print("Hereeeee")
    return commits[1]["sha"], commits[0]["sha"]  # Previous & latest commit

def get_changes(old_sha, new_sha):
    """Fetch changed files between two commits with before/after content."""
    url = f"https://api.github.com/repos/{REPO_OWNER}/{REPO_NAME}/compare/{old_sha}...{new_sha}"
    response = requests.get(url, headers=HEADERS)
    data = response.json()
    
    changes = {}
    for file in data.get("files", []):
        filename = file["filename"]
        changes[filename] = {
            "status": file["status"],
            "patch": file.get("patch", "No diff available"),
            "raw_url": file.get("raw_url", ""),
            "old_url": f"https://raw.githubusercontent.com/{REPO_OWNER}/{REPO_NAME}/{old_sha}/{filename}",
            "new_url": f"https://raw.githubusercontent.com/{REPO_OWNER}/{REPO_NAME}/{new_sha}/{filename}"
        }
    return changes

def get_repo_changes():
    """Wrapper function to fetch and return the changes."""
    old_sha, new_sha = get_last_two_commits()
    # print("SHAAAA ",old_sha, new_sha)
    if not old_sha or not new_sha:
        return {"error": "Not enough commits to compare."}
    
    return get_changes(old_sha, new_sha)

def extract_existing_features(repo_url):
    """
    Downloads a GitHub repository as a ZIP file, extracts it, and reads all `.feature` files to extract the scenarios.

    Args:
        repo_url (str): GitHub repository URL.

    Returns:
        list: List of all features (scenario names) in the repository's `.feature` files.
    """
    
    # Ensure the data folder exists inside src
    DATA_DIR = "src/data"
    os.makedirs(DATA_DIR, exist_ok=True)  # Create if not exists

    # Generate paths
    repo_name = repo_url.rstrip("/").split("/")[-1]  # Extract repo name
    zip_path = os.path.join(DATA_DIR, f"{repo_name}.zip")
    extract_path = os.path.join(DATA_DIR, repo_name)

    # GitHub zip URL
    ZIP_URL = f"{repo_url}/archive/refs/heads/master.zip"

    # Download the ZIP file if not already downloaded
    if not os.path.exists(zip_path):
        print("⏳ Downloading repository...")
        response = requests.get(ZIP_URL, stream=True)
        
        if response.status_code == 200:
            with open(zip_path, "wb") as f:
                for chunk in response.iter_content(chunk_size=1024):
                    f.write(chunk)
            print("✅ Repository downloaded successfully.")
        else:
            print(f"❌ Failed to download repository. Status Code: {response.status_code}")
            return []

    # Extract the ZIP file
    if not os.path.exists(extract_path):
        print("⏳ Extracting repository...")
        with zipfile.ZipFile(zip_path, "r") as zip_ref:
            zip_ref.extractall(DATA_DIR)
        print("✅ Repository extracted successfully.")

    # List files in the repo to verify
    extracted_folder = os.path.join(DATA_DIR, f"{repo_name}-master")  # Adjusting for GitHub's naming convention
    if not os.path.exists(extracted_folder):
        print(f"❌ Extraction failed! Folder {extracted_folder} not found.")
        return []

    print("📁 Repo contents:", os.listdir(extracted_folder))

    features_dir = os.path.join(extracted_folder, "src/test/resources/features")
    if not os.path.exists(features_dir):
        print(f"❌ Feature directory {features_dir} not found.")
        return []

    print("📂 Feature files directory found:", features_dir)

    # Read .feature files and extract scenarios
    def read_feature_files(features_path):
        feature_scenarios = []
        for root, _, files in os.walk(features_path):
            for file in files:
                if file.endswith(".feature"):
                    file_path = os.path.join(root, file)
                    print(f"🔍 Reading: {file_path}")  # Debugging log
                    
                    with open(file_path, "r", encoding="utf-8") as f:
                        content = f.readlines()
                    
                scenario = []
                inside_scenario = False  # Flag to track if we are inside a scenario block
                
                for line in content:
                    line = line.strip()  # Remove spaces/tabs
                    
                    if line.startswith("Scenario:"):
                        # If a scenario was being captured, store it before starting a new one
                        if scenario:
                            feature_scenarios.append("\n".join(scenario))
                        
                        # Start new scenario
                        scenario = [line]
                        inside_scenario = True
                        
                    elif inside_scenario:
                        # Keep adding steps to the current scenario until a new scenario starts
                        if line.startswith("Scenario:") or line.startswith("Feature:"):
                            # If we hit another scenario/feature, stop capturing
                            inside_scenario = False
                        else:
                            scenario.append(line)
                
                # Append last scenario in the file (if it exists)
                if scenario:
                    feature_scenarios.append("\n".join(scenario))
    
        return feature_scenarios
    
    features = read_feature_files(features_dir)

    print(f"✅ Extracted {len(features)} complete feature scenarios.")
    for i, scenario in enumerate(features, 1):
        print(f"\n📜 Scenario {i}:\n{scenario}")

    return features


def process_repositories(github_repo, framework):
    """
    Downloads a GitHub repository as a ZIP file, extracts it, and reads all Java files.

    Args:
        github_repo (str): GitHub repository URL.
        framework (str): Framework (unused, but kept for compatibility).

    Returns:
        str: Merged Java code from all `.java` files in the repository.
    """
    
    # Ensure the data folder exists inside src
    DATA_DIR = "src/data"
    os.makedirs(DATA_DIR, exist_ok=True)  # Create if not exists

    # Generate paths
    repo_name = github_repo.rstrip("/").split("/")[-1]  # Extract repo name
    zip_path = os.path.join(DATA_DIR, f"{repo_name}.zip")
    extract_path = os.path.join(DATA_DIR, repo_name)

    # GitHub zip URL
    ZIP_URL = f"{github_repo}/archive/refs/heads/master.zip"  # Assuming 'main' branch

    # Download the ZIP file if not already downloaded
    if not os.path.exists(zip_path):
        print("⏳ Downloading repository...")
        response = requests.get(ZIP_URL, stream=True)
        
        if response.status_code == 200:
            with open(zip_path, "wb") as f:
                for chunk in response.iter_content(chunk_size=1024):
                    f.write(chunk)
            print("✅ Repository downloaded successfully.")
        else:
            print(f"❌ Failed to download repository. Status Code: {response.status_code}")
            return ""

    # Extract the ZIP file
    if not os.path.exists(extract_path):
        print("⏳ Extracting repository...")
        with zipfile.ZipFile(zip_path, "r") as zip_ref:
            zip_ref.extractall(DATA_DIR)
        print("✅ Repository extracted successfully.")

    # List files in the repo to verify
    extracted_folder = os.path.join(DATA_DIR, f"{repo_name}-master")  # Adjusting for GitHub's naming convention
    if not os.path.exists(extracted_folder):
        print(f"❌ Extraction failed! Folder {extracted_folder} not found.")
        return ""

    print("📁 Repo contents:", os.listdir(extracted_folder))

    # Read Java files
    def read_java_files(repo_path):
        code_segments = []
        for root, _, files in os.walk(repo_path):
            for file in files:
                if file.endswith(".java"):
                    file_path = os.path.join(root, file)
                    with open(file_path, "r", encoding="utf-8") as f:
                        code_segments.append(f"// File: {file_path}\n{f.read()}")
        return "\n\n".join(code_segments)

    full_code = read_java_files(extracted_folder)

    print(f"✅ Merged {len(full_code.splitlines())} lines of Java code.")
    print(f"Total code length: {len(full_code.split())} words") 
    
    return full_code

def clean_extract_queries(cypher_script: str):
    # Remove code block markers if present
    cypher_script = cypher_script.strip("```cypher").strip("```")

    # Remove single-line comments (// ...)
    cypher_script = re.sub(r'//.*', '', cypher_script)

    # Remove multi-line comments (/* ... */)
    cypher_script = re.sub(r'/\*.*?\*/', '', cypher_script, flags=re.DOTALL)

    # Fix missing semicolons by ensuring each CREATE/MATCH statement ends correctly
    cypher_script = cypher_script.replace("\nCREATE", ";\nCREATE")
    cypher_script = cypher_script.replace("\nMATCH", ";\nMATCH")

    # Split queries by semicolon (;) followed by optional whitespace and newlines
    queries = re.split(r';\s*\n', cypher_script)

    # Remove empty entries, strip whitespace, and ensure each query ends with ;
    queries = [query.strip() + ";" for query in queries if query.strip()]

    return queries

def get_dependency():
    pass

# def generate_modified_bdd(changes):
#     for filename in changes.keys():  # Get each filename
#         api_dependencies = get_dependency(filename)

def run_queries(uri, user, password, queries):
    driver = GraphDatabase.driver(uri, auth=(user, password))
    
    with driver.session() as session:
        for query in queries:
            result = session.run(query)
            print(f"Query: {query}")
            for record in result:
                print(record)
    driver.close()


def store_api_data(api_json):
    for api in api_json["apis"]:
        # Convert API metadata into searchable text format
        api_text = json.dumps(api, indent=4)

        # Generate embedding
        embedding = embedding_model.encode(api_text).tolist()
        existing_scenarios = json.dumps(api.get("existing_scenarios", []))

        # Store in ChromaDB
        collection.add(
            ids=[api["endpoint"]],  # Use API endpoint as unique ID
            metadatas=[{
                "method": api["method"],
                "parameters": json.dumps(api["parameters"]),  # Convert list to string
                "responses": json.dumps(api["responses"]),  # Convert dict to string
                "dependencies": json.dumps(api["dependencies"]),  # Convert list to string
                "description": api["description"],
                "businessRules": api["businessRules"],
                "existing_scenarios": existing_scenarios
            }],
            embeddings=[embedding]
        )
    print("✅ API details stored successfully in ChromaDB!")



def save_to_file(response: str, file_path: str):
    """Saves the given response to a file, creating directories if necessary."""
    
    # Create the directory if it does not exist
    os.makedirs(os.path.dirname(file_path), exist_ok=True)

    # Write response to the file
    with open(file_path, "w", encoding="utf-8") as file:
        file.write(response)

    print(f"Data successfully saved to {file_path}")

def remove_backticks(text):
    lines = text.strip().split("\n")
    if lines[0].strip().startswith("```") and lines[-1].strip().startswith("```"):
        return "\n".join(lines[1:-1]).strip()
    return text.strip()


