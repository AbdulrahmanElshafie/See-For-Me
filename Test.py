from Features.Reader.Reader import Reader
from Features.Perception.Perception import Perception
from Features.Navigator.Navigator import Navigator
from Components.Components import *


imgs = ['img1.jpeg', 'img2.jpeg', 'img3.jpeg', 'img4.jpeg', 'img5.jpeg', 'img6.jpeg']
reader = Reader()
for img in imgs:
    reader.pipline(img)
    # print(txt_read)