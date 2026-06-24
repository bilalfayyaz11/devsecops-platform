#!/bin/bash
IMAGE_NAME=$1
SEVERITY_THRESHOLD="CRITICAL,HIGH"

if [ -z "$IMAGE_NAME" ]; then
    echo "Usage: $0 <image-name>"
    exit 1
fi

echo "=== SCANNING TARGET ARTIFACT: $IMAGE_NAME ==="
trivy image --severity $SEVERITY_THRESHOLD --format table $IMAGE_NAME

# Query JSON payload to catch critical counts securely using jq
CRITICAL_COUNT=$(trivy image --severity CRITICAL --format json $IMAGE_NAME | jq '[.Results[].Vulnerabilities[]? | select(.Severity=="CRITICAL")] | length')

if [ -z "$CRITICAL_COUNT" ] || [ "$CRITICAL_COUNT" -eq 0 ]; then
    echo "✅ SUCCESS: Zero CRITICAL issues found. Artifact cleared for code signing."
    exit 0
else
    echo "❌ ERROR: Intercepted $CRITICAL_COUNT CRITICAL security gaps. Aborting build pipeline pipeline pipeline."
    exit 1
fi
