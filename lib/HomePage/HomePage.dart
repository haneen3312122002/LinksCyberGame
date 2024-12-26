import 'package:flutter/material.dart';
import 'GamePartsCard.dart';
import 'CryptoGamesGrid.dart';

class HomePage extends StatelessWidget {
  final Map<String, String> personalInfo;

  HomePage({required this.personalInfo});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.settings, color: Colors.white, size: 30),
              onPressed: () {
                // Add settings functionality here
              },
            ),
          ),
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: CryptoGamesGrid(personalInfo: personalInfo),
            ),
          ),
        ],
      ),
    );
  }
}

class BackgroundImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/BackGround1.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
