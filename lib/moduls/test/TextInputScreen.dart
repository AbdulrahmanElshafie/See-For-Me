import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TestPage extends StatelessWidget {


  late TextEditingController inputController;
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
                      var response = await http.post(
                        // http://abdulrahmanelshafie.pythonanywhere.com/post
                        Uri.parse('http://ahmedwaelfarouk.pythonanywhere.com/text'),
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                        body: jsonEncode(<String, String>{
                          "text": "Hello my server "
                          // send img instead of txt
                        }),
                      );
                      if(response.statusCode == 200){
                        print(response.body);
                      } else {
                        print('errors');
                      }
                    },
                    child: Text(
                      'POST'
                    )),
                TextButton(
                    onPressed: ()
                    async {
                      // use 192.168.56.1 for local host
                      // pyhtoneverywhere server http://abdulrahmanelshafie.pythonanywhere.com/
                      print('click get');
                      var response = await http.get(Uri.parse('http://abdulrahmanelshafie.pythonanywhere.com/'));
                      if(response.statusCode == 200){
                        print(response.body);
                      } else {
                        print('error');
                      }
                      // final response = await http.get('http://127.0.0.1:5000/' as Uri);
                        // final decoded = json.decode(response.body) as Map<String, dynamic>;
                        // print('decoded ${decoded['txt']}');
                    },
                    child: Text(
                      'GET'
                    )),

              ],
            )
          ],
      ),
    );
  }
}
