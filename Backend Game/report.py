from flask import Flask, request, jsonify
from flask_cors import CORS
from transformers import AutoTokenizer, AutoModelForSequenceClassification
import torch

app = Flask(__name__)
CORS(app)

# تحميل نموذج AraBERT لتصنيف النصوص
model_name = "aubmindlab/bert-base-arabertv2"
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForSequenceClassification.from_pretrained(model_name, num_labels=5)  # فرض 5 تصنيفات

@app.route('/classify_message', methods=['POST'])
def classify_message():
    data = request.json
    message = data.get('message', '')

    if not message:
        return jsonify({'error': 'No message provided'}), 400

    # تحويل الرسالة إلى شكل مناسب للنموذج
    inputs = tokenizer(message, return_tensors="pt", padding=True, truncation=True, max_length=512)
    outputs = model(**inputs)
    probabilities = torch.nn.functional.softmax(outputs.logits, dim=-1)
    predicted_label = torch.argmax(probabilities, dim=1).item()

    # التصنيفات الممكنة
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


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)