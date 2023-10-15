from Components.Components import *


class Reader:
    def __init__(self):
        pass

    def image_to_txt(self, img):
        myconfig = r"--psm 11 --oem 3"
        data = pytesseract.image_to_data(img, config=myconfig, output_type=Output.DICT)
        amount_box = len(data['text'])
        text = ""
        for i in range(amount_box):
            if float(data['conf'][i]) > 80:
                text += data['text'][i] + " "
        return text

    def txt_to_speech(self, text):
        text_to_speech(text)

    def text_correction(self, text):
        text_correction(text)

    def preprocessing(self, img):
        img_ = cv2.imread(img)  # to make the image be binary color (black&white)
        img_ = cv2.cvtColor(img_, cv2.COLOR_BGR2GRAY)
        img_ = cv2.resize(img_, (900, 950))
        img_result = cv2.adaptiveThreshold(img_, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C,  # use adaptive_Threshold library
                                           cv2.THRESH_BINARY, 17, 5)

        return img_result
