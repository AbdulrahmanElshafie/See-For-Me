from Components.Components import *

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


@app.route("/navigate")
def navigate_user():
    objs = request.files['objects']
    navigator = Navigator()
    navigator.navigate(objs)


@app.route("/describe")
def describe_image():
    img = request.files['image']
    perception = Perception()
    perception.pipline(img)


app.run()
