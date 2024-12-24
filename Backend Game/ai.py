from flask import Flask, request, jsonify
from flask_cors import CORS
from textblob import TextBlob
from googletrans import Translator

app = Flask(__name__)
CORS(app)

translator = Translator()

# تحليل المشاعر باستخدام TextBlob مع الترجمة
def analyze_sentiment(comment):
    translated_text = translator.translate(comment, src="ar", dest="en").text
    blob = TextBlob(translated_text)
    sentiment = blob.sentiment.polarity  # قيمة بين -1 و 1
    if sentiment > 0:
        return "إيجابي"
    elif sentiment < 0:
        return "سلبي"
    else:
        return "محايد"

@app.route('/analyze', methods=['POST'])
def analyze():
    try:
        data = request.json
        comment = data.get('comment', '')
        if not comment:
            return jsonify({"error": "No comment provided"}), 400

        result = analyze_sentiment(comment)
        return jsonify({"sentiment": result})
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
