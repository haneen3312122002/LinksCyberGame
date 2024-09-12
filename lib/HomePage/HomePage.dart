import 'package:flutter/material.dart';
import 'GamePartsCard.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(), // Full-screen background image
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CryptoGamesGrid(), // Grid of game part cards
          ),
        ],
      ),
    );
  }
}

//.................................................

class BackgroundImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/partsPage.png'), // Full-screen background
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
