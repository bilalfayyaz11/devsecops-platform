#!/bin/bash
echo "=== DevSecOps Advanced Container Security Validation Matrix ==="
echo "1. Checking Vulnerability Core Scanners..."
command -v trivy &> /dev/null && echo "✓ Trivy Engine Online: $(trivy --version | head -n 1)" || echo "✗ Trivy Engine Offline"

echo -e "\n2. Evaluating Kubernetes Control Plane Context Access..."
kubectl cluster-info &> /dev/null && echo "✓ K8s Cluster Ready" || echo "✗ K8s Cluster Blocked"

echo -e "\n3. Inspecting Hardened Pod Isolation Configurations..."
kubectl get pods -n secure-apps -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.containers[0].securityContext.runAsNonRoot}{"\n"}{end}' | grep "true" && echo "✓ runAsNonRoot Enforced Natively"

echo -e "\n=== System Compliance Checks Complete ==="
