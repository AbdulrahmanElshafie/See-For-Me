#from Components.Components import *
from Features.Perception.Perception import Perception

# reader = Reader()
# text_to_speech('hello')
# 
perceptor = Perception()
description = perceptor.pipline("C:\\Users\\DELL\\Desktop\\pics\\2.png")
