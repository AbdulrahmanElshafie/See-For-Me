import 'package:flutter/material.dart';
import 'package:see_for_me_v2/moduls/errorpage/ErrorPage.dart';
import 'moduls/homescreen/HomeScreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gemini/flutter_gemini.dart';


Future<void> main() async {
  ErrorWidget.builder = (FlutterErrorDetails details) => const ErrorPage();
  WidgetsFlutterBinding.ensureInitialized();
  Gemini.init(apiKey: "AIzaSyAA21mQw2z98vNjk2h0dso8QXcNgkxQrUY");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  var cameraAccess = Permission.camera;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (await cameraAccess.status.isGranted) {
          await cameraAccess.request();
        }
      }
    );
    return MaterialApp(
      home:  const HomeScreen(),
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      routes: {
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
