import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';

class TestPage extends StatelessWidget {


  late TextEditingController inputController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Text Input Page'
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: ()
                    async {
                      // use 192.168.56.1 for local host
                      // pyhtoneverywhere server http://abdulrahmanelshafie.pythonanywhere.com/
                      var response = await http.get(
                        Uri.parse(
                          'http://abdulrahmanelshafie.pythonanywhere.com/audio'
                        )
                      );

                      print('response.statusCode ${response.statusCode}');
                      print('response.body ${response.body}');
                      print('response.headers ${response.headers}');

                      final audioBytes = response.bodyBytes;
                      final player = AudioPlayer();
                      await player.play(BytesSource(audioBytes));
                      },
                    child: Text(
                      'Send'
                    )),

              ],
            )
          ],
      ),
    );
  }
}
