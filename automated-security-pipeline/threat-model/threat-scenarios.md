# Threat Scenarios

## Scenario 1: Malicious User Input
- **Description**: Attacker submits malicious input to exploit application vulnerabilities
- **Impact**: Data breach, system compromise
- **Mitigation**: Input validation, output encoding, WAF

## Scenario 2: Secret Exposure
- **Description**: Hardcoded credentials or exposed environment variables
- **Impact**: Unauthorized access to databases and external services
- **Mitigation**: HashiCorp Vault integration, secret scanning (TruffleHog)

## Scenario 3: Container Escape
- **Description**: Attacker breaks out of the Docker container to host OS
- **Impact**: Full infrastructure compromise
- **Mitigation**: Drop privileges, non-root user, OPA policies
