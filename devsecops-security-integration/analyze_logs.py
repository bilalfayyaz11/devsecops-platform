import json, re
from collections import Counter

def analyze_security_logs():
    events = []
    try:
        with open('security.log', 'r') as f:
            for line in f:
                if 'SECURITY_EVENT' in line:
                    match = re.search(r'SECURITY_EVENT: ({.*})', line)
                    if match:
                        try: events.append(json.loads(match.group(1).replace("'", '"')))
                        except: continue
    except FileNotFoundError: return
    if not events: return
    
    print("\n=== Security Log Analysis ===")
    print(f"Total events: {len(events)}")
    print("Top IPs:")
    for ip, count in Counter(e['ip_address'] for e in events).most_common(5): print(f"  {ip}: {count}")

if __name__ == '__main__': analyze_security_logs()
