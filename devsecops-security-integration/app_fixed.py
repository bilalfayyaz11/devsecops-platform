from flask import Flask, request, escape
import sqlite3, secrets

app = Flask(__name__)
app.secret_key = secrets.token_hex(16)

@app.after_request
def headers(response):
    response.headers['X-Content-Type-Options'] = 'nosniff'
    response.headers['X-Frame-Options'] = 'DENY'
    return response

@app.route('/search')
def search():
    query = request.args.get('q', '')
    if len(query) > 100: return "Query too long", 400
    conn = sqlite3.connect('users.db')
    c = conn.cursor()
    c.execute("SELECT id, name, email FROM users WHERE name LIKE ? LIMIT 10", (f'%{query}%',))
    results = c.fetchall()
    conn.close()
    
    template = f"<h2>Search Results for: {escape(query)}</h2><ul>"
    for r in results: template += f"<li>{escape(r[1])} ({escape(r[2])})</li>"
    return template + "</ul>"

if __name__ == '__main__': app.run(debug=False, port=5000)
