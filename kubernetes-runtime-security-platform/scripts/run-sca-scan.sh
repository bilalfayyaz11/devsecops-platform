#!/bin/bash
echo "Starting Software Composition Analysis..."
mkdir -p sca-reports
dependency-check --project "DevSecOps Demo App" --scan . --format JSON --format HTML --format XML --out ./sca-reports/
echo "SCA scan completed."
