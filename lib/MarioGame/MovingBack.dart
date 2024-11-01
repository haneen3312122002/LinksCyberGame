import 'package:flutter/material.dart';

class GameGround extends StatelessWidget {
  final double characterXPosition;
  final double characterYPosition;
  final String characterDirection;

  GameGround({
    required this.characterXPosition,
    required this.characterYPosition,
    required this.characterDirection,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // Central Vertical Street
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 80,
            height: double.infinity,
            color: Colors.grey[400],
          ),
        ),
        // Horizontal Street on the Left
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: screenWidth / 2 - 40,
            height: 80,
            color: Colors.blue[300],
            child: Center(
              child: Text("Left", style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
        // Horizontal Street on the Right
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: screenWidth / 2 - 40,
            height: 80,
            color: Colors.red[300],
            child: Center(
              child: Text("Right", style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
        // Letters A-M on the central vertical street (bottom to top)
        ...List.generate(13, (index) {
          final letter = String.fromCharCode(65 + index); // A to M
          return Positioned(
            left: screenWidth / 2 - 15,
            bottom: 30 + (screenHeight / 14) * index,
            child: LetterTile(letter: letter),
          );
        }),
        // Letters N-T on the left horizontal street, centered vertically
        ...List.generate(7, (index) {
          final letter = String.fromCharCode(78 + index); // N to T
          return Positioned(
            left: (screenWidth / 14) * index + 20,
            top: (screenHeight / 2) -
                40 +
                (80 / 2) -
                15, // Center vertically in the street
            child: LetterTile(letter: letter),
          );
        }),
        // Letters U-Z on the right horizontal street, centered vertically
        ...List.generate(6, (index) {
          final letter = String.fromCharCode(85 + index); // U to Z
          return Positioned(
            left: screenWidth / 2 + (index * (screenWidth / 14)) + 40,
            top: (screenHeight / 2) -
                40 +
                (80 / 2) -
                15, // Center vertically in the street
            child: LetterTile(letter: letter),
          );
        }),
        // Character positioned initially next to the letter "A" at the bottom
        Positioned(
          bottom: characterYPosition, // Adjust vertical position
          left: (screenWidth / 2) +
              characterXPosition -
              25, // Adjust horizontal position
          child: Image.asset(
            characterDirection,
            width: 120, // Increase character image width
            height: 120, // Increase character image height
          ),
        ),
      ],
    );
  }
}

// Widget to display each letter in a circular tile on the street
class LetterTile extends StatelessWidget {
  final String letter;

  LetterTile({required this.letter});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.yellow[700],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
