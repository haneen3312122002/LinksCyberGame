import 'package:flutter/material.dart';
import 'Block.dart'; // Ensure this file contains your Block class.

class SideColumn extends StatelessWidget {
  final List<Block> blocks; // List of blocks in the side column
  final double columnWidth; // Width of the column
  final double columnHeight; // Height of the column
  final Color? backgroundColor; // Background color of the column

  SideColumn({
    required this.blocks,
    required this.columnWidth,
    required this.columnHeight,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: columnWidth,
      height: columnHeight,
      color: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: blocks.map((block) {
          return Container(
            height: columnHeight * 0.2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Draggable<Block>(
                data: block, // The data being dragged
                feedback: Material(
                  // Wrap feedback with Material
                  color: Colors.transparent,
                  child: buildBlock(block.text, columnWidth),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.5,
                  child: buildBlock(block.text, columnWidth),
                ),
                child: buildBlock(block.text, columnWidth),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Function to build a block widget
  Widget buildBlock(String label, double width) {
    return Container(
      width: width * 0.8, // Reduce width for better appearance
      // Remove height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue[200], // Background color of the block
        borderRadius: BorderRadius.circular(10), // Rounded corners
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: width * 0.05, // Font size as a percentage of column width
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
