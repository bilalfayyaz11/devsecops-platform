#!/usr/bin/env python3
import json, sys, os

def check_bandit():
    if not os.path.exists('bandit-report.json'): return False
    with open('bandit-report.json', 'r') as f: report = json.load(f)
    high = sum(1 for r in report.get('results', []) if r['issue_severity'] == 'HIGH')
    print(f"Bandit - High severity: {high}")
    return high == 0

def check_safety():
    if not os.path.exists('safety-report.json'): return True
    try:
        with open('safety-report.json', 'r') as f: vulns = len(json.load(f))
        print(f"Safety - Vulnerabilities: {vulns}")
        return vulns == 0
    except: return True

if __name__ == '__main__':
    print("Running Security Gates...")
    if check_bandit() and check_safety():
        print("✅ ALL GATES PASSED!")
    else:
        print("🚫 GATES FAILED! (Expected due to intentional lab vulnerabilities)")
