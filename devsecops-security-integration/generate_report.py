#!/usr/bin/env python3
import json, os
from datetime import datetime

def gen_report():
    report = {'timestamp': datetime.now().isoformat(), 'project': 'DevSecOps App', 'summary': {'total': 0}}
    if os.path.exists('bandit-report.json'):
        with open('bandit-report.json') as f:
            data = json.load(f)
            report['summary']['total'] = len(data.get('results', []))
    print(f"\n=== FINAL SECURITY REPORT ===\nGenerated: {report['timestamp']}\nTotal Code Issues Found: {report['summary']['total']}")
    print("Recommendations: \n1. Fix SQLi \n2. Fix XSS \n3. Automate Scans")

if __name__ == '__main__': gen_report()
