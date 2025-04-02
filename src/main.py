from model import generate_api_details, generate_bdd_scenarios, generate_dependency_graph, generate_requests_file, generate_step_definitions
from utils import process_repositories, remove_backticks, save_to_file, store_api_data
import streamlit as st

def test_repo(repo_url, framework,all_features):
    repo_code = process_repositories(repo_url, framework)
    st.write(f"✅ Successfully processed `{repo_url}`.")
    # dependency_graph = generate_dependency_graph(repo_code)
    api_details,api_dict=generate_api_details(repo_code,all_features)   #json response
    print("STORE",api_details)
    store_api_data(api_dict)
    output_path=repo_url.rstrip("/").split("/")[-1] 
    save_to_file(api_details,f"src/outputs/{output_path}.json")

    bdd_scenarios=generate_bdd_scenarios(api_dict)
    bdd_scenarios = remove_backticks(bdd_scenarios)
    save_to_file(bdd_scenarios,f"tests/generated_tests/{output_path}/{output_path}+.feature")
    step_definitions=generate_step_definitions(bdd_scenarios)
    save_to_file(step_definitions,f"tests/generated_tests/{output_path}/{output_path}+StepDefinitions.java")
    requests_file=generate_requests_file(step_definitions)
    save_to_file(requests_file,f"tests/generated_tests/{output_path}/{output_path}+Requests.java")
    print("done")



