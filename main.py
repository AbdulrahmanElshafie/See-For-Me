from Features.Reader.Reader import Reader
from Features.Perception.Perception import Perception
from Features.Navigator.Navigator import Navigator

choice = int(input('Enter your choice: '))
if choice == 1:
    img = ''
    reader = Reader()
    img = reader.preprocessing(img)
    txt = reader.image_to_txt(img)
    corrected_txt = reader.text_correction(txt)
    txt_read = reader.txt_to_speech(corrected_txt)

elif choice == 2:
    navigator = Navigator()

elif choice == 3:
    perception = Perception()
