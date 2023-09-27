import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../shared/components/Components.dart';
import 'package:http/http.dart' as http;

class OCR extends StatefulWidget {
  const OCR({Key? key}) : super(key: key);

  @override
  State<OCR> createState() => _OCRState();
}

class _OCRState extends State<OCR> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  final player = AudioPlayer();

  @override
  void initState(){
    startCamera();
    super.initState();
  }

  void startCamera() async{
    cameras  = await availableCameras();

    cameraController = CameraController(
        cameras[0],
        ResolutionPreset.high,
        enableAudio: false
    );

    await cameraController.initialize().then((value) {
      if(!mounted) {
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
          title: Text(
              'Reader'
          ),
        ),
        body: Stack(
          children: [
            CameraPreview(cameraController),
            Navigate(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      onPressed: () async {
                        try {

                          // take 3 imgs with different modes
                          cameraController.setFlashMode(FlashMode.off);
                          final imageOff = await cameraController.takePicture();
                          // uncomment when going with the preprocessing
                          // cameraController.setFlashMode(FlashMode.auto);
                          // final imageAuto = await cameraController.takePicture();
                          // cameraController.setFlashMode(FlashMode.always);
                          // final imageAlways = await cameraController.takePicture();


                          // prepare the img file to be sent to the server
                          File fileOff = File(imageOff.path);

                          final request = http.MultipartRequest(
                              'POST',
                              Uri.parse('http://abdulrahmanelshafie.pythonanywhere.com/img')
                          );
                          final headers = {
                            "Content-type": "multipart/form-date"
                          };
                          request.files.add(
                              http.MultipartFile(
                                'image',
                                fileOff.readAsBytes().asStream(),
                                fileOff.lengthSync(),
                                filename: imageOff.name
                              )
                          );

                          request.headers.addAll(headers);

                          // send the file to the sever
                          await request.send();

                          // after sending the img and converting it to audio, the mp3 file should be saved and sent through get method
                          // as doing so with one method didn't succeed using get method to get the mp3 file and play it immediately
                          var audio = await http.get(
                              Uri.parse(
                                  'http://abdulrahmanelshafie.pythonanywhere.com/audio'
                              )
                          );

                          final audioBytes = audio.bodyBytes;
                          await player.play(BytesSource(audioBytes));

                          if (!mounted) return;

                        } catch (e) {
                          // If an error occurs, log the error to the console.
                          print('error $e');
                        }
                      },
                      child: const Icon(Icons.camera_alt),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      );
    }
  }