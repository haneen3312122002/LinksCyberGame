# -------------------------------------------------------------------
# Combined Flask API for All Services
# -------------------------------------------------------------------
from flask import Flask, request, jsonify
from flask_cors import CORS
from textblob import TextBlob
from googletrans import Translator
from transformers import AutoTokenizer, AutoModelForSequenceClassification
import torch
import re

# --- 1. App Initialization ---
app = Flask(__name__)
# Enable CORS to allow requests from your Flutter app
CORS(app)

# --- 2. Model and Service Initialization ---
# Initialize models and services once to avoid reloading on every request

# For Sentiment Analysis
translator = Translator()

# For Phishing/Spam Message Classification
try:
    model_name = "aubmindlab/bert-base-arabertv2"
    tokenizer_arabert = AutoTokenizer.from_pretrained(model_name)
    model_arabert = AutoModelForSequenceClassification.from_pretrained(model_name, num_labels=5)
    print("AraBERT model loaded successfully.")
except Exception as e:
    print(f"Could not load AraBERT model. Error: {e}")
    tokenizer_arabert = None
    model_arabert = None

# --- 3. Helper Functions ---

# Helper for Sentiment Analysis
def analyze_sentiment_helper(comment):
    """Translates Arabic to English and analyzes sentiment."""
    try:
        translated_text = translator.translate(comment, src="ar", dest="en").text
        blob = TextBlob(translated_text)
        polarity = blob.sentiment.polarity  # Range: -1 to +1

        if polarity > 0.1:
            return "إيجابي"
        elif polarity < -0.1:
            return "سلبي"
        else:
            return "محايد"
    except Exception as e:
        print(f"Sentiment analysis error: {e}")
        return "خطأ في التحليل"

# Helper for Link Analysis
suspicious_domains = ['bit.ly', 'tinyurl.com', 'adf.ly', 'shorte.st']
suspicious_keywords = ['free', 'bonus', 'click', 'download', 'hack', 'prize', 'win']

def is_suspicious_link_helper(link):
    """Checks a link against several security criteria."""
    if not link.startswith('https://'):
        return 'غير آمن (لا يستخدم https)'
    if any(domain in link for domain in suspicious_domains):
        return 'نطاق مشبوه (رابط مختصر)'
    if any(keyword in link.lower() for keyword in suspicious_keywords):
        return 'كلمة مفتاحية مشبوهة'
    if len(link) > 100:
        return 'الرابط طويل جدًا'
    return 'آمن'

# Helper for Caesar Cipher Encryption (Word Comparison Game)
def encrypt_word_helper(word, key):
    """Encrypts a word using Caesar cipher."""
    encrypted = ''
    for char in word:
        if char.isalpha():
            base = ord('a') if char.islower() else ord('A')
            shifted = (ord(char) - base + key) % 26 + base
            encrypted += chr(shifted)
        else:
            encrypted += char
    return encrypted

# Helper for Password Strength
def check_password_strength_helper(password, personal_info):
    """Checks password strength against multiple criteria."""
    if len(password) < 8:
        return 'ضعيفة (قصيرة جدًا)'
    if any(info and info in password for info in personal_info.values()):
        return 'ضعيفة (تحتوي على معلومات شخصية)'
    if (any(c.islower() for c in password) and
        any(c.isupper() for c in password) and
        any(c.isdigit() for c in password) and
        any(c in '!@#$%^&*()' for c in password)):
        return 'قوية'
    return 'متوسطة'

# --- 4. API Endpoints ---

@app.route('/analyze_sentiment', methods=['POST'])
def analyze_sentiment_route():
    try:
        data = request.json
        comment = data.get('comment', '')
        if not comment:
            return jsonify({"error": "No comment provided"}), 400
        result = analyze_sentiment_helper(comment)
        return jsonify({"sentiment": result})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/check_link', methods=['GET'])
def check_link_route():
    link = request.args.get('link')
    if not link or not link.strip():
        return jsonify({'error': 'No link provided'}), 400
    result = is_suspicious_link_helper(link)
    return jsonify({'result': result})

@app.route('/compare_word', methods=['POST'])
def compare_word_route():
    data = request.get_json()
    if not data:
        return jsonify({'error': 'Invalid JSON data'}), 400

    collected_word = data.get('collected_word', '').lower()
    displayed_word = data.get('displayed_word', '').lower()
    key = data.get('key')

    if not all([collected_word, displayed_word, key is not None]):
        return jsonify({'error': 'Missing parameters'}), 400

    try:
        key = int(key)
        encrypted_word = encrypt_word_helper(displayed_word, key)
        result = (collected_word == encrypted_word)
        return jsonify({'result': result})
    except ValueError:
        return jsonify({'error': 'Key must be an integer'}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/check_password', methods=['POST'])
def check_password_route():
    try:
        data = request.get_json()
        if not data:
            return jsonify({'error': 'No data provided'}), 400

        password = data.get('passwordKey')
        personal_info = data.get('InfoKey')

        if not password or not personal_info:
            return jsonify({'error': 'Password and personal info are required'}), 400
        if not isinstance(personal_info, dict):
            return jsonify({'error': 'Personal info must be a dictionary'}), 400

        strength = check_password_strength_helper(password, personal_info)
        return jsonify({'strength': strength})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/classify_message', methods=['POST'])
def classify_message_route():
    if not model_arabert or not tokenizer_arabert:
         return jsonify({'error': 'AI model is not available'}), 503

    data = request.json
    message = data.get('message', '')
    if not message:
        return jsonify({'error': 'No message provided'}), 400

    try:
        inputs = tokenizer_arabert(message, return_tensors="pt", padding=True, truncation=True, max_length=512)
        with torch.no_grad():
            outputs = model_arabert(**inputs)
        
        probabilities = torch.nn.functional.softmax(outputs.logits, dim=-1)
        predicted_label_index = torch.argmax(probabilities, dim=1).item()
        
        categories = [
            "الاحتيال الإلكتروني",
            "التنمر الإلكتروني",
            "التحرش أو التهديد",
            "انتحال الشخصية",
            "غير معروف",
        ]
        
        category = categories[predicted_label_index]
        return jsonify({'category': category})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# --- 5. Main Execution Block ---
if __name__ == '__main__':
    # Use host='0.0.0.0' to make the server accessible on your network
    app.run(host='0.0.0.0', port=5000, debug=True)
