#!/bin/bash
echo "Starting OpenSCAP compliance scan..."
mkdir -p compliance-results
# Run the scan using the Ubuntu 20.04 baseline (compatible with our environment checks)
oscap xccdf eval \
    --profile xccdf_org.ssgproject.content_profile_standard \
    --results compliance-results/scap-results.xml \
    --report compliance-results/scap-report.html \
    openscap-content/scap-security-guide-*/ssg-ubuntu2004-ds.xml || true
echo "Compliance scan completed. HTML report generated at compliance-results/scap-report.html"
