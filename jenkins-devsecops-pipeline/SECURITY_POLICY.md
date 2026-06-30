# DevSecOps Security Policy
1. All code must pass Bandit SAST scanning.
2. Dependencies must be audited via OWASP Dependency-Check.
3. No secrets may be hardcoded into the source code.
4. Pre-commit hooks must enforce code formatting and secret detection.
