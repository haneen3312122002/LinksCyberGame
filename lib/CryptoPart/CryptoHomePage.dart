import 'package:flutter/material.dart';
import 'package:cybergame/CryptoGame/CryptoGameScreen.dart';
import 'CryptoPart.dart';
import 'dart:ui' as ui; // Import for the ImageFilter

class CryptoHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(), // Background image
          PageView.builder(
            itemCount:
                10, // Number of pages (assuming each part has its own page)
            itemBuilder: (context, index) => GameSection(index: index),
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
          image: AssetImage('assets/casel.png'), // Background image path
          fit: BoxFit.cover, // Ensure the image covers the whole screen
        ),
      ),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
            sigmaX: 13.0, sigmaY: 13.0), // Applying blur filter
        child: Container(
          color: Colors.black.withOpacity(
              0.1), // Optional: Add a black overlay with some opacity if needed
        ),
      ),
    );
  }
}
