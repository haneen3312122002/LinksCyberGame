import 'package:flutter/material.dart';
import 'GamePartsCard.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(), // Full-screen background image

          // Settings Icon Button (Top Left)
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

          // Start Button with Neon Effect (Top Right)
          Positioned(
            top: 40,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                // Add start journey functionality here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(255, 98, 210, 255), // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(
                "ابدا الرحلة",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 5.0,
                      color: Colors.greenAccent,
                      offset: Offset(0, 0),
                    ),
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.greenAccent.withOpacity(0.7),
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Neon Text
          Positioned(
            top: 200, // Adjust this to position the text higher or lower
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "WELCOME TO THE KIDS TRIP",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.cyanAccent,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.cyanAccent,
                      offset: Offset(0, 0),
                    ),
                    Shadow(
                      blurRadius: 30.0,
                      color: Colors.cyanAccent.withOpacity(0.5),
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Game Parts Grid
          Positioned(
            top: 200, // Increase this value to move the grid down
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
