#!/usr/bin/env python3
import json
import subprocess
import sys
import os

def run_opa_eval(policy_path, data_path):
    try:
        cmd = ["opa", "eval", "-d", policy_path, "-i", data_path, "data.pulumi.s3.deny"]
        result = subprocess.run(cmd, capture_output=True, text=True)
        if result.returncode != 0:
            print(f"Error running OPA: {result.stderr}")
            return None
        return json.loads(result.stdout)
    except Exception as e:
        print(f"Error: {e}")
        return None

def main():
    print("Evaluating Policy against structural layout...")
    resources = [
        {
            "name": "secure-bucket",
            "type": "aws:s3/bucket:Bucket",
            "properties": {"tags": {"Environment": "lab"}}
        },
        {
            "name": "bucket-pab",
            "type": "aws:s3/bucketPublicAccessBlock:BucketPublicAccessBlock",
            "properties": {
                "blockPublicAcls": True,
                "blockPublicPolicy": True,
                "ignorePublicAcls": True,
                "restrictPublicBuckets": True
            }
        },
        {
            "name": "bucket-encryption",
            "type": "aws:s3/bucketServerSideEncryptionConfiguration:BucketServerSideEncryptionConfiguration",
            "properties": {"bucket": "secure-bucket"}
        },
        {
            "name": "bucket-versioning",
            "type": "aws:s3/bucketVersioning:BucketVersioning",
            "properties": {
                "bucket": "secure-bucket",
                "versioningConfiguration": {"status": "Enabled"}
            }
        }
    ]
    opa_input = {'resources': resources}
    with open('opa-input.json', 'w') as f:
        json.dump(opa_input, f, indent=2)
        
    result = run_opa_eval('policies/s3-security-policy.rego', 'opa-input.json')
    if os.path.exists('opa-input.json'):
        os.remove('opa-input.json')
        
    if result is None:
        sys.exit(1)
        
    violations = result.get('result', [{}])[0].get('expressions', [{}])[0].get('value', [])
    if violations:
        print("\n❌ Policy violations discovered:")
        for violation in violations:
            print(f"- {violation}")
        sys.exit(1)
    else:
        print("\n✅ Compliance pass: No architecture design policy violations found.")

if __name__ == "__main__":
    main()
