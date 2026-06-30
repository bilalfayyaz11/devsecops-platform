# DevSecOps Security Integration & Quality Gates

## What This Does

This project demonstrates an end-to-end automated DevSecOps pipeline. It takes an intentionally vulnerable Python web application (susceptible to SQL Injection and XSS) and integrates a full gauntlet of security scanners including SAST, SCA, DAST, and Container Scanning.

It establishes automated Git pre-commit hooks and custom Python-based security gates to block vulnerable code from being deployed, culminating in a hardened and secure version of the application.

---

## Architecture

    ┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
    │  Developer Push │     │  Code Security  │     │   Runtime &     │
    │  (Git Hooks &   ├────►│  (Bandit SAST & ├────►│   Containers    │
    │  GitHub Actions)│     │  Safety SCA)    │     │  (ZAP & Trivy)  │
    └─────────────────┘     └─────────────────┘     └────────┬────────┘
                                                             │
                                                             ▼
    ┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
    │   Remediation   │     │                 │     │                 │
    │   & Hardened    │◄────┤  HTML/JSON      │◄────┤ Python Security │
    │   Application   │     │  Security Report│     │ Quality Gates   │
    └─────────────────┘     └─────────────────┘     └─────────────────┘

---

## Tools Used

### Static Application Security Testing (SAST)
- Bandit

### Software Composition Analysis (SCA)
- Safety

### Dynamic Application Security Testing (DAST)
- OWASP ZAP (Dockerized)

### Container Vulnerability Scanning
- Trivy

### Automation & Orchestration
- Git Hooks
- GitHub Actions
- Python

### Application Stack
- Python
- Flask
- SQLite

---

## Key Skills Demonstrated

### Shift-Left Security
Implemented Git pre-commit hooks to block developers from committing code with known SAST/SCA violations before entering version control.

### Custom Security Gates
Engineered Python scripts that parse JSON scanner reports to programmatically fail CI/CD pipelines when High or Critical vulnerabilities are detected.

### Dynamic Attack Simulation
Orchestrated OWASP ZAP against a live local Docker network to identify runtime vulnerabilities under realistic attack scenarios.

### Vulnerability Remediation
Refactored vulnerable SQL query logic and unsafe HTML rendering into parameterized database operations and escaped output encoding to mitigate SQL Injection and Cross-Site Scripting.

### Security Observability
Injected custom Python logging handlers to detect and flag suspicious payloads such as SQL syntax patterns in web form inputs in real time.

---

## Real-World Use Case

In modern software engineering, manual security reviews create major bottlenecks and often fail to scale.

This pipeline represents how enterprise platform teams automate security controls. If a developer introduces a weak cryptographic hashing algorithm or imports a compromised open-source dependency, the CI/CD pipeline (via Bandit and Safety) immediately fails the build and generates a detailed security report before the code reaches staging or production.

This significantly reduces risk exposure and improves development velocity without sacrificing security.

---

## Remediation Showcase

This repository contains two versions of the application:

### app.py
The intentionally vulnerable version containing:

- Raw SQL string concatenation
- Unsanitized user input
- Unescaped HTML templates
- Weak security controls

### app_fixed.py
The hardened and secure version containing:

- Strict parameterized database queries
- html.escape output encoding
- Secure Content Security Policy (CSP) headers
- Cryptographically secure secret key generation
- Improved request validation and input sanitization

---

## Security Workflow Summary

1. Developer writes code.
2. Git pre-commit hooks run Bandit and Safety.
3. GitHub Actions execute automated CI/CD security scans.
4. Trivy scans the container image for OS/package vulnerabilities.
5. OWASP ZAP attacks the live application in Docker.
6. Python security gates parse all reports.
7. Pipeline blocks deployment if vulnerabilities exceed policy thresholds.
8. Secure code is deployed only after passing all gates.

