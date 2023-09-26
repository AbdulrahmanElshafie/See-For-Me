import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:see_for_me/shared/components/Components.dart';

class Login extends StatelessWidget {
  Login({super.key});
  late TextEditingController passwordController = TextEditingController(),
      emailController = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  final user = <String, dynamic>{
    "Name": "last test2",
    "Email": "test2@gamil.com",
    "Password": 'lets test it out2'
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login'
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                  controller: emailController,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  controller: passwordController,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  height: 40,
                  width: 120,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: TextButton(
                    onPressed: ()
                    async {
                      useLog = true;
                      if(emailController.text == '' || passwordController.text == ''){
                        final player = AudioPlayer();
                        player.play(AssetSource('Info.mp3'));
                      } else {
                        try {
                          final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text
                          );
                          // CREDENTIALS = credential;
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            print('No user found for that email.');
                          } else if (e.code == 'wrong-password') {
                            print('Wrong password provided for that user.');
                          }
                        }
                        Navigator.pushNamed(
                            context,
                            '/home'
                        );
                      }
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                      ),
                    ),
                  )
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                      "Don't have an account?"
                  ),
                  TextButton(
                      onPressed: ()
                      {
                        Navigator.popUntil(
                            context,
                            ModalRoute.withName('/'));
                      },
                      child: Text(
                          'Create an Account Now'
                      )
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
