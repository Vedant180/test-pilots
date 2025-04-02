import os
import signal
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

    result = subprocess.run(["C:/apache-maven-3.9.9/bin/mvn.cmd", "clean", "install"], cwd="D:\\WFHackathon\\trial\\test-pilots\\src\\data\\Bank-of-Bharat-BOB-master", text=True, capture_output=True)

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

    # Paths
    AUTOMATION_PROJECT_DIR = "D:/WFHackathon/trial/test-pilots/src/data/Bank-of-Bharat-BOB-automation-master"
    cucumber_runner_class = "org.junit.runner.JUnitCore"
    test_runner = "tuto.cucumber.sample.CucumberTestRunner"
    report_path = f"{AUTOMATION_PROJECT_DIR}/target/cucumber-reports.html"

          
    # JVM Options
    jvm_options = ["-Xms512m", "-Xmx1024m"]
    result = subprocess.run(CUCUMBER_TEST_COMMAND, cwd=AUTOMATION_PROJECT_DIR, text=True, capture_output=True)

    test_results = {
        "success": [],
        "failures": []
    }

    if result.returncode == 0:
        # Run Maven to ensure dependencies are available
        mvn_command = ["C:/apache-maven-3.9.9/bin/mvn.cmd", "dependency:copy-dependencies", "-DoutputDirectory=target/libs"]
        mvn_process = subprocess.Popen(mvn_command, cwd=AUTOMATION_PROJECT_DIR, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        mvn_stdout, mvn_stderr = mvn_process.communicate()

        if mvn_process.returncode != 0:
            st.error("❌ Maven dependency copy failed")
            st.text_area("Maven Logs", mvn_stderr.decode())
            return

        # Define classpath correctly
        classpath = f"{AUTOMATION_PROJECT_DIR}/target/test-classes;{AUTOMATION_PROJECT_DIR}/target/libs/*"

        # Construct the command
        command = ["java", *jvm_options, "-cp", classpath, cucumber_runner_class, test_runner]

        process = subprocess.Popen(command, cwd=AUTOMATION_PROJECT_DIR, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        stdout, stderr = process.communicate()

        # Display results in Streamlit
        if process.returncode == 0:
            st.success("✅ Cucumber tests executed successfully!")
        else:
            failure_reasons = []
            logs = stdout + "\n" + stderr
            print("LOGS",logs)
            for line in logs.split("\n"):
                if "AssertionError" in line or "Exception" in line:  # Adjust based on log patterns
                    failure_reasons.append(line.strip())

            if failure_reasons:
                test_results["failures"] = failure_reasons

            st.error("❌ Cucumber tests failed. Check logs.")
        
        st.text_area("Test Logs", stdout + "\n" + stderr)
        print("DICTTTT",test_results)
        print("STDERR",stderr)

        if os.path.exists(report_path):
            st.success("✅ Test execution complete! View the test report below:")

            # Embed the report using an iframe
            with open(report_path, "r", encoding="utf-8") as f:
                html_content = f.read()
            
            st.components.v1.html(html_content, height=600, scrolling=True)

        else:
            st.error("❌ Report not found. Please check if the test execution was successful.")



    else:
        st.error("❌ Cucumber tests failed. Check logs.")
        st.text_area("Test Logs", result.stdout + "\n" + result.stderr)
    
    for proc in psutil.process_iter(['pid', 'name']):
        if "java" in proc.info['name'].lower():
            try:
                os.kill(proc.info['pid'], signal.SIGTERM)
                print(f"🛑 Stopped Java process (PID: {proc.info['pid']})")
            except Exception as e:
                print(f"⚠️ Could not stop process {proc.info['pid']}: {e}")
      

    

    

    # Run Maven test command in automation project
    # result = subprocess.run(CUCUMBER_TEST_COMMAND, cwd=AUTOMATION_PROJECT_DIR, text=True, capture_output=True)

    # if result.returncode == 0:
    #     st.success("✅ Cucumber tests executed successfully!")
    # else:
    #     st.error("❌ Cucumber tests failed. Check logs.")
    #     st.text_area("Test Logs", result.stdout + "\n" + result.stderr)
