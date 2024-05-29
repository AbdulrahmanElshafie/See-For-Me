from gtts import gTTS
from io import BytesIO
from transformers import pipeline
import imutils
import numpy as np
from pytesseract import pytesseract, Output
import cv2
from ultralytics import YOLO
import google.generativeai as genai
import PIL.Image
from Features.Reader.Reader import Reader
from Features.Perception.Perception import Perception
from Features.Navigator.Navigator import Navigator
from Features.Navigator.TrackedObj import TrackedObj
from Features.Navigator.User import User
from flask import Flask, request, jsonify, send_file

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
    speech.save("txt.mp3")
    speech.write_to_fp(mp3_fo)
    mp3_fo.seek(0)
    return mp3_fo


# calculate distance
def get_distance(pos1, pos2):
    return np.round(np.sqrt((np.power(pos1[0] - pos2[0], 2) + np.power(pos1[1] - pos2[1], 2))), 3)


user = User()
