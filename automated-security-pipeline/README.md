# Enterprise DevSecOps Pipeline & Infrastructure Security

## What This Does

This implementation establishes a zero-trust, fully automated continuous integration and delivery workflow. It integrates Static Application Security Testing (SAST), Dynamic Application Security Testing (DAST), and Infrastructure as Code (IaC) vulnerability scanning directly into the deployment lifecycle.

By leveraging HashiCorp Vault for dynamic secret management and Open Policy Agent (OPA) for compliance-as-code, the system guarantees that no vulnerable infrastructure is provisioned and no sensitive credentials are ever exposed in plaintext.

---

## Architecture

    ┌────────────────────┐      ┌────────────────────┐      ┌────────────────────┐
    │                    │      │                    │      │                    │
    │  Version Control   ├─────►│  Code & Secrets    ├─────►│  IaC & Policy      │
    │  (GitHub / Git)    │      │  Scanning (SAST)   │      │  Validation (OPA)  │
    │                    │      │                    │      │                    │
    └────────────────────┘      └─────────┬──────────┘      └─────────┬──────────┘
                                          │                           │
                                          ▼                           ▼
    ┌────────────────────┐      ┌────────────────────┐      ┌────────────────────┐
    │                    │      │                    │      │                    │
    │  Dynamic Testing   │◄─────┤  App Deployment    │◄─────┤  HashiCorp Vault   │
    │  (DAST / ZAP)      │      │  (Docker)          │      │  (Secrets Engine)  │
    │                    │      │                    │      │                    │
    └────────────────────┘      └────────────────────┘      └────────────────────┘

---

## Prerequisites

- Ubuntu 24.04 LTS
- Docker Engine & Docker Compose v2
- Terraform CLI (v1.0+)
- HashiCorp Vault CLI
- Open Policy Agent (OPA) binary
- Python 3.9+ & virtual environment support

---

## Setup & Installation

    sudo apt update && sudo apt install -y unzip curl wget python3-venv python3-pip

    docker compose -f docker-compose.vault.yml up -d

    sudo sysctl -w vm.max_map_count=262144
    docker compose -f docker-compose.sonarqube.yml up -d

---

## How to Reproduce

### 1. Initialize Secrets Engine

    export VAULT_ADDR='http://127.0.0.1:8200'
    export VAULT_TOKEN='myroot'

    vault secrets enable -path=secret kv-v2

    vault kv put secret/myapp \
      db_user="admin" \
      db_pass="SuperSecretPassword!"

---

### 2. Run Static Code & Dependency Scans

    ./scripts/dependency-check.sh

---

### 3. Validate Infrastructure & Compliance

    ./scripts/terraform-validate.sh
    ./scripts/opa-validate.sh

---

### 4. Execute Dynamic Application Attack (DAST)

    ./scripts/zap-scan.sh

---

## Tools Used

### CI/CD
- Jenkins
- GitHub Actions

### Security Scanning
- SonarQube
- OWASP Dependency Check
- OWASP ZAP
- TruffleHog
- tfsec

### Infrastructure & Policy
- Terraform
- Open Policy Agent (Rego)

### Secret Management
- HashiCorp Vault

### Runtime
- Docker
- Python
- Flask

---

## Key Skills Demonstrated

- End-to-end DevSecOps pipeline automation architecture.
- Implementation of Policy-as-Code for cloud resource governance.
- Dynamic credential injection to eliminate plaintext secret storage.
- Automated Software Composition Analysis (SCA) for CVE mitigation.
- Docker network segmentation for isolated attack simulation.
- Threat modeling using the STRIDE framework.
- Attack surface mapping and runtime validation.

---

## Real-World Use Case

In production engineering environments, developers often push code that depends on unpatched open-source libraries, misconfigured cloud security groups, or hardcoded API tokens.

This platform acts as an automated security gatekeeper by detecting these risks during CI/CD before code reaches production or infrastructure is provisioned in AWS or Azure.

It significantly reduces the Mean Time To Detect (MTTD) vulnerabilities and ensures compliance policies are enforced automatically rather than manually.

---

## Lessons Learned

### Container Networking
Resolving DNS between host services and isolated attack containers requires explicit host gateway mapping in Linux environments.

### Resource Limits
Heavy Java-based scanning engines like SonarQube’s Elasticsearch backend require preemptive kernel tuning (vm.max_map_count) to avoid silent startup failures.

### Dependency Isolation
Global Python package installations on modern Linux systems can corrupt environments. Strict virtual environments improve reproducibility and idempotency.

### Policy Granularity
Rego policies require highly precise Terraform JSON path mapping to accurately detect and block non-compliant infrastructure.

---

## Troubleshooting Log

### Issue: SonarQube container crash on startup
Cause: Elasticsearch memory map limits too low.

Resolution:
    sudo sysctl -w vm.max_map_count=262144

---

### Issue: Docker socket permission denied during Jenkins analysis
Cause: Restricted Docker socket access.

Resolution:
    sudo chmod 666 /var/run/docker.sock

---

### Issue: NVD database synchronization rate limiting
Cause: Initial Dependency Check database sync timing out.

Resolution:
Used cached vulnerability definitions to bypass the initial synchronization for faster validation.

---

### Issue: OWASP ZAP could not resolve local application target
Cause: Container networking isolation.

Resolution:
    --add-host=host.docker.internal:host-gateway

This bridged the containerized attacker to the host application successfully.
