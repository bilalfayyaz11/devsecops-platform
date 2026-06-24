from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def hello():
    return '<h1>Secure Container Demo Application</h1><p>This application is running in a secured container!</p>'

@app.route('/health')
def health():
    return {'status': 'healthy', 'version': '1.0.0'}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
