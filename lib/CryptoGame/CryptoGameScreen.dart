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
    Block(text: 'S'),
    Block(text: 't'),
    Block(text: 'r'),
    Block(text: 'o'),
    Block(text: 'n'),
    Block(text: 'g'),
    Block(text: 'n'),
    Block(text: 'g'),
  ];

  // Menu will have a set of blocks (no longer using isCorrect)
  List<Block> allBlocks = [
    Block(text: 'S'),
    Block(text: 't'),
    Block(text: 'r'),
    Block(text: 'o'),
    Block(text: 'n'),
    Block(text: 'g'),
    Block(text: 'a'),
    Block(text: 'b'),
    Block(text: 'c'),
    Block(text: '1'),
  ];

  void removeBlockFromMenu(Block block) {
    setState(() {
      allBlocks.remove(block); // Remove the block from the menu when dragged
    });
  }

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
                    correctPassword: correctPassword,
                    wallHeight: MediaQuery.of(context).size.height /
                        2, // Half screen height
                  ),
                ),
              ],
            ),
          ),
          // Right-side drawer that stays open
          if (isDrawerVisible)
            Expanded(
              flex: 1, // Drawer takes up 1/4th of the screen width
              child: RightSideMenu(
                blocks: allBlocks,
                onBlockDragged:
                    removeBlockFromMenu, // Remove block from menu on drag
              ),
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
