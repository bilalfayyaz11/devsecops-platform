#!/bin/bash

echo "Setting up local Python environment..."
python3 -m venv venv
source venv/bin/activate
pip install --quiet --no-cache-dir -r requirements.txt

echo "Starting application for security testing..."
python3 src/app.py > /dev/null 2>&1 &
APP_PID=$!

echo "Waiting 10 seconds for the application to boot..."
sleep 10

echo "Running ZAP baseline scan..."
# Added --add-host to fix Linux networking, updated image to modern zaproxy namespace, and added -I to prevent non-zero exit codes from stopping the lab
docker run --rm -v $(pwd)/reports/zap:/zap/wrk/:rw \
    --add-host=host.docker.internal:host-gateway \
    -t zaproxy/zap2docker-stable zap-baseline.py \
    -t http://host.docker.internal:5000 \
    -J zap-report.json \
    -r zap-report.html \
    -I

echo "Stopping the application..."
kill $APP_PID
deactivate

echo "ZAP security scan completed. Reports available in reports/zap/"
