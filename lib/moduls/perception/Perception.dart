import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../shared/components/Components.dart';

class Perception extends StatefulWidget {
  const Perception({Key? key}) : super(key: key);

  @override
  State<Perception> createState() => _PerceptionState();
}

class _PerceptionState extends State<Perception> {
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
            'Perception'
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
                    // Provide an onPressed callback.
                    onPressed: () async {
                      // Take the Picture in a try / catch block. If anything goes wrong,
                      // catch the error.
                      try {
                        await cameraController;

                        // Attempt to take a picture and get the file `image`
                        // where it was saved.
                        final video = await cameraController.startVideoRecording();
                        // If the picture was taken, display it on a new screen.
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
