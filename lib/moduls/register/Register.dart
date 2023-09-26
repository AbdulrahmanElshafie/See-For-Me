import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../shared/components/Components.dart';

class Register extends StatelessWidget {
  Register({super.key});
  late String name, password, email;
  late TextEditingController nameController = TextEditingController(),
                             passwordController = TextEditingController(),
                             emailController = TextEditingController(),
                             rePasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register'
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
                    labelText: 'Name',
                  ),
                  controller: nameController,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
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
              SizedBox(
                width: 300,
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Retype the password',
                  ),
                  controller: rePasswordController,
                  onChanged: (context){
                    if(passwordController.text != rePasswordController.text){

                    }
                  },
                ),
              ), //add password validation here
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
                      if(nameController.text == '' || emailController.text == '' || passwordController.text == ''){
                        final player = AudioPlayer();
                        player.play(AssetSource('Info.mp3'));
                      } else if (passwordController.text != rePasswordController.text) {

                      } else{
                        try {
                          final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            print('The password provided is too weak.');
                          } else if (e.code == 'email-already-in-use') {
                            print('The account already exists for that email.');
                          }
                        } catch (e) {
                          print(e);
                        }
                        Navigator.pushNamed(
                            context,
                            '/home'
                        );
                      }
                    }
                    ,
                    child: Text(
                      'Submit',
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
                    'Have an account?'
                  ),
                  TextButton(
                      onPressed: ()
                      {
                          Navigator.pushNamed(
                              context,
                              '/login');
                      },
                      child: Text(
                        'Login Now'
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
