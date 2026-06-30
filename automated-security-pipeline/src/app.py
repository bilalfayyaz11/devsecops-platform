from flask import Flask, request, jsonify
import os

app = Flask(__name__)

@app.route('/')
def hello():
    return "Hello DevSecOps World!"

@app.route('/api/data')
def get_data():
    # Intentional vulnerability for demonstration
    user_input = request.args.get('input', '')
    return f"You entered: {user_input}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
