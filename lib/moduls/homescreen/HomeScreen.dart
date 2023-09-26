import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../shared/components/Components.dart';

class HomeScreen extends StatelessWidget {
  FirebaseFirestore db = FirebaseFirestore.instance;

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'See For Me'
        ),
        centerTitle: true,
        leading: Icon(
          Icons.remove_red_eye
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Navigator',
                          style: TextStyle(
                              fontSize: 20
                          ),
                        ),
                        Icon(
                          Icons.arrow_upward_rounded,
                          size: 100,
                        ),
                      ],
                    ),

                  ],
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.arrow_back_rounded,
                            size: 100,
                          ),
                          Text(
                            'Perception',
                            style: TextStyle(
                                fontSize: 20
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Reader',
                            style: TextStyle(
                                fontSize: 20
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 100,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Home',
                          style: TextStyle(
                              fontSize: 20
                          ),
                        ),
                        Icon(
                          Icons.arrow_downward_rounded,
                          size: 100,
                        )
                      ],
                    )
                  ],
                ),
              ),

            ],
          ),
          Navigate(context),
          GestureDetector(
            onTap: () async {
              final player = AudioPlayer();
              await player.play(AssetSource('Info.mp3'));
            },
          ),
        ],
      )
    );
  }
}