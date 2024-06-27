from io import BytesIO
from transformers import pipeline
from pytesseract import pytesseract, Output 
from PIL import Image
from flask import Flask, request, jsonify, send_file
import os

def text_correction(text: str):
    sentences = text.split('. ')
    res = ''
    fix_spelling = pipeline("text2text-generation", model="oliverguhr/spelling-correction-english-base")
    for s in sentences:
        corrected = fix_spelling(s, max_length=5000)[0]['generated_text']
        res += corrected + ' '
    return res


# Set the path to the local Tesseract binary
TESSERACT_PATH = os.path.join(os.path.dirname(__file__), 'Tesseract-OCR', 'tesseract.exe')
pytesseract.tesseract_cmd = TESSERACT_PATH

class Reader:
    def __init__(self):
        pass


    def image_to_txt(self, img):
        #pytesseract.tesseract_cmd = r'C:\\Program Files\\Tesseract-OCR\\tesseract.exe'
        myconfig = r"--psm 11 --oem 3"
        data = pytesseract.image_to_data(img, config=myconfig, output_type=Output.DICT)
        amount_box = len(data['text'])
        text = ""
        for i in range(amount_box):
            if float(data['conf'][i]) > 80:
                text += data['text'][i] + " "
        return text
    

    def preprocessing(self, img):
        img_ = Image.open(img)
        # make image gray scale
        gray_img = img_.convert('L')
        return gray_img


    def read(self, img):
        img = self.preprocessing(img)
        txt = self.image_to_txt(img)
        corrected_txt = text_correction(txt)
        #txt_read = text_to_speech(corrected_txt)
        return corrected_txt