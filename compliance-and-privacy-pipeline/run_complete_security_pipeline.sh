#!/bin/bash
echo "========================================="
echo "DevSecOps Complete Security Pipeline"
echo "========================================="

# Activate virtual environment to prevent global pip errors
source venv/bin/activate

echo -e "\n[0/5] Initializing mock database for InSpec checks..."
python3 -c "import sys; sys.path.append('src'); import app; app.init_db()"

echo -e "\n[1/5] Running SAST (Bandit & Safety)..."
pip install --quiet bandit safety==2.3.5
bandit -r src/ -f json -o security/bandit-report.json --quiet || echo "Bandit found potential code flaws."
safety check --json --output security/safety-report.json >/dev/null 2>&1 || echo "Safety found vulnerable dependencies."

echo -e "\n[2/5] Running DAST & Code Inspection (security_tests.py)..."
python3 security/security_tests.py || true

echo -e "\n[3/5] Running OpenSCAP Infrastructure Compliance..."
cd security
./compliance_scan.sh > /dev/null 2>&1 || true
echo "OpenSCAP scan complete."

echo -e "\n[4/5] Running InSpec Privacy Checks..."
./privacy_check.sh || true

echo -e "\n[5/5] Generating Security Dashboard..."
python3 security_dashboard.py

echo -e "\n========================================="
echo "Pipeline Complete! Dashboard available at: security/security_dashboard.html"
deactivate
