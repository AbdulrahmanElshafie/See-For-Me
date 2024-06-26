from Components.Components import *
from Features.Reader.Reader import Reader

app = Flask(__name__)


@app.route("/")
def default():
    return 'hello client'


@app.route("/read")
def read_text():
    img = request.files['image']
    reader = Reader()
    reader.read(img)
    return send_file('txt.mp3', mimetype='audio/mpeg', as_attachment=True)



app.run()
