from Components.Components import *
from Features.Reader.Reader import Reader
from gunicorn.app.base import Application

class FlaskApp(Application):
    def load_config(self): 
        config = super().load_config() 
        config['bind'] = '0.0.0.0:8000'# Adjust port 
        return config 
    def load_wsgi_app(self):
        return app 


app = Flask(__name__)


@app.route("/")
def default():
    return 'hello client'


@app.route("/read", methods = 'POST')
def read_text():
    img = request.files['image']
    reader = Reader()
    text = reader.read(img)
    return text
    #return send_file('txt.mp3', mimetype='audio/mpeg', as_attachment=True)


if __name__ == '__main__':
    app.run()
