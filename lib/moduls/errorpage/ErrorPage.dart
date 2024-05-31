import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Loading',
                style: TextStyle(
                  fontSize: 20
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              LoadingAnimationWidget.threeArchedCircle(
                color: Colors.white,
                size: 50,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
