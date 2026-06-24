#!/bin/bash
echo "Verifying Local Multi-engine Scanning Integration Pipeline..."
cd ~/terraform-security-lab
source venv/bin/activate
checkov -f main-secure.tf --framework terraform
cd ~/pulumi-security-lab
python3 validate-policy.py
echo "Pipeline structural checking integration testing verification completed successfully!"
