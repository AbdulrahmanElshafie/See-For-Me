from gtts import gTTS
from io import BytesIO
import requests
from transformers import pipeline
import cv2
import pytesseract
from pytesseract import Output


def text_correction(text):
    fix_spelling = pipeline("text2text-generation", model="oliverguhr/spelling-correction-english-base")
    text = fix_spelling(text, max_length=30000)
    return text


def text_to_speech(text):
    mp3_fo = BytesIO()
    speech = gTTS(text, lang='en')
    speech.save("mp3s/1.mp3")
    speech.write_to_fp(mp3_fo)
    mp3_fo.seek(0)
    return mp3_fo
