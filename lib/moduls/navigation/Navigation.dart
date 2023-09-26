import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:see_for_me/shared/components/Components.dart';

class Navigation extends StatelessWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Navigator'
        ),
      ),
      body: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'In Development',
                    style: TextStyle(
                        fontSize: 20
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  LoadingAnimationWidget.threeArchedCircle(
                      color: Colors.white,
                      size: 50
                  )
                ],
              ),
            ],
          ),
          Navigate(context)
        ]
      ),
    );
  }
}
