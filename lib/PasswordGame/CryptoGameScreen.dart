import 'package:flutter/material.dart';
import 'Block.dart';
import '/PasswordGame/photo.dart'; // Ensure BackgroundPhoto is implemented
import 'RightMin.dart'; // Ensure RightSideMenu is implemented
import 'Wall.dart'; // Ensure WallArea is implemented
import '/connection.dart'; // تأكد من إضافة ملف ApiService

class CryptoGameScreen extends StatefulWidget {
  @override
  _CryptoGameScreenState createState() => _CryptoGameScreenState();
}

class _CryptoGameScreenState extends State<CryptoGameScreen> {
  bool isDrawerVisible = true; // State to track if the drawer is open or closed

  List<Block> correctPassword =
      []; // This will now hold dynamically dragged blocks

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

  // Remove block from menu when dragged and add to the correctPassword list
  void removeBlockFromMenu(Block block) {
    setState(() {
      allBlocks.remove(block);
      correctPassword.add(block); // Add to the list of dragged blocks
    });
  }

  // Check if the solution is correct
  void _checkSolution() async {
    // Join the text of the blocks that have been dragged to form the password
    String password = correctPassword.map((block) => block.text).join();

    try {
      String strength = await ApiServicePasswordGame.checkPassword(password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password is $strength')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
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
                BackgroundPhoto(),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: WallArea(
                    correctPassword:
                        correctPassword, // This will display dragged blocks
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _checkSolution,
            child: Icon(Icons.check),
            backgroundColor: Colors.green,
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                isDrawerVisible = !isDrawerVisible;
              });
            },
            child:
                Icon(isDrawerVisible ? Icons.arrow_forward : Icons.arrow_back),
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
