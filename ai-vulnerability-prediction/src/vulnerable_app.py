import os
import sqlite3
import hashlib
from flask import Flask, request, render_template_string

app = Flask(__name__)

# Hardcoded secret (security issue)
SECRET_KEY = "hardcoded-secret-key-123"
DATABASE_PASSWORD = "admin123"

@app.route('/login', methods=['POST'])
def login():
    username = request.form['username']
    password = request.form['password']
    
    # SQL Injection vulnerability
    query = f"SELECT * FROM users WHERE username='{username}' AND password='{password}'"
    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()
    cursor.execute(query)
    result = cursor.fetchone()
    
    if result:
        return "Login successful"
    else:
        return "Login failed"

@app.route('/profile')
def profile():
    user_input = request.args.get('name', '')
    # XSS vulnerability
    template = f"<h1>Welcome {user_input}</h1>"
    return render_template_string(template)

@app.route('/file')
def read_file():
    filename = request.args.get('file', '')
    # Path traversal vulnerability
    with open(f"/var/www/uploads/{filename}", 'r') as f:
        return f.read()

if __name__ == '__main__':
    # Debug mode in production (security issue)
    app.run(debug=True, host='0.0.0.0')
