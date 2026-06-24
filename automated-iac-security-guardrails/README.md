# Automated IaC Security Guardrails and Compliance Policy Engine

## What This Does
This implementation provides a multi-framework Infrastructure as Code (IaC) automated security guardrail system that validates infrastructure designs before deployment. The platform establishes static code analysis and Open Policy Agent (OPA) compliance checks across both HashiCorp Terraform templates and Pulumi Python configurations to intercept and remediate architectural vulnerability vectors such as exposed S3 endpoints, unencrypted storage systems, missing metadata tags, and open security groups. By moving security policy validations to the early development stage, this solution prevents data exposures and configuration issues from reaching live cloud environments.

## Architecture

    +------------------------------------------------------------+
    |           Developer Workstation / CI Pipeline              |
    |  (main.tf / main-secure.tf)        (__main__.py / Rego)    |
    +---------------------+---------------------+----------------+
                          |                     |
                          v                     v
    +---------------------+-----+         +-----+----------------+
    | Static AST Code Analysis  |         | Multi-Stage Parser   |
    | (Checkov Scan Engine)     |         | (State Simulation)   |
    +---------------------+-----+         +-----+----------------+
                          |                     |
                          |                     v
                          |               +-----+----------------+
                          |               | Open Policy Agent    |
                          |               | (Rego Evaluation)    |
                          |               +-----+----------------+
                          |                     |
                          v                     v
    +---------------------+---------------------+----------------+
    |             Centralized Compliance Gate Matrix             |
    |          (security-monitor.py Execution Report)            |
    +------------------------------------------------------------+

## Prerequisites
- Ubuntu 24.04 LTS Execution Environment
- HashiCorp Terraform v1.6+ Engine Binary
- Pulumi CLI Framework Engine
- Open Policy Agent (OPA) Decoupled Engine Binary
- Python 3.x with Virtual Environment (`venv`) Capability

## Setup & Installation
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl jq unzip wget git python3-pip python3-venv

curl -fSsL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install -y terraform

curl -L -o opa https://openpolicyagent.org/downloads/v0.57.0/opa_linux_amd64_static
chmod +x opa && sudo mv opa /usr/local/bin/

## How to Reproduce
Analyse single cloud infrastructure configuration paths:

cd terraform-security-lab
source venv/bin/activate
checkov -f main-secure.tf

cd ../pulumi-security-lab
python3 validate-policy.py

python3 ~/security-monitor.py

## Tools Used
- Terraform
- Pulumi
- Open Policy Agent
- Checkov
- Python 3
- Bash
- Linux
- Git

## Key Skills Demonstrated
- Automated Cloud Infrastructure Compliance Verification
- Policy-as-Code Engineering via Rego/OPA Logic Engines
- Static Code Guardrails Implementation for Multi-Framework Architectures
- Secure S3 Object Store Hardening Implementation
- Enterprise Resource Metadata Tagging Verification Policy Creation
- DevSecOps Automated Quality Gate Interception Architecture

## Real-World Use Case
In an enterprise cloud ecosystem, manual validation cannot effectively scale across thousands of developer pipeline runs, often causing misconfigurations like public storage buckets or open firewalls to leak into staging and production spaces. This platform implements automated security checks within pre-commit hooks and GitHub Actions pipelines. If an engineer accidentally leaves an S3 bucket unencrypted or publicly readable, the automated compliance gate breaks the build step instantly, protecting corporate infrastructure before deployment.

## Lessons Learned
- Generic structural checks create high false-positive rates; tailoring specific rules to matching infrastructure signatures drastically improves pipeline reliability.
- Isolating structural checking rules via standalone Rego code modules makes it easy to update policies without modifying deployment scripts.
- Relying on third-party cloud connections during build stages blocks local development environments; wrapping steps with mock configuration states ensures clean execution within disconnected runner environments.

## Troubleshooting Log
Issue:
Missing underlying distribution dependencies for HashiCorp tools within fresh terminal sandboxes.

Resolution:
Added explicit, secure GPG key provisioning commands and explicitly registered the repository source lists via apt.

Issue:
System global installation failures when pulling Checkov and Pulumi dependencies on modern Linux kernels.

Resolution:
Wrapped structural dependencies inside isolated Python environments to prevent environmental isolation violations.

Issue:
Pulumi schema previews blocked execution runs by requiring live cloud access and backend connection tokens.

Resolution:
Re-engineered the validation runner script (validate-policy.py) to process an accurately simulated data model directly against the OPA engine.
