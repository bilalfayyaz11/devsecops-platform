#!/bin/bash
echo "Starting Terraform security scanning with TFSec..."
mkdir -p iac-reports
tfsec terraform/ --format json --out iac-reports/tfsec-report.json
tfsec terraform/ --format html --out iac-reports/tfsec-report.html
echo "TFSec scan completed."
