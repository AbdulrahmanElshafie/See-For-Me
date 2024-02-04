from gtts import gTTS
from io import BytesIO
from transformers import pipeline
import imutils
import numpy as np
from pytesseract import pytesseract, Output
import cv2


def text_correction(text: str):
    sentences = text.split('. ')
    res = ''
    fix_spelling = pipeline("text2text-generation", model="oliverguhr/spelling-correction-english-base")
    for s in sentences:
        corrected = fix_spelling(s, max_length=5000)[0]['generated_text']
        res += corrected + ' '
    return res


def text_to_speech(text):
    mp3_fo = BytesIO()
    speech = gTTS(text, lang='en')
    speech.save("Features/Reader/mp3s/1.mp3")
    speech.write_to_fp(mp3_fo)
    mp3_fo.seek(0)
    return mp3_fo
