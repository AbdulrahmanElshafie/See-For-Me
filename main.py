from Components.Components import *
from Features.Perception import Perception
from gunicorn.app.base import Application

app = Flask(__name__)


@app.route("/")
def default():
    return 'hello client'


@app.route("/describe")
def describe_image():
    img = request.files['image']
    perception = Perception()
    perception.pipline(img)

if __name__ == '__main__': 
   class FlaskApp(Application):
       def load_config(self): 
           config = super().load_config() 
           config['bind'] = '0.0.0.0:8000'# Adjust port if needed 
           config['workers'] = 1# Adjust workers as needed
           return config 

       def load_wsgi_app(self):
           return app 

FlaskApp().run()