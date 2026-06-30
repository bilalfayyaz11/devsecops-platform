import hvac
import sys

# Initialize the client pointing to our local container
client = hvac.Client(url='http://127.0.0.1:8200', token='myroot')

# Check authentication status
if not client.is_authenticated():
    print("Authentication to Vault failed.")
    sys.exit(1)

# Retrieve the secret we stored earlier
try:
    secret_response = client.secrets.kv.v2.read_secret_version(path='myapp')
    credentials = secret_response['data']['data']
    print("\n=== VAULT READ SUCCESS ===")
    print(f"Retrieved Username: {credentials['db_user']}")
    print(f"Retrieved Password: {credentials['db_pass']}")
except Exception as e:
    print(f"Failed to read secret: {e}")
    sys.exit(1)
