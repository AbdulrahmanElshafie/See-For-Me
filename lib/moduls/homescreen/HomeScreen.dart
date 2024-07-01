import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:speech_to_text_google_dialog/speech_to_text_google_dialog.dart';

// import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:galli_text_to_speech/text_to_speech.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  int crntIndex = 0;

  final player = AudioPlayer();
  final TextToSpeech tts = TextToSpeech();
  final gemini = Gemini.instance;

  @override
  void initState() {
    startCamera();
    super.initState();
  }

  void startCamera() async {
    cameras = await availableCameras();

    cameraController =
        CameraController(cameras[0], ResolutionPreset.high, enableAudio: false);

    await cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {}); // to refresh widget
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('See For Me'),
          centerTitle: true,
          leading: const Icon(Icons.remove_red_eye_outlined),
        ),
        body: Stack(
          children: [
            CameraPreview(cameraController),
            // add slider here
            GestureDetector(
              child: CarouselSlider(
                options: CarouselOptions(
                  scrollDirection: Axis.vertical,
                  height: double.infinity,
                  onPageChanged: (int index, CarouselPageChangedReason reason) {
                    // prepare a function that will take the index to perform the functionality of selected item
                    crntIndex = index;
                    if (crntIndex == 0) {
                      // Reader
                      // player.play(AssetSource('Reader.mp3'));
                      tts.speak('Reader');
                      Navigator.pushNamed(context, '/reader');
                    } else if (crntIndex == 1) {
                      // Navigator
                      // player.play(AssetSource('Navigator.mp3'));
                      tts.speak('Navigator');
                    } else if (crntIndex == 2) {
                      // Perception
                      // player.play(AssetSource('Perception.mp3'));
                      tts.speak('Perception');
                    } else if (crntIndex == 3) {
                      // VQA
                      tts.speak('Visual Query Answering');
                    }
                  },
                ),
                items: ['Reader', 'Navigator', 'Perception', 'VQA'].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          i,
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              onTap: () async {
                if (crntIndex == 0) {
                  // Reader
                  try {
                    // take img
                    cameraController.setFlashMode(FlashMode.off);
                    final imageOff = await cameraController.takePicture();

                    // read txt in image
                    File fileOff = File(imageOff.path);
                    // String txt = await FlutterTesseractOcr.extractText(
                    //     imageOff.path,
                    //     args: {
                    //       "psm": "4",
                    //       "preserve_interword_spaces": "1",
                    //     });

                    // correct txt read from img
                    // final request = http.MultipartRequest(
                    //     'POST',
                    //     Uri.parse(
                    //         'http://abdulrahmanelshafie.pythonanywhere.com/ocr'));
                    // final headers = {"Content-type": "multipart/form-date"};
                    //
                    // request.files.add(http.MultipartFile('image',
                    //     fileOff.readAsBytes().asStream(), fileOff.lengthSync(),
                    //     filename: imageOff.name));
                    //
                    // request.headers.addAll(headers);
                    //
                    // // send the file to the sever
                    // await request.send();
                    //
                    // // read the txt using gtts
                    // final audio = await tts.speak(txt);
                    // await tts.awaitSpeakCompletion(true);
                    //
                    // // play audio
                    // await player.play(BytesSource(audio));

                    if (!mounted) return;
                  } catch (e) {
                    // If an error occurs, log the error to the console.
                    print('error $e');
                  }
                } else if (crntIndex == 1) {
                  // Navigator
                } else if (crntIndex == 2) {
                  // Perception
                  try {
                    late String description;
                    // take img
                    cameraController.setFlashMode(FlashMode.off);
                    final imageOff = await cameraController.takePicture();

                    // send img to gemini
                    File fileOff = File(imageOff.path);
                    await gemini.textAndImage(
                        text: "Describe what you see briefly.",
                        images: [
                          fileOff.readAsBytesSync()
                        ]).then((value) =>
                        (description = value?.content?.parts?.last.text ?? ''));

                    // read the txt
                    tts.speak(description);

                    if (!mounted) return;
                  } catch (e) {
                    // If an error occurs, log the error to the console.
                    print('error $e');
                  }
                } else if (crntIndex == 3) {
                  // VQA
                  late String description;

                  // take img
                  cameraController.setFlashMode(FlashMode.off);
                  final imageOff = await cameraController.takePicture();
                  File fileOff = File(imageOff.path);

                  bool isServiceAvailable =
                      await SpeechToTextGoogleDialog.getInstance()
                          .showGoogleDialog(
                    onTextReceived: (query) async {
                      await gemini.textAndImage(text: query, images: [
                        fileOff.readAsBytesSync()
                      ]).then((value) => (description =
                          value?.content?.parts?.last.text ?? ''));

                      // read the txt
                      tts.speak(description);
                    },
                    // locale: "en-US",
                  );
                }
              },
              onDoubleTap: () {
                if (crntIndex == 1) {
                  // Navigator
                } else if (crntIndex == 3) {
                  // VQA
                  tts.speak('each time you want to ask something, just tap me!');
                } else {
                  // Perception & Reader
                  player.play(AssetSource('Reader_Perception.mp3'));
                }
              },
              onLongPress: () {
                // play instruction audio
                player.play(AssetSource('Instructions.mp3'));
              },
            ),
          ],
        ));
  }
}
