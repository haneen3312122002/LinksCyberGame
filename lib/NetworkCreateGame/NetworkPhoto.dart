import 'package:flutter/material.dart';

class NetworkBackground extends StatelessWidget {
  final String imagePath;

  // Constructor to pass in the image path if needed
  NetworkBackground({this.imagePath = 'assets/NetworkBackground.png'});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Full width
      height: double.infinity, // Full height
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath), // Load the image asset
          fit: BoxFit.cover, // Ensures the image covers the whole screen
        ),
      ),
    );
  }
}
