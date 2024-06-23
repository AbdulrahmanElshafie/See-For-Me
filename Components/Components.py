from gtts import gTTS
from io import BytesIO
import google.generativeai as genai
import PIL.Image
from flask import Flask, request, jsonify, send_file

def text_to_speech(text):
    mp3_fo = BytesIO()
    speech = gTTS(text, lang='en')
    speech.save("txt.mp3")
    speech.write_to_fp(mp3_fo)
    mp3_fo.seek(0)
    return mp3_fo