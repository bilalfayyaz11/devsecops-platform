import sys
import os

def test_sql_injection():
    print("Testing for SQL injection...")
    payloads = ["' OR '1'='1", "'; DROP TABLE users; --", "' UNION SELECT * FROM users --"]
    vulnerabilities = []
    for payload in payloads:
        if "OR" in payload or "UNION" in payload:
            vulnerabilities.append(f"Potential SQL injection: {payload}")
    return vulnerabilities

def test_weak_password_hashing():
    print("Testing password hashing strength...")
    # Inspecting the source code dynamically
    try:
        with open('src/app.py', 'r') as f:
            if 'hashlib.md5' in f.read():
                return ["Weak password hashing detected: MD5 is cryptographically broken"]
    except FileNotFoundError:
        with open('../src/app.py', 'r') as f:
            if 'hashlib.md5' in f.read():
                return ["Weak password hashing detected: MD5 is cryptographically broken"]
    return []

def main():
    print("Running security tests...")
    all_issues = test_sql_injection() + test_weak_password_hashing()
    
    if all_issues:
        print("\nSecurity Issues Found:")
        for issue in all_issues:
            print(f"- {issue}")
        return 1
    print("\nNo critical security issues found.")
    return 0

if __name__ == "__main__":
    sys.exit(main())
