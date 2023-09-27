import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:see_for_me/moduls/errorpage/ErrorPage.dart';
import 'package:see_for_me/moduls/homescreen/HomeScreen.dart';
import 'package:see_for_me/moduls/ocr/OCR.dart';
import 'package:see_for_me/moduls/perception/Perception.dart';
import 'package:see_for_me/moduls/register/Register.dart';
import 'package:see_for_me/moduls/test/TextInputScreen.dart';
import 'package:see_for_me/shared/network/remote/firebase_options.dart';
import '../moduls/login/Login.dart';
import 'package:see_for_me/moduls/navigation/Navigation.dart';

Future<void> main() async {
  ErrorWidget.builder = (FlutterErrorDetails details) => const ErrorPage();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget start(){
    if(FirebaseAuth.instance.currentUser == null){
      return Register();
    } else {
      return HomeScreen();
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  start(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => HomeScreen(),
        '/home/reader': (context) => const OCR(),
        '/home/perception': (context) => const Perception(),
        '/home/navigation': (context) => const Navigation(),
        '/login': (context) =>  Login(),
        '/register': (context) => Register(),
        '/test': (context) => TestPage(),
      },
      darkTheme: ThemeData.dark(),
    );
  }
}
