import 'package:flutter/material.dart';
import 'Block.dart'; // Import the Block class

class RightSideMenu extends StatelessWidget {
  final List<Block> blocks; // List of blocks to display

  RightSideMenu({required this.blocks});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0, // No elevation, blends in with the screen
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Blocks Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ...blocks.map((block) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Draggable<Block>(
                data: block,
                feedback: Material(
                  child: Container(
                    width: 120, // Set fixed width to prevent layout issues
                    height: 50, // Set fixed height for uniform dragging
                    padding: EdgeInsets.all(8.0),
                    color: block.isCorrect ? Colors.green : Colors.red,
                    child: Center(
                      child: Text(
                        block.text,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                childWhenDragging: Container(
                  width: 120, // Keep same size during drag
                  height: 50,
                  color: Colors
                      .grey.shade300, // Indicate the block is being dragged
                ),
                child: Container(
                  width: 120,
                  height: 50,
                  padding: EdgeInsets.all(8.0),
                  color: block.isCorrect ? Colors.green : Colors.red,
                  child: Center(
                    child: Text(
                      block.text,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
