import 'package:flutter/material.dart';
import 'Block.dart'; // Import the Block class

class WallArea extends StatefulWidget {
  final List<Block> correctPassword;

  WallArea({required this.correctPassword});

  @override
  _WallAreaState createState() => _WallAreaState();
}

class _WallAreaState extends State<WallArea> {
  List<Block> droppedBlocks = [];

  @override
  Widget build(BuildContext context) {
    return DragTarget<Block>(
      onAccept: (block) {
        setState(() {
          droppedBlocks.add(block);
        });

        // Check if the user has won
        if (droppedBlocks.length == widget.correctPassword.length) {
          bool isCorrect = true;
          for (int i = 0; i < droppedBlocks.length; i++) {
            if (droppedBlocks[i].text != widget.correctPassword[i].text) {
              isCorrect = false;
              break;
            }
          }
          if (isCorrect) {
            _showWinDialog(context);
          }
        }
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: double.infinity,
          height: 100, // Adjust height as needed
          color: Colors.transparent, // Make the drop area invisible
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: droppedBlocks.map((block) {
              return Container(
                margin: EdgeInsets.all(4.0),
                padding: EdgeInsets.all(8.0),
                color: block.isCorrect ? Colors.green : Colors.red,
                child: Text(block.text, style: TextStyle(color: Colors.white)),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showWinDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('You Win!'),
          content: Text('You have built a strong password wall!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
