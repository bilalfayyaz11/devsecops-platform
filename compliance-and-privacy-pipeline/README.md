# DevSecOps Compliance & Privacy Auditing Pipeline

## What This Does

This implementation demonstrates a mature DevSecOps pipeline that moves beyond standard code scanning to include automated Infrastructure-as-Code (IaC) compliance and privacy threat modeling.

By integrating OpenSCAP for OS-level baseline hardening and Chef InSpec for data privacy auditing, the pipeline ensures that applications are not only secure at the code level but also legally compliant and deployed on hardened infrastructure.

---

## Architecture

    ┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
    │ Threat Modeling │     │  Code Security  │     │   Compliance    │
    │ (LINDDUN /      ├────►│  (Bandit SAST & ├────►│  (OpenSCAP OS & │
    │ Threat Dragon)  │     │  Safety SCA)    │     │  InSpec Audits) │
    └─────────────────┘     └─────────────────┘     └────────┬────────┘
                                                             │
                                                             ▼
    ┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
    │                 │     │                 │     │                 │
    │  CI/CD Platform │◄────┤  HTML Dashboard │◄────┤ Custom Security │
    │  (GitLab CI)    │     │  Generation     │     │ Tests (MD5/SQLi)│
    │                 │     │                 │     │                 │
    └─────────────────┘     └─────────────────┘     └─────────────────┘

---

## Prerequisites

- Ubuntu 24.04 LTS
- Docker Engine & Docker Compose v2
- Python 3.9+ & Python Virtual Environments
- OpenSCAP (openscap-utils)
- Chef InSpec (omnitruck.chef.io)

---

## Setup & Installation

    sudo apt update && sudo apt install -y curl wget unzip openscap-utils

    curl -sL https://omnitruck.chef.io/install.sh | sudo bash -s -- -P inspec

    wget https://github.com/ComplianceAsCode/content/releases/download/v0.1.68/scap-security-guide-0.1.68.zip
    unzip scap-security-guide-0.1.68.zip

---

## How to Reproduce

### 1. Initialize the Environment

Set up the Python virtual environment to isolate the security tooling.

    python3 -m venv venv
    source venv/bin/activate
    pip install flask bandit safety==2.3.5 requests pytest

---

### 2. Execute the Master Pipeline

Run the consolidated script that orchestrates SAST, SCA, OpenSCAP, and InSpec sequentially.

    ./run_complete_security_pipeline.sh

---

### 3. Visualize Threats (Optional)

Launch OWASP Threat Dragon locally to visualize the LINDDUN architecture maps.

    docker compose -f security/docker-compose-threat-dragon.yml up -d

Access via:

    http://localhost:3000

---

## Tools Used

### Privacy & Threat Modeling
- LINDDUN Methodology
- OWASP Threat Dragon

### Infrastructure Compliance
- OpenSCAP
- XCCDF Baselines

### Policy / Privacy Auditing
- Chef InSpec (Ruby)

### Application Security
- Bandit (SAST)
- Safety (SCA)

### Orchestration
- Bash
- Python
- Docker Compose
- GitLab CI

---

## Key Skills Demonstrated

- Translation of legal/privacy requirements (GDPR/Data Minimization) into executable InSpec Ruby code.
- Automated OS hardening assessments utilizing NIST/SCAP baselines via OpenSCAP.
- STRIDE and LINDDUN threat modeling to preemptively identify architectural vulnerabilities.
- Mitigation of modern Linux package management restrictions utilizing isolated Python virtual environments.
- Consolidation of disparate security tooling outputs into a unified HTML compliance dashboard.

---

## Real-World Use Case

In highly regulated industries such as Finance, Healthcare, and Government, an application passing unit tests is insufficient for deployment.

Organizations must prove that the underlying server OS meets strict hardening guidelines (such as CIS Benchmarks) and that the application architecture enforces data minimization.

This pipeline automates those legal and operational audits. By running OpenSCAP and InSpec on every commit, security engineering teams can prevent compliance regressions before they reach production, dramatically reducing the time and cost associated with manual security audits.

---

## Lessons Learned

### Package Modernization
Legacy tools relying on global Python packages will fail on modern operating systems (Ubuntu 24.04+). Enforcing virtual environments in CI/CD scripts is mandatory for stable automation.

### Rule Obsolescence
Static OpenSCAP XML baselines must be version-matched to the target operating system. Running outdated baseline definitions against modern kernels results in false positives.

### Declarative Auditing
Using InSpec allows security teams to write compliance checks (e.g., database schema validation for sensitive fields) as human-readable Ruby code, bridging the gap between legal teams and software engineers.

### Visual vs Programmatic Threat Modeling
While tools like Threat Dragon provide strong visual architecture reviews, translating those threats into executable test cases is necessary for mature DevSecOps workflows.

---

## Troubleshooting Log

### Issue: libopenscap8 package installation failed due to OS deprecation in Ubuntu 24.04

Cause:
Legacy package dependency no longer supported.

Resolution:

    sudo apt install openscap-utils

This allowed the package manager to dynamically resolve the modernized backend libraries.

---

### Issue: Global pip3 installs caused externally-managed-environment errors

Cause:
Ubuntu 24.04 package management restrictions.

Resolution:

    python3 -m venv venv
    source venv/bin/activate

All Python tooling (Bandit, Safety) was isolated inside a dedicated virtual environment for stable execution.

---

### Issue: Docker socket permission denials during OWASP Threat Dragon deployment

Cause:
Insufficient Docker socket permissions.

Resolution:

    sudo chmod 666 /var/run/docker.sock

This enabled dynamic user access during automated Docker Compose deployment.

