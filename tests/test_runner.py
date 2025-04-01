import os
import time
import subprocess
import requests
import streamlit as st
import psutil  # To check if the process is running

# Define Paths
MAIN_PROJECT_DIR = "src/data/Bank-of-Bharat-BOB-master"
AUTOMATION_PROJECT_DIR = "src/data/Bank-of-Bharat-BOB-automation-master"
MAIN_PROJECT_JAR = os.path.join(MAIN_PROJECT_DIR, "target", "Bank-of-Bharat-BOB-0.0.1-SNAPSHOT.jar")
CUCUMBER_TEST_COMMAND = ["C:/apache-maven-3.9.9/bin/mvn.cmd", "test"]
EXPECTED_PORT = 54789  # Change if needed


def build_main_project():
    """Builds the main project using Maven."""
    st.write("🔧 Building the main project...")

    result = subprocess.run(["C:/apache-maven-3.9.9/bin/mvn.cmd", "clean", "install"], cwd="D:\\WFHackathon\\au\\src\\data\\Bank-of-Bharat-BOB-master", text=True, capture_output=True)

    if result.returncode == 0:
        st.success("✅ Project built successfully!")
        return True
    else:
        st.error("❌ Build failed. Check logs.")
        st.text_area("Build Logs", result.stdout + "\n" + result.stderr)
        return False

def is_port_in_use(port):
    """Check if a port is in use to determine if the application started."""
    for conn in psutil.net_connections(kind="inet"):
        if conn.laddr.port == port:
            return True
    return False

def start_main_project():
    """Starts the main Java Spring Boot application."""
    if not os.path.exists(MAIN_PROJECT_JAR):
        st.error(f"❌ JAR file not found: {MAIN_PROJECT_JAR}")
        return None

    print(f"Starting JAR: {MAIN_PROJECT_JAR}")
    st.write("🚀 Starting the main project...")

    # Start the main project and capture logs
    process = subprocess.Popen(
        ["java", "-jar", MAIN_PROJECT_JAR], 
        stdout=subprocess.PIPE, 
        stderr=subprocess.PIPE,
        text=True  # Ensures output is string, not bytes
    )

    # Wait for the application to start by checking the port
    for _ in range(60):  # Retry for 60 seconds
        output = process.stdout.readline()
        if "Started" in output or "Tomcat started" in output or is_port_in_use(EXPECTED_PORT):
            st.success("✅ Main project is running!")
            return process
        time.sleep(2)


    st.error("❌ Failed to start the main project.")

    return None


def run_cucumber_tests():
    """Runs Cucumber test scenarios from the automation project."""
    st.write("📝 Running Cucumber test scenarios...")

    # Run Maven test command in automation project
    result = subprocess.run(CUCUMBER_TEST_COMMAND, cwd=AUTOMATION_PROJECT_DIR, text=True, capture_output=True)

    if result.returncode == 0:
        st.success("✅ Cucumber tests executed successfully!")
    else:
        st.error("❌ Cucumber tests failed. Check logs.")
        st.text_area("Test Logs", result.stdout + "\n" + result.stderr)
