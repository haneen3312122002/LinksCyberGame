import 'package:flutter/material.dart';
import 'dart:math';

class LetterBox extends StatelessWidget {
  final String letter;
  final double boxSize;
  final double positionX; // The horizontal position of the box

  LetterBox(
      {required this.letter, required this.boxSize, required this.positionX});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100, // Fixed height from the bottom, adjust as needed
      left: positionX, // X position where the box will appear
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // Perspective effect
          ..rotateX(-0.2), // Slight tilt for 3D effect
        alignment: FractionalOffset.center,
        child: Container(
          width: 200, // Fixed width for the box
          height: boxSize,
          margin: EdgeInsets.only(left: 200, right: 200),
          decoration: BoxDecoration(
            color: Colors.brown,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.brown.shade600,
                Colors.brown.shade900,
              ],
            ),
            border: Border.all(color: Colors.black, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                offset: Offset(5, 5), // Horizontal and vertical offset
                blurRadius: 10, // Blur effect for the shadow
                spreadRadius: 1, // Spread of the shadow
              ),
            ],
          ),
          child: Center(
            child: Text(
              letter,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 5.0,
                    color: Colors.black45,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MarioGame extends StatefulWidget {
  @override
  _MarioGameState createState() => _MarioGameState();
}

class _MarioGameState extends State<MarioGame> {
  double letterBoxOffset = 0;
  Random random = Random();

  // Generate a list of LetterBox widgets (A-Z)
  List<Widget> generateLetterBoxes() {
    double boxSize = 50; // Size of each box
    double initialX = 200; // Starting position for the first box

    // Generate random spacing between boxes (between 100 and 200 pixels)
    return List.generate(26, (index) {
      double randomSpacing =
          100.0 + random.nextInt(100); // Random spacing between 100 and 200
      initialX += randomSpacing; // Update the position by adding random spacing
      return LetterBox(
        letter: String.fromCharCode(65 + index), // A-Z letters
        boxSize: boxSize,
        positionX: initialX + letterBoxOffset, // Position each box dynamically
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> letterBoxes = generateLetterBoxes();

    return Scaffold(
      body: Stack(
        children: letterBoxes, // Render the letter boxes
      ),
    );
  }
}
