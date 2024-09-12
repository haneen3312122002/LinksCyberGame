import 'package:flutter/material.dart';
import 'CryptoPart.dart'; // Assuming this is where CryptoHomePage is

class CryptoHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(), // Background image
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: CryptoGamesGrid(), // Grid of game part cards
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
          image: AssetImage('assets/partsPage.png'), // Background image path
          fit: BoxFit.cover, // Ensure the image covers the whole screen
        ),
      ),
    );
  }
}
