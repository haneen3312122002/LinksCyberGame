import 'package:flutter/material.dart';
import 'Block.dart'; // Import Block class

class RightSideMenu extends StatelessWidget {
  final List<Block> blocks; // List of blocks to display
  final Function(Block) onBlockDragged; // Callback when a block is dragged

  RightSideMenu({required this.blocks, required this.onBlockDragged});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0, // No elevation, blends in with the screen
      child: ListView(
        padding: EdgeInsets.zero,
        children: blocks.map((block) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: Draggable<Block>(
              data: block,
              feedback: Material(
                child: Container(
                  width: 160, // Larger size while dragging
                  height: 80, // Larger size while dragging
                  decoration: BoxDecoration(
                    color: Colors.brown, // اللون البني للكتل
                    border: Border.all(
                      color: Colors.black, // إطار أسود
                      width: 4.0, // عرض الإطار
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5), // لون الظل
                        spreadRadius: 2, // انتشار الظل
                        blurRadius: 6, // تشويش الظل
                        offset: Offset(3, 3), // إزاحة الظل
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      block.text,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
              onDragCompleted: () =>
                  onBlockDragged(block), // Remove block from menu on drag
              childWhenDragging: Container(
                width: 120, // Regular size during drag
                height: 50,
                color:
                    Colors.grey.shade300, // Indicate the block is being dragged
              ),
              child: Container(
                width: 120,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.brown, // اللون البني للكتل
                  border: Border.all(
                    color: Colors.black, // إطار أسود
                    width: 4.0, // عرض الإطار
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5), // لون الظل
                      spreadRadius: 2, // انتشار الظل
                      blurRadius: 6, // تشويش الظل
                      offset: Offset(6, 6), // إزاحة الظل
                    ),
                  ],
                ),
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
      ),
    );
  }
}
