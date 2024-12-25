from flask import Flask, request, jsonify
from flask_cors import CORS
from textblob import TextBlob
from googletrans import Translator

app = Flask(__name__)
CORS(app)

translator = Translator()

def analyze_sentiment(comment):
    # Translate Arabic to English for sentiment analysis
    translated_text = translator.translate(comment, src="ar", dest="en").text
    blob = TextBlob(translated_text)
    polarity = blob.sentiment.polarity  # Range: -1 (negative) to +1 (positive)

    if polarity > 0:
        return "إيجابي"
    elif polarity < 0:
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

        # Perform sentiment analysis
        result = analyze_sentiment(comment)
        # Return JSON with a 'sentiment' key
        return jsonify({"sentiment": result})
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
