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
            top: 50,
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
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
