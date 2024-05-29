from Components.Components import *


class Perception:
    def __init__(self):
        self.img_path = "accident.jpg"
        pass

    def configure(self):
        genai.configure(api_key="AIzaSyAA21mQw2z98vNjk2h0dso8QXcNgkxQrUY")

    def set_model_parameters(self):
        generation_config = genai.GenerationConfig(
            temperature=1.0,
            top_p=0.95,
            top_k=64,
            max_output_tokens=8192
        )
        # generation_config = {
        #     "temperature": 1,
        #     "top_p": 0.95,
        #     "top_k": 64,
        #     "max_output_tokens": 8192,
        # }
        return generation_config

    def set_safety_settings(self):
        safety_settings = [
            {
                "category": "HARM_CATEGORY_HARASSMENT",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
            },
            {
                "category": "HARM_CATEGORY_HATE_SPEECH",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
            },
            {
                "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
            },
            {
                "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
            },
        ]
        return safety_settings

    def initialize_model(self):
        model = genai.GenerativeModel(model_name="gemini-1.5-flash-latest",
                                      generation_config=self.set_model_parameters(),
                                      safety_settings=self.set_safety_settings())
        return model

    def open_img(self, img_path):
        img = PIL.Image.open(img_path)
        return img

    def pipline(self, img_path):
        self.configure()
        model = self.initialize_model()
        img = self.open_img(img_path)
        # description = model.generate_content(["Describe what you see.", img], stream=True)
        # description.resolve()
        description = model.generate_content(["Describe what you see.", img])
        description = description.text
        txt_read = text_to_speech(description)
        return txt_read
