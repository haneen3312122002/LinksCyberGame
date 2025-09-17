from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # للسماح بالاتصال من تطبيق الفلاتر

def encrypt_word(word, key):
    encrypted = ''
    for char in word:
        if char.isalpha():
            # تحويل الحرف إلى قيمة رقمية
            base = ord('a') if char.islower() else ord('A')
            # تطبيق التشفير
            shifted = (ord(char) - base + key) % 26 + base
            encrypted += chr(shifted)
        else:
            # إذا كان الحرف ليس حرفًا أبجديًا، نضيفه كما هو
            encrypted += char
    return encrypted

@app.route('/', methods=['POST'])
def compare_word():
    data = request.get_json()
    if not data:
        return jsonify({'error': 'Invalid JSON data'}), 400

    collected_word = data.get('collected_word', '').lower()
    displayed_word = data.get('displayed_word', '').lower()
    key = data.get('key')

    if not collected_word or not displayed_word or key is None:
        return jsonify({'error': 'Missing parameters'}), 400

    try:
        key = int(key)
    except ValueError:
        return jsonify({'error': 'Key must be an integer'}), 400

    # تشفير الكلمة المعروضة باستخدام المفتاح
    encrypted_word = encrypt_word(displayed_word, key)

    # مقارنة الكلمة المشفرة مع الكلمة المجمعة
    result = (collected_word == encrypted_word)

    return jsonify({'result': result}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000 , debug=True)
