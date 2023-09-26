import 'package:flutter/material.dart';

Widget Navigate(context){
  late String root;
  if(useLog){
    root = '/home';
  } else {
    root = '/';
  }

  return GestureDetector(
    onVerticalDragUpdate: (DragUpdateDetails){
      // to home
      if (DragUpdateDetails.primaryDelta! > 0){
        Navigator.popUntil(
            context,
        ModalRoute.withName(root));
      }
      // to navigation
      if (DragUpdateDetails.primaryDelta! < 0) {
        if(context.toString().contains('Navigation')){
          print('Navigation');
          Navigator.popUntil(
              context,
              ModalRoute.withName(root));
        } else {
          print('No Navigation');
          Navigator.pushNamed(
              context,
              '/home/navigation');
        }
      }
    },
    // to reader
    onHorizontalDragUpdate: (DragUpdateDetails) {
      if (DragUpdateDetails.primaryDelta! > 0){
        if(context.toString().contains('OCR')){
          Navigator.popUntil(
              context,
              ModalRoute.withName(root));
      } else {
          Navigator.pushNamed(
              context,
              '/home/reader');
        }
      }
      // to perception
      if (DragUpdateDetails.primaryDelta! < 0){
        if(context.toString().contains('Perception')){
          Navigator.popUntil(
              context,
              ModalRoute.withName(root));
        } else {
          Navigator.pushNamed(
              context,
              '/home/perception');
        }
      }
    },
  );
}


late bool useLog = false;
// late UserCredential CREDENTIALS;