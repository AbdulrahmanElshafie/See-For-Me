from transformers import pipeline
from pytesseract import pytesseract, Output
from flask import Flask, request, jsonify
from gunicorn.app.base import Application


class FlaskApp(Application):
    def load_config(self):
        config = super().load_config()
        config['bind'] = '0.0.0.0:8000'  # Adjust port if needed
        return config

    def load_wsgi_app(self):
        return app


app = Flask(__name__)


@app.route("/")
def default():
    return 'hello client'


@app.route("/read", methods=['POST'])
def read_txt():
    try:
        img = request.files['image']

        # pytesseract.tesseract_cmd = r"D:\Program Files\Tesseract-OCR\tesseract.exe"

        myconfig = r"--psm 11 --oem 3"
        data = pytesseract.image_to_data(img, config=myconfig, output_type=Output.DICT)
        amount_box = len(data['text'])
        text = ""
        for i in range(amount_box):
            if float(data['conf'][i]) > 80:
                text += data['text'][i] + " "

        sentences = text.split('. ')
        res = ''
        fix_spelling = pipeline("text2text-generation", model="oliverguhr/spelling-correction-english-base")
        for s in sentences:
            corrected = fix_spelling(s, max_length=5000)[0]['generated_text']
            res += corrected + ' '

        return jsonify(
            {
                "text": res
            }
        )

    except Exception as e:
        return jsonify({"msg": str(e)})


if __name__ == '__main__':
    FlaskApp().run()
