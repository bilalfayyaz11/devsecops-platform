#!/bin/bash
echo "Starting Dynamic Application Security Testing..."
mkdir -p dast-reports
docker run -d --name dast-test-app -p 3000:3000 devsecops-demo:latest
sleep 15
if curl -s http://localhost:3000/health > /dev/null; then
    echo "Application running. Starting ZAP..."
    # Using --network host for Linux compatibility
    docker run --network host -v $(pwd)/dast-reports:/zap/wrk/:rw -t owasp/zap2docker-stable zap-baseline.py -t http://localhost:3000 -J dast-report.json -r dast-report.html
else
    echo "Application failed to start."
fi
docker stop dast-test-app 2>/dev/null && docker rm dast-test-app 2>/dev/null
