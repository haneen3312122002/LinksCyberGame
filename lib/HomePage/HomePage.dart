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
    // IMPORTANT: Verify that 'assets/BackGround1.png' (or 'assets/background.png' if that's the one causing error)
    // exists at the correct path in your project and is correctly listed in pubspec.yaml under the assets section.
    // E.g., in pubspec.yaml:
    // flutter:
    //   assets:
    //     - assets/
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'assets/BackGround1.png'), // Ensure this path is correct
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
