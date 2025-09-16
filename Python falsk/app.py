from flask import Flask, request, jsonify
from flask_cors import CORS
import re

app = Flask(__name__)
CORS(app)

# قائمة بالنطاقات المشبوهة
suspicious_domains = ['bit.ly', 'tinyurl.com', 'adf.ly', 'shorte.st']

# قائمة بالكلمات المشبوهة التي يمكن أن تشير إلى محتوى ضار
suspicious_keywords = ['free', 'bonus', 'click', 'download', 'hack', 'prize']

def is_suspicious_link(link):
    # شرط 1: التحقق إذا كان الرابط يستخدم https
    if not link.startswith('https'):
        return 'not secure'
    
    # شرط 2: التحقق إذا كان الرابط يحتوي على نطاق مشبوه
    if any(domain in link for domain in suspicious_domains):
        return 'suspicious domain'
    
    # شرط 3: التحقق من الكلمات المشبوهة في الرابط
    if any(keyword in link.lower() for keyword in suspicious_keywords):
        return 'suspicious keyword'
    
    # شرط 4: التحقق من طول الرابط (الرابط الطويل جدا قد يكون مشبوهًا)
    if len(link) > 100:
        return 'link too long'
    
    # إذا كان الرابط آمنًا ولم يحقق أي من الشروط السابقة
    return 'secure'

@app.route('/check_link', methods=['GET'])
def check_link():
    link = request.args.get('link')
    
    if link is None or link.strip() == "":
        return jsonify({'error': 'No link provided'}), 400

    # التحقق من الرابط باستخدام الدالة المعدلة
    result = is_suspicious_link(link)

    return jsonify({'result': result})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)