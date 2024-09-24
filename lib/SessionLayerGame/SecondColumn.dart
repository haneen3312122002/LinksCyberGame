import 'package:flutter/material.dart';
import 'Block.dart'; // Ensure this file contains your Block class.

class SecondColumn extends StatelessWidget {
  final List<Block> blocks; // List of blocks in the second column
  final double columnWidth; // Width of the column
  final double columnHeight; // Height of the column
  final Color? backgroundColor; // Background color of the column
  final Function(Block) onBlockAccepted; // Function to handle accepted blocks

  SecondColumn({
    required this.blocks,
    required this.columnWidth,
    required this.columnHeight,
    required this.backgroundColor,
    required this.onBlockAccepted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: columnWidth,
      height: columnHeight,
      color: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...blocks.map((block) {
            return Container(
              height: columnHeight * 0.2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildBlock(block.text, columnWidth),
              ),
            );
          }).toList(),
          if (blocks.length < 4)
            // Wrap the "Drop Here" container with DragTarget
            DragTarget<Block>(
              onWillAccept: (block) => true,
              onAccept: (block) {
                onBlockAccepted(block);
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  height: columnHeight * 0.2,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: candidateData.isNotEmpty
                        ? Colors.grey[300]
                        : Colors.white,
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      'إسقاط هنا',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
        ],
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
