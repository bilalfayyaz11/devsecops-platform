from flask import Flask, request, render_template_string
import sqlite3, os, logging, hashlib
from datetime import datetime

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
                    handlers=[logging.FileHandler('security.log'), logging.StreamHandler()])
security_logger = logging.getLogger('security')
app = Flask(__name__)

def log_security_event(event_type, details, request_info):
    log_entry = {'timestamp': datetime.now().isoformat(), 'event_type': event_type, 'details': details,
                 'ip_address': request_info.remote_addr, 'request_path': request_info.path}
    security_logger.warning(f"SECURITY_EVENT: {log_entry}")

@app.route('/')
def home(): return '<h1>Welcome to Secure DevSecOps Lab</h1><a href="/search">Search Users</a>'

@app.route('/search')
def search():
    query = request.args.get('q', '')
    suspicious_patterns = ["'", '"', 'union', 'select', 'drop', 'delete', 'insert']
    if any(pattern in query.lower() for pattern in suspicious_patterns):
        log_security_event('POTENTIAL_SQL_INJECTION', f'Suspicious query: {query}', request)
    
    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users WHERE name LIKE ?", (f'%{query}%',))
    results = cursor.fetchall()
    conn.close()
    
    from html import escape
    safe_query = escape(query)
    template = f"<h2>Search Results for: {safe_query}</h2><ul>"
    for result in results: template += f"<li>{escape(result[1])}</li>"
    return template + "</ul>"

if __name__ == '__main__': app.run(debug=False, host='127.0.0.1', port=5000)
