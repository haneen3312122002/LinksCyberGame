from flask import Flask, request, jsonify
from flask_cors import CORS
from transformers import AutoTokenizer, AutoModelForSequenceClassification
import torch
import re

app = Flask(__name__)
CORS(app)

# ========== 1. تصنيف الرسائل (AraBERT) ==========
model_name = "aubmindlab/bert-base-arabertv2"
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForSequenceClassification.from_pretrained(model_name, num_labels=5)

@app.route('/classify_message', methods=['POST'])
def classify_message():
    data = request.json
    message = data.get('message', '')

    if not message:
        return jsonify({'error': 'No message provided'}), 400

    inputs = tokenizer(message, return_tensors="pt", padding=True, truncation=True, max_length=512)
    outputs = model(**inputs)
    probabilities = torch.nn.functional.softmax(outputs.logits, dim=-1)
    predicted_label = torch.argmax(probabilities, dim=1).item()

    categories = [
        "الاحتيال الإلكتروني",
        "التنمر الإلكتروني",
        "التحرش أو التهديد",
        "انتحال الشخصية",
        "غير معروف",
    ]
    category = categories[predicted_label]

    return jsonify({
        'original_message': message,
        'category': category
    })


# ========== 2. فحص الرابط ==========
suspicious_domains = ['bit.ly', 'tinyurl.com', 'adf.ly', 'shorte.st']
suspicious_keywords = ['free', 'bonus', 'click', 'download', 'hack', 'prize']

def is_suspicious_link(link):
    if not link.startswith('https'):
        return 'not secure'
    if any(domain in link for domain in suspicious_domains):
        return 'suspicious domain'
    if any(keyword in link.lower() for keyword in suspicious_keywords):
        return 'suspicious keyword'
    if len(link) > 100:
        return 'link too long'
    return 'secure'

@app.route('/check_link', methods=['GET'])
def check_link():
    link = request.args.get('link')
    if not link or link.strip() == "":
        return jsonify({'error': 'No link provided'}), 400
    result = is_suspicious_link(link)
    return jsonify({'result': result})


# ========== 3. فحص قوة كلمة المرور ==========
def check_password_strength(password, personal_info):
    if len(password) < 8:
        return 'Weak'
    if any(info and info in password for info in personal_info.values()):
        return 'You are using personal info'
    if (
        any(char.islower() for char in password) and
        any(char.isupper() for char in password) and
        any(char.isdigit() for char in password) and
        any(char in '!@#$%^&*()' for char in password)
    ):
        return 'Strong'
    return 'Mid'

@app.route('/check_password_and_info', methods=['POST'])
def check_password_and_info():
    try:
        data = request.get_json()
        password = data.get('passwordKey')
        personal_info = data.get('InfoKey')

        if not password or not personal_info:
            return jsonify({'error': 'Password and personal information are required'}), 400
        if not isinstance(personal_info, dict):
            return jsonify({'error': 'Personal information must be a dictionary'}), 400

        strength = check_password_strength(password, personal_info)
        return jsonify({'strength': strength}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500


# ========== 4. مقارنة كلمة مشفرة ==========
def encrypt_word(word, key):
    encrypted = ''
    for char in word:
        if char.isalpha():
            base = ord('a') if char.islower() else ord('A')
            shifted = (ord(char) - base + key) % 26 + base
            encrypted += chr(shifted)
        else:
            encrypted += char
    return encrypted

@app.route('/compare_word', methods=['POST'])
def compare_word():
    data = request.get_json()
    collected_word = data.get('collected_word', '').lower()
    displayed_word = data.get('displayed_word', '').lower()
    key = data.get('key')

    if not collected_word or not displayed_word or key is None:
        return jsonify({'error': 'Missing parameters'}), 400

    try:
        key = int(key)
    except ValueError:
        return jsonify({'error': 'Key must be an integer'}), 400

    encrypted_word = encrypt_word(displayed_word, key)
    result = (collected_word == encrypted_word)
    return jsonify({'result': result}), 200


# ========== تشغيل السيرفر ==========
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
