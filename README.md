# 🚀 TestPilot: Context-Aware AI-Powered Automation Testing System


## 📌 Table of Contents
- [Introduction](#introduction)
- [Demo](#demo)
- [Inspiration](#inspiration)
- [What It Does](#what-it-does)
- [How We Built It](#how-we-built-it)
- [Challenges We Faced](#challenges-we-faced)
- [How to Run](#how-to-run)
- [Tech Stack](#tech-stack)
- [Team](#team)

---

## 🎯 Introduction
Modern financial ecosystems are highly dynamic, with frequent code changes impacting business logic and APIs. Traditional automation testing methods struggle to keep up, leading to inefficiencies and increased manual intervention. Our project aims to revolutionize *automation testing* by leveraging *GenAI-powered automation* to create a *context-aware, self-adaptive testing system* that ensures seamless software delivery with minimal human effort.

## 🎥 Demo 
📹 [Video Demo](#) (if applicable)  
🖼️ Screenshots:

![System Architecture](artifacts\arch\arch.jpg)

## 💡 Inspiration
In modern financial ecosystems, continuous code changes and evolving business logic make it challenging to maintain accurate and up-to-date automation tests. Traditional automation testing struggles to adapt dynamically to modifications, leading to increased manual effort and potential test failures. Our goal was to leverage *GenAI-powered automation* to create a *self-adaptive testing system* that ensures high-quality software delivery with minimal human intervention.

## ⚙ What It Does
- *AI-Powered Code Parsing*: Extracts API details, business logic, and dependencies.
- *Dependency Graph Generation*: Uses Neo4j to map API relationships and interactions.
- *Context-Aware Test Generation*: Fine-tuned AI model generates BDD feature files based on business logic.
- *Automated Change Detection & Test Modification*: Monitors GitHub for updates, retrieves impacted endpoints, and modifies BDD test cases accordingly.
- *Seamless CI/CD Integration*: Automatically commits updated tests to GitHub, enabling continuous test adaptation.

## 🛠 How We Built It
- *Programming Languages*: Python, Java
- *AI Models*: Fine-tuned Gemini 1.5 for BDD test generation
- *Databases*: Neo4j (for dependency mapping), ChromeDB (for context-aware retrieval)
- *Testing Framework*: Cucumber (Java-based BDD Testing)
- *Automation Tools*: OpenHands Software Engineering Assistant
- *Version Control & CI/CD*: GitHub SaaS Services for automatic test updates

## 🚧 Challenges We Faced
- *Fine-Tuning AI Models*: Optimizing the AI model for precise BDD test generation required multiple iterations.
- *Handling Complex Dependencies*: Building an accurate dependency graph with Neo4j for large-scale applications.
- *Ensuring Test Accuracy*: Making sure AI-generated test cases aligned correctly with business logic.
- *Real-Time Test Adaptation*: Efficiently updating tests in response to frequent code changes.
- *Seamless Integration*: Automating the workflow from test generation to GitHub commits without breaking the CI/CD pipeline.


## 🏃 How to Run
1. Clone the repository  
   ```sh
   git clone https://github.com/ewfx/catfe-test-pilots/
   ```
2. Install dependencies  
   ```sh
   py -m venv .venv
   .\.venv\Scripts\activate
   pip install -r requirements.txt
   ```
3. Run the project  
   ```sh 
   streamlit.cmd run .\src\ui.py 
   ```

## 🏗️ Technologies & Tools Used:
- 🔹 AI Models: Fine-tuned Gemini 1.5 for BDD generation
- 🔹 Databases: Neo4j (Dependency Graph), ChromeDB (RAG Storage)
- 🔹 Testing Framework: Cucumber (Java-based BDD Testing)
- 🔹 Automation Tools: OpenHands Software Engineering Assistant
- 🔹 Version Control & CI/CD: GitHub SaaS Services


## 👥 Test-Pilots
- Prerna Sharma
- Manas Kulkarni
- Vedant Mule
- Ritesh Kumar
- Sanjit Anand