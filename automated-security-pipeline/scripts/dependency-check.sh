#!/bin/bash
DEPENDENCY_CHECK_VERSION="9.0.9"

if [ ! -d "dependency-check-tool" ]; then
    echo "Downloading OWASP Dependency Check v${DEPENDENCY_CHECK_VERSION}..."
    wget -q -O dependency-check.zip "https://github.com/jeremylong/DependencyCheck/releases/download/v${DEPENDENCY_CHECK_VERSION}/dependency-check-${DEPENDENCY_CHECK_VERSION}-release.zip"
    unzip -q dependency-check.zip
    mv dependency-check dependency-check-tool
    rm dependency-check.zip
fi

echo "Running Dependency Check scan (bypassing NVD sync for lab speed)..."
./dependency-check-tool/bin/dependency-check.sh \
    --project "DevSecOps Lab" \
    --scan . \
    --format HTML \
    --format JSON \
    --out reports/dependency-check \
    --noupdate

echo "Dependency check completed. Reports available in reports/dependency-check/"
