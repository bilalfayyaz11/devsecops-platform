from flask import Flask, request, render_template_string
import sqlite3
import os

app = Flask(__name__)

@app.route('/')
def home():
    return '<h1>Welcome to DevSecOps Lab</h1><a href="/search">Search Users</a>'

@app.route('/search')
def search():
    query = request.args.get('q', '')
    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()
    sql = f"SELECT * FROM users WHERE name LIKE '%{query}%'"
    cursor.execute(sql)
    results = cursor.fetchall()
    conn.close()
    
    template = f"<h2>Search Results for: {query}</h2><ul>"
    for result in results:
        template += f"<li>{result[1]}</li>"
    template += "</ul>"
    
    return render_template_string(template)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
