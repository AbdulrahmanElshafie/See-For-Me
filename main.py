from Features.Reader.Reader import Reader
from Features.Perception.Perception import Perception
from Features.Navigator.Navigator import Navigator

choice = int(input('Enter your choice: '))
if choice == 1:
    img = ''
    reader = Reader()
    txt_read = reader.pipline(img)

elif choice == 2:
    navigator = Navigator()

elif choice == 3:
    perception = Perception()
