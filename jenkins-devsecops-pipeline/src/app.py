from flask import Flask, request, render_template_string
import sqlite3, os
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'secure-production-key-123')

@app.route('/')
def home():
    return '''<h1>DevSecOps Demo Application (Secured)</h1>
    <form action="/search" method="post">
        <input type="text" name="query" placeholder="Search users"><input type="submit" value="Search">
    </form>'''

@app.route('/search', methods=['POST'])
def search():
    query = request.form['query']
    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()
    # SECURED: Parameterized Query
    cursor.execute("SELECT * FROM users WHERE name LIKE ?", (f'%{query}%',))
    results = cursor.fetchall()
    conn.close()
    return f"<h2>Search Results:</h2><p>{results}</p>"

@app.route('/admin')
def admin():
    # SECURED: Removed hardcoded password
    return "Admin panel - Please authenticate securely via SSO"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
