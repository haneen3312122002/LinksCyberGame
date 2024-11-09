from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # This enables CORS for all routes and methods

# Function to check the strength of the password
def check_password_strength(password, personal_info):
    if len(password) < 8:
        return 'Weak'
    
    elif any(info in password for info in personal_info.values()):
        return 'You are using personal info'
    
    elif (
        any(char.islower() for char in password) and
        any(char.isupper() for char in password) and
        any(char.isdigit() for char in password) and
        any(char in '!@#$%^&*()' for char in password)
    ):
        return 'Strong'
    else:
        return 'Mid'

@app.route('/check_password_and_info', methods=['POST'])
def check_password_and_info():
    data = request.get_json()  # Get JSON data from the request body
    password = data.get('password')
    personal_info = data.get('personalInfo')

    # Ensure that both password and personal information are provided
    if not password or not personal_info:
        return jsonify({'error': 'Password and personal information are required'}), 400

    # Check the password strength
    strength = check_password_strength(password, personal_info)
    return jsonify({'strength': strength})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)