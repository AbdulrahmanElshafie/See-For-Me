import 'package:flutter/material.dart';
import 'package:see_for_me_v2/moduls/errorpage/ErrorPage.dart';
import '../moduls/homescreen/HomeScreen.dart';


Future<void> main() async {
  ErrorWidget.builder = (FlutterErrorDetails details) => const ErrorPage();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  HomeScreen(),
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
    );
  }
}
