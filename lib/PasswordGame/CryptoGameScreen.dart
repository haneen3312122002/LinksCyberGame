import 'package:flutter/material.dart';
import 'Block.dart';
import '../CryptoGame/photo.dart'; // Ensure BackgroundPhoto is implemented
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
    Block(text: '173'),
    Block(text: 'Act'),
    Block(text: '@'),
    Block(text: '096'),
    Block(text: '#'),
    Block(text: 'rOOm'),
    Block(text: '_67'),
    Block(text: 'Lqw'),
  ];

  // List of all blocks available to choose from
  List<Block> allBlocks = [
    Block(text: 'Haneen'),
    Block(text: '12122002'),
    Block(text: '123456'),
    Block(text: '0000'),
    Block(text: '173'),
    Block(text: 'Act'),
    Block(text: '@'),
    Block(text: '096'),
    Block(text: '#'),
    Block(text: 'rOOm'),
    Block(text: '_67'),
    Block(text: 'Lqw'),
    Block(text: 'ahmad'),
    Block(text: '!'),
    Block(text: '0909'),
    Block(text: '079315564'),
    Block(text: 'admin'),
    Block(text: 'user'),
  ];

  // Remove block from menu when dragged
  void removeBlockFromMenu(Block block) {
    setState(() {
      allBlocks.remove(block);
    });
  }

  // Check if the solution is correct
  void _checkSolution() {
    bool isCorrect = true; // Placeholder for actual solution checking logic
    if (isCorrect) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('correct')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('incorrect')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: isDrawerVisible ? 3 : 4,
            child: Stack(
              children: [
                BackgroundPhoto(), // Castle background
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: WallArea(
                    correctPassword: correctPassword,
                    wallHeight: MediaQuery.of(context).size.height / 2,
                    isDrawerVisible: isDrawerVisible,
                  ),
                ),
              ],
            ),
          ),
          if (isDrawerVisible)
            Expanded(
              flex: 1,
              child: RightSideMenu(
                blocks: allBlocks,
                onBlockDragged: removeBlockFromMenu,
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .endFloat, // وضع الزر في الأسفل على اليمين
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _checkSolution, // دالة التحقق من الحل
            child: Icon(Icons.check), // أيقونة علامة الصح
            backgroundColor: Colors.green, // لون الخلفية الأخضر
          ),
          SizedBox(height: 16), // مسافة بين الأزرار
          FloatingActionButton(
            onPressed: () {
              setState(() {
                isDrawerVisible = !isDrawerVisible; // Toggle drawer visibility
              });
            },
            child: Icon(isDrawerVisible
                ? Icons.arrow_forward
                : Icons.arrow_back), // أيقونة التحكم في القائمة
            backgroundColor: Colors.blue, // لون خلفية الزر
          ),
        ],
      ),
    );
  }
}
