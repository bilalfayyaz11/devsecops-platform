#!/bin/bash
echo "=== Terraform Security Validation ==="
cd infrastructure/terraform

echo "1. Checking Terraform formatting..."
terraform fmt -check -recursive || echo "Formatting needs adjustment, but continuing..."

echo "2. Validating Terraform configuration..."
terraform validate

echo "3. Running security scan with tfsec..."
tfsec . --format lovely

echo "4. Creating and validating Terraform plan..."
terraform plan -out=tfplan

if [ -f "../../policies/terraform.rego" ]; then
    echo "5. Validating against OPA policies..."
    terraform show -json tfplan > tfplan.json
    opa eval -d ../../policies -i tfplan.json "data.terraform.deny[x]"
fi
echo "=== Terraform validation completed ==="
