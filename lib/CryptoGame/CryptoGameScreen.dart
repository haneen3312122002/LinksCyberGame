import 'package:flutter/material.dart';
import 'Block.dart';
import 'photo.dart'; // Ensure BackgroundPhoto is implemented
import 'RightMin.dart'; // Ensure RightSideMenu is implemented
import 'Wall.dart'; // Ensure WallArea is implemented

class CryptoGameScreen extends StatefulWidget {
  @override
  _CryptoGameScreenState createState() => _CryptoGameScreenState();
}

class _CryptoGameScreenState extends State<CryptoGameScreen> {
  bool isDrawerVisible = true; // State to track if the drawer is open or closed

  // Define the correct password parts (for winning)
  final List<Block> correctPassword = [
    Block(text: 'S', isCorrect: true),
    Block(text: 't', isCorrect: true),
    Block(text: 'r', isCorrect: true),
    Block(text: 'o', isCorrect: true),
    Block(text: 'n', isCorrect: true),
    Block(text: 'g', isCorrect: true),
  ];

  // Menu will have correct and incorrect blocks
  final List<Block> allBlocks = [
    Block(text: 'S', isCorrect: true),
    Block(text: 't', isCorrect: true),
    Block(text: 'r', isCorrect: true),
    Block(text: 'o', isCorrect: true),
    Block(text: 'n', isCorrect: true),
    Block(text: 'g', isCorrect: true),
    Block(text: 'a', isCorrect: false),
    Block(text: 'b', isCorrect: false),
    Block(text: 'c', isCorrect: false),
    Block(text: '1', isCorrect: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Game content shifted to the left
          Expanded(
            flex:
                isDrawerVisible ? 3 : 4, // Adjust width when drawer is visible
            child: Stack(
              children: [
                BackgroundPhoto(), // Castle background
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: WallArea(
                      correctPassword:
                          correctPassword), // Wall area at the bottom
                ),
              ],
            ),
          ),
          // Right-side drawer that stays open
          if (isDrawerVisible)
            Expanded(
              flex: 1, // Drawer takes up 1/4th of the screen width
              child: RightSideMenu(
                  blocks: allBlocks), // Menu with draggable blocks
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isDrawerVisible = !isDrawerVisible; // Toggle drawer visibility
          });
        },
        child: Icon(isDrawerVisible ? Icons.arrow_forward : Icons.arrow_back),
      ),
    );
  }
}
