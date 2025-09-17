from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Enables CORS for all routes and methods

# Function to check the strength of the password
def check_password_strength(password, personal_info):
    print(f"Debug: Checking password '{password}' against personal info {personal_info}")
    
    # 1) Check minimum length
    if len(password) < 8:
        print("Debug: Password is too short")
        return 'Weak'
    
    # 2) Check if personal info is part of the password
    #    If any personal info string is present in the password, return 'You are using personal info'
    if any(info and info in password for info in personal_info.values()):
        print("Debug: Password contains personal information")
        return 'You are using personal info'
    
    # 3) Check for uppercase, lowercase, digit, special char
    if (
        any(char.islower() for char in password) and
        any(char.isupper() for char in password) and
        any(char.isdigit() for char in password) and
        any(char in '!@#$%^&*()' for char in password)
    ):
        print("Debug: Password meets strong criteria")
        return 'Strong'
    
    # 4) If not Strong, but >=8 chars, call it 'Mid'
    print("Debug: Password is medium strength")
    return 'Mid'

@app.route('/check_password_and_info', methods=['POST'])
def check_password_and_info():
    try:
        data = request.get_json()  # Get JSON data from the request body
        print(f"Debug: Received data {data}")

        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        password = data.get('passwordKey')  # Expect 'passwordKey' from Flutter
        personal_info = data.get('InfoKey') # Expect 'InfoKey' from Flutter

        if not password or not personal_info:
            return jsonify({'error': 'Password and personal information are required'}), 400
        
        if not isinstance(personal_info, dict):
            return jsonify({'error': 'Personal information must be a dictionary'}), 400

        # Evaluate the password strength
        strength = check_password_strength(password, personal_info)
        print(f"Debug: Password strength is {strength}")
        return jsonify({'strength': strength}), 200

    except Exception as e:
        print(f"Debug: Exception occurred - {e}")
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    # Adjust host/port to match your needs
    app.run(host='0.0.0.0', port=5000, debug=True)
