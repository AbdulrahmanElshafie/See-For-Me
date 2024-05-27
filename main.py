from Features.Reader.Reader import Reader
from Features.Perception.Perception import Perception
from Features.Navigator.Navigator import Navigator
from flask import Flask, request, jsonify, send_file

app = Flask(__name__)

@app.route("/")
def default():
    return 'hello client'
@app.route("/ocr")
def OCR():
    img = request.files['image']
    reader = Reader()
    txt_read = reader.pipline(img)


@app.route("/ocraudio")
def getTxtRead():
    mp3FilePath = 'mp3s/1.mp3'
    return send_file(mp3FilePath, mimetype='audio/mpeg', as_attachment=True)


@app.route("/navigator")
def Navigation():
    navigator = Navigator()
    return "Nav"


@app.route("/perception")
def Perception():
    perception = Perception()


app.run()
