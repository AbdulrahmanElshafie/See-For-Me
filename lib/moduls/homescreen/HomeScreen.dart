import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {

  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  int crntIndex = 0;

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
        title: const Text(
          'See For Me'
        ),
        centerTitle: true,
        leading: const Icon(
          Icons.remove_red_eye
        ),
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
                  if(crntIndex == 0){
                    // Reader
                    player.play(AssetSource('Reader.mp3'));
                  } else if (crntIndex == 1){
                    // Navigator
                    player.play(AssetSource('Navigator.mp3'));
                  } else if (crntIndex == 2){
                    // Perception
                    player.play(AssetSource('Perception.mp3'));
                  }
                },
              ),
              items: [
                'Reader',
                'Navigator',
                'Perception',
              ].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                          i,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
              onTap: () async {
                if(crntIndex == 0){
                  // Reader
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
                        Uri.parse('http://abdulrahmanelshafie.pythonanywhere.com/ocr')
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
                            'http://abdulrahmanelshafie.pythonanywhere.com/ocraudio'
                        )
                    );

                    final audioBytes = audio.bodyBytes;
                    await player.play(BytesSource(audioBytes));

                    if (!mounted) return;

                  } catch (e) {
                    // If an error occurs, log the error to the console.
                    print('error $e');
                  }
                } else if (crntIndex == 1){
                  // Navigator

                } else if (crntIndex == 2){
                  // Perception
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
                        Uri.parse('http://abdulrahmanelshafie.pythonanywhere.com/ocr')
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
                            'http://abdulrahmanelshafie.pythonanywhere.com/ocraudio'
                        )
                    );

                    final audioBytes = audio.bodyBytes;
                    await player.play(BytesSource(audioBytes));

                    if (!mounted) return;

                  } catch (e) {
                    // If an error occurs, log the error to the console.
                    print('error $e');
                  }
                }
              },
            onDoubleTap: (){
              if(crntIndex == 1){
                // Navigator
              }  else {
                // Perception & Reader
                player.play(AssetSource('Reader_Perception.mp3'));
              }
            },
            onLongPress: (){
              // play instruction audio
              player.play(AssetSource('Instructions.mp3'));
            },
          ),
        ],
      )
    );
  }
}