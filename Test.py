from Features.Reader.Reader import Reader
from Features.Perception.Perception import Perception
from Features.Navigator.Navigator import Navigator
from Components.Components import *


img = 'img2.jpeg'
reader = Reader()
txt_read = reader.pipline(img)
print(txt_read)