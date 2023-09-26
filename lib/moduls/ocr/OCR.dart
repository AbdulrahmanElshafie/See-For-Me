import 'dart:convert';
import 'dart:io';
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
                          cameraController.setFlashMode(FlashMode.auto);
                          final imageAuto = await cameraController.takePicture();
                          cameraController.setFlashMode(FlashMode.always);
                          final imageAlways = await cameraController.takePicture();

                          File fileOff = File(imageOff.path);
                          print('imageOff.path ${imageOff.path}');
                          print('fileOff.path ${fileOff.path}');

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

                          print('send');
                          final response = await request.send();
                          print('response.statusCode ${response.statusCode}');
                          print('response.stream ${response.stream}');
                          print('response.request ${response.request}');
                          print('response.headers ${response.headers}');
                          print('response.reasonPhrase ${response.reasonPhrase}');

                          http.Response res = await http.Response.fromStream(response);
                          final resJson = jsonDecode(res.body);
                          print(resJson['msg']);
                          print(resJson['name']);



                          if (!mounted) return;

                          // If the picture was taken, display it on a new screen.
                          // await Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => DisplayPictureScreen(
                          //       // Pass the automatically generated path to
                          //       // the DisplayPictureScreen widget.
                          //       imagePath: image.path,
                          //     ),
                          //   ),
                          // );
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

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}