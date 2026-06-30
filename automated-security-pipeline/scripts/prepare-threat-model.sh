#!/bin/bash
echo "=== Preparing Threat Model Data ==="

cat > threat-model/stride-analysis.md << 'STRIDE_EOF'
# STRIDE Threat Analysis

## Spoofing
- **Threat**: Attacker impersonates legitimate user
- **Mitigation**: Strong authentication, multi-factor authentication

## Tampering
- **Threat**: Unauthorized modification of data or code
- **Mitigation**: Input validation, integrity checks, code signing

## Information Disclosure
- **Threat**: Unauthorized access to sensitive information
- **Mitigation**: Encryption, HashiCorp Vault, data classification
STRIDE_EOF

cat > threat-model/attack-surface.md << 'ATTACK_EOF'
# Attack Surface Analysis

## External Attack Surface
- **Entry Points**: HTTP/HTTPS endpoints
- **Attack Vectors**: Injection attacks, XSS, CSRF
- **Risk Level**: High

## Internal Attack Surface
- **Entry Points**: Container runtime, Environment variables
- **Attack Vectors**: Container escape, Secret exposure
- **Risk Level**: Medium
ATTACK_EOF

cat > threat-model/threat-scenarios.md << 'SCENARIOS_EOF'
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
SCENARIOS_EOF

echo "Threat model documentation generated successfully in threat-model/"
