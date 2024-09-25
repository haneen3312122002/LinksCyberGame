import 'package:flutter/material.dart';
import 'dart:math';
import 'Block.dart';
import 'TunnelBackground.dart';
import 'SideColumn.dart';
import 'SecondColumn.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:audioplayers/audioplayers.dart';

class SessionLayerScreen extends StatefulWidget {
  @override
  _SessionLayerScreenState createState() => _SessionLayerScreenState();
}

class _SessionLayerScreenState extends State<SessionLayerScreen> {
  List<Block> sideColumnBlocks = [];
  List<Block> secondColumnBlocks = [];
  bool hasLost = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<String> correctOrder = [
    'التأسيس',
    'ادارة الجلسة',
    'تبادل البيانات',
    'الإنهاء'
  ];

  @override
  void initState() {
    super.initState();
    sideColumnBlocks = getShuffledBlocks();
  }

  List<Block> getShuffledBlocks() {
    List<Block> blocks = [
      Block(text: 'التأسيس'),
      Block(text: 'ادارة الجلسة'),
      Block(text: 'تبادل البيانات'),
      Block(text: 'الإنهاء'),
    ];
    blocks.shuffle(Random());
    return blocks;
  }

  void resetGame() {
    setState(() {
      sideColumnBlocks = getShuffledBlocks();
      secondColumnBlocks.clear();

      // hasLost = false; // Removed in previous adjustments
    });
  }

  Future<void> playSound(String assetPath) async {
    await _audioPlayer.play(AssetSource(assetPath));
  }

  void checkOrder() {
    if (secondColumnBlocks.length == correctOrder.length) {
      bool isCorrect = true;
      for (int i = 0; i < correctOrder.length; i++) {
        if (secondColumnBlocks[i].text != correctOrder[i]) {
          isCorrect = false;
          break;
        }
      }

      if (isCorrect) {
        Fluttertoast.showToast(
          msg: "أتممت المهمة بنجاح!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        playSound('victory.mp3');
        resetGame();
      } else {
        setState(() {
          hasLost = true;
        });
        playSound('Winning.mp3');
      }
    }
  }

  // Updated to accept the block from DragTarget
  void onBlockDragged(Block block) {
    setState(() {
      // Remove the block from the side column
      sideColumnBlocks.removeWhere((b) => b.text == block.text);
      // Add the block to the second column
      secondColumnBlocks.add(block);
      checkOrder();
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Row(
        children: [
          SideColumn(
            blocks: sideColumnBlocks,
            columnWidth: screenWidth * 0.3,
            columnHeight: screenHeight,
            backgroundColor: Colors.blueGrey[100],
          ),
          Expanded(
            child: Stack(
              children: [
                TunnelBackground(),
                if (hasLost)
                  Center(
                    child: AlertDialog(
                      title: Text('لقد خسرت!'),
                      content: Text('قم بالمحاولة مرة أخرى.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Close the dialog
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SessionLayerScreen()));
                          },
                          child: Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          SecondColumn(
            blocks: secondColumnBlocks,
            columnWidth: screenWidth * 0.3,
            columnHeight: screenHeight,
            onBlockAccepted: onBlockDragged,
            backgroundColor: Colors.green[100],
          ),
        ],
      ),
    );
  }
}
