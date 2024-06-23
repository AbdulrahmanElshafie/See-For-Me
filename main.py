from Components.Components import *
from Features.Perception import Perception

app = Flask(__name__)


@app.route("/")
def default():
    return 'hello client'


@app.route("/describe")
def describe_image():
    img = request.files['image']
    perception = Perception()
    perception.pipline(img)


app.run()
