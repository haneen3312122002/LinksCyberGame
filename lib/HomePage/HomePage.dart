import 'package:flutter/material.dart';
import 'GamePartsCard.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(), // Full-screen background image
          Positioned(
            top: 160, // Increase this value to move the grid down
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: CryptoGamesGrid(), // Grid of game part cards
            ),
          ),
        ],
      ),
    );
  }
}

//..................................................

class BackgroundImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/BackGround1.png'), // Full-screen background
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
