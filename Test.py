from Features.Reader.Reader import Reader
from Features.Perception.Perception import Perception
from Features.Navigator.Navigator import Navigator
from Components.Components import *


img = 'Screenshot 2023-11-10 171826.png'
reader = Reader()
txt_read = reader.pipline(img)