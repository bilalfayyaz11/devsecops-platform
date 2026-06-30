from flask import Flask, request, jsonify, session
import sqlite3
import hashlib

app = Flask(__name__)
app.secret_key = 'your-secret-key'

def init_db():
    conn = sqlite3.connect('users.db')
    c = conn.cursor()
    c.execute('''CREATE TABLE IF NOT EXISTS users
                 (id INTEGER PRIMARY KEY, username TEXT, password TEXT, email TEXT)''')
    conn.commit()
    conn.close()

@app.route('/register', methods=['POST'])
def register():
    username = request.json.get('username')
    password = request.json.get('password')
    email = request.json.get('email')
    
    # INTENTIONAL VULNERABILITY: Weak Hashing (MD5)
    hashed_password = hashlib.md5(password.encode()).hexdigest()
    
    conn = sqlite3.connect('users.db')
    c = conn.cursor()
    # INTENTIONAL VULNERABILITY: SQL Injection risk (though parameterized here, we test it later)
    c.execute("INSERT INTO users (username, password, email) VALUES (?, ?, ?)",
              (username, hashed_password, email))
    conn.commit()
    conn.close()
    
    return jsonify({"message": "User registered successfully"})

@app.route('/login', methods=['POST'])
def login():
    username = request.json.get('username')
    password = request.json.get('password')
    
    hashed_password = hashlib.md5(password.encode()).hexdigest()
    
    conn = sqlite3.connect('users.db')
    c = conn.cursor()
    c.execute("SELECT * FROM users WHERE username=? AND password=?",
              (username, hashed_password))
    user = c.fetchone()
    conn.close()
    
    if user:
        session['user_id'] = user[0]
        return jsonify({"message": "Login successful"})
    else:
        return jsonify({"message": "Invalid credentials"}), 401

if __name__ == '__main__':
    init_db()
    app.run(debug=True, host='0.0.0.0')
