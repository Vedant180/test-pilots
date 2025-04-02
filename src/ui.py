import streamlit as st

from main import test_repo
from tests.test_runner import build_main_project, run_cucumber_tests, start_main_project
from utils import extract_existing_features, get_repo_changes, process_repositories
from model import generate_modified_bdd
import requests

# Title of the app
st.title("Automation Test Generator")

# Input fields
repo_urls = st.text_area("Enter GitHub Repo URLs (one per line)")
framework = st.selectbox("Select Automation Framework", ["Playwright", "Cucumber (Java)"])

# Submit button with unique key
if st.button("Start Automation", key="start_automation"):
    if repo_urls.strip():
        st.info("⏳ Processing repositories... Please wait.")

        # Split input into multiple repo URLs
        repo_list = [url.strip() for url in repo_urls.split("\n") if url.strip()]

        if not repo_list:
            st.error("❌ Please enter at least one valid repository URL.")
        else:
            automation_repos = [url for url in repo_list if "automation" in url.lower()]
            non_automation_repos = [url for url in repo_list if "automation" not in url.lower()]
            repo_list = automation_repos + non_automation_repos
            all_features = []
            # Process each repo
            for repo_url in repo_list:
                
                # Step 1: Process the repository
                response = requests.get(repo_url)
                if response.status_code == 200:
                    if "automation" in repo_url.lower():
                        st.write(f"🔄 Processing `{repo_url}`...")
                        features = extract_existing_features(repo_url)
                        all_features+= features
                        print("Scenarios",all_features)
                    else:
                        st.write(f"🔄 Processing `{repo_url}`...")
                        print("INELSEEEE",all_features)
                        test_repo(repo_url, framework,all_features)


                else:
                    st.error(f"❌ Failed to process `{repo_url}`.")
    else:
        st.error("❌ Please enter at least one repository URL.")


st.markdown("---")

# **Cucumber Test Runner Section**
st.header("🧪 Run Cucumber Tests")

# Button to run tests with a unique key
if st.button("Run Cucumber Tests", key="run_cucumber_tests"):
    if build_main_project():  # Step 1: Build the project
        process = start_main_project()  # Step 2: Start the application

        if process:
            run_cucumber_tests()  # Step 3: Run tests
            
            # Stop the main project after tests
            process.terminate()
            st.write("🛑 Stopped the main project.")

st.header("📌 Get Compare")
if st.button("Compare Commits"):
    with st.spinner("Fetching changes..."):
        changes = get_repo_changes()
        if not changes:
            st.info("No changes detected")
        else:
            for filename, data in changes.items():
                with st.expander(f"🔹 {filename} ({data['status'].upper()})"):
                    if data["patch"]:
                        st.code(data["patch"], language="diff")
        
    new_modified_bdd_scenarios = generate_modified_bdd(changes)
    st.code(new_modified_bdd_scenarios)
