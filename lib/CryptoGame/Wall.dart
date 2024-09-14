import 'package:flutter/material.dart';
import 'Block.dart'; // Import Block class

class WallArea extends StatefulWidget {
  final List<Block> correctPassword;
  final double wallHeight;

  WallArea({required this.correctPassword, required this.wallHeight});

  @override
  _WallAreaState createState() => _WallAreaState();
}

class _WallAreaState extends State<WallArea> {
  List<Block> droppedBlocks = [];

  @override
  Widget build(BuildContext context) {
    // حساب نصف ربع العرض والطول
    double blockWidth =
        MediaQuery.of(context).size.width / 4 / 2; // نصف ربع عرض الشاشة
    double blockHeight = widget.wallHeight / 3 / 2; // نصف ربع طول المكان المخصص

    return DragTarget<Block>(
      onAccept: (block) {
        setState(() {
          droppedBlocks.add(block);
        });

        // Check if the user has won
        if (droppedBlocks.length == widget.correctPassword.length) {
          _checkWinCondition();
        }
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: double.infinity, // Full width of the screen
          height: widget.wallHeight, // نصف طول الخلفية
          color: Colors.transparent, // Invisible drop area
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.end, // بدء البناء من الصف السفلي
            children: [
              // الصف السفلي (أول خمسة بلوكات)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildBlocksForRow(0, 5, blockWidth, blockHeight),
              ),
              // الصف العلوي (بقية البلوكات بعد ملء الصف السفلي)
              if (droppedBlocks.length >
                  5) // عرض الصف العلوي إذا كان هناك أكثر من 5 بلوكات
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildBlocksForRow(
                      5, droppedBlocks.length, blockWidth, blockHeight),
                ),
            ],
          ),
        );
      },
    );
  }

  // دالة لبناء البلوكات لكل صف بناءً على البداية والنهاية
  List<Widget> _buildBlocksForRow(
      int start, int end, double blockWidth, double blockHeight) {
    List<Widget> rowBlocks = [];
    for (int i = start; i < end && i < droppedBlocks.length; i++) {
      rowBlocks.add(Container(
        margin: EdgeInsets.all(1.0), // Add some space between blocks
        width: blockWidth - 8, // Block width (نصف ربع العرض)
        height: blockHeight - 8, // Block height (نصف ربع الطول)
        decoration: BoxDecoration(
          color: Colors.brown, // Fixed brown color for all blocks
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
          child: Text(droppedBlocks[i].text,
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
      ));
    }
    return rowBlocks;
  }

  void _checkWinCondition() {
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
