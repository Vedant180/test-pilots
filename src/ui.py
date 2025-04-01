import streamlit as st

from main import test_repo
from tests.test_runner import build_main_project, run_cucumber_tests, start_main_project
from utils import get_repo_changes, process_repositories
from model import generate_modified_bdd

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
            # Process each repo
            for repo_url in repo_list:
                st.write(f"🔄 Processing `{repo_url}`...")
                
                # Step 1: Process the repository
                java_code = process_repositories(repo_url, framework)
                
                if java_code:
                    st.write(f"✅ Successfully processed `{repo_url}`.")

                    if "automation" not in repo_url.lower():
                        result = test_repo(repo_url, framework)
                        st.success(f"🚀 {result}")
                    else:
                        st.warning(f"⚠️ Skipping testing for `{repo_url}` (contains 'automation').")

                else:
                    st.error(f"❌ Failed to process `{repo_url}`.")
                    
                    # Step 2: Run automation tests
                    result = test_repo(repo_url, framework)
                    
                    # Display the result
                    
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
