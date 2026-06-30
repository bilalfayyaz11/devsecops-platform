# Jenkins-Orchestrated DevSecOps CI/CD Pipeline

## Overview
This project demonstrates an advanced, automated Continuous Integration and Continuous Deployment (CI/CD) pipeline built on **Jenkins**. It showcases the ability to enforce "Shift-Left" security by orchestrating multiple scanning engines across the entire software development lifecycle, ensuring that vulnerable code and misconfigured containers are blocked before reaching production.

## Pipeline Architecture
```text
┌──────────────┐     ┌─────────────────────┐     ┌──────────────────────┐
│  Source Code │     │   Security Scans    │     │ Container & Deploy   │
│  (Git Push)  ├────►│  (Jenkins Runner)   ├────►│ (Docker & Trivy)     │
└──────────────┘     └────────┬────────────┘     └────────┬─────────────┘
                              │                           │
                     ┌────────▼────────┐         ┌────────▼────────┐
                     │ • Bandit (SAST) │         │ • Build Image   │
                     │ • OWASP (SCA)   │         │ • Trivy Scan    │
                     └─────────────────┘         │ • Deploy App    │
                                                 └─────────────────┘
Key Technologies
CI/CD Orchestration: Jenkins (Pipeline-as-Code via Jenkinsfile)

Static Application Security Testing (SAST): Bandit

Software Composition Analysis (SCA): OWASP Dependency-Check

Container Security: Trivy, Docker

Application Stack: Python, Flask, SQLite

Governance: Git Pre-commit Hooks, Custom Security Dashboards
