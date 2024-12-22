import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:just_audio/just_audio.dart';

// Local imports (replace with your actual file paths)
import 'Block.dart';
import 'photo.dart'; // e.g., BackgroundPhoto widget
import 'RightMin.dart'; // e.g., RightSideMenu widget
import 'Wall.dart'; // e.g., WallArea widget
import 'package:cybergame/connection.dart';

/// ---------------------------------------------------------------------------
/// Flutter widget representing your game/screen
/// ---------------------------------------------------------------------------
class CryptoGameScreen extends StatefulWidget {
  final Map<String, String> personalInfo;

  CryptoGameScreen({required this.personalInfo});

  @override
  _CryptoGameScreenState createState() => _CryptoGameScreenState();
}

class _CryptoGameScreenState extends State<CryptoGameScreen> {
  bool isDrawerVisible = true;

  // Blocks that form the final password the user drags together
  List<Block> correctPassword = [];

  // Example blocks (add as needed)
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

  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playMusic();

    // Optionally, add personal info as blocks
    widget.personalInfo.forEach((key, value) {
      allBlocks.add(Block(text: value));
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playMusic() async {
    try {
      // Make sure this audio asset is in your 'pubspec.yaml'
      await _audioPlayer.setAsset('assets/caselSong.mp3');
      await _audioPlayer.setLoopMode(LoopMode.one);
      await _audioPlayer.play();
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  // Removes block from the 'drawer' and adds it to the 'correctPassword'
  void removeBlockFromMenu(Block block) {
    setState(() {
      allBlocks.remove(block);
      correctPassword.add(block);
    });
  }

  // Joins the blocks to form the final password and checks it
  void _checkSolution() async {
    // Join all block texts to form a single password string
    String password = correctPassword.map((block) => block.text).join();

    print("Debug: Sending password: $password");
    print("Debug: Sending personal info: ${widget.personalInfo}");

    try {
      // Call the API to check password strength
      String strength = await ApiServicePasswordGame.checkPasswordAndInfo(
        password,
        widget.personalInfo,
      );

      // Choose a color based on strength
      Color passwordColor;
      if (strength == 'Strong') {
        passwordColor = Colors.green;
      } else if (strength == 'Mid') {
        passwordColor = Colors.orange;
      } else {
        passwordColor = Colors.red;
      }

      // Show dialog with the result
      AwesomeDialog(
        context: context,
        dialogType: strength == 'Strong'
            ? DialogType.success
            : strength == 'Mid'
                ? DialogType.warning
                : strength == 'You are using personal info'
                    ? DialogType.warning
                    : DialogType.error, // 'Weak'
        animType: AnimType.scale,
        title: 'قوة كلمة المرور',
        desc: _buildDialogDescription(strength),
        btnOkOnPress: () {
          // If you want to navigate to another screen when password is Mid or Strong:
          // if (strength == 'Strong' || strength == 'Mid') {
          //   Navigator.push(context, MaterialPageRoute(...));
          // }
        },
        btnOkText: (strength == 'Strong' || strength == 'Mid')
            ? 'إلى الصفحة التالية'
            : 'حسناً',
        btnOkColor: passwordColor,
      ).show();
    } catch (e) {
      // Show an error dialog
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: 'خطأ',
        desc: 'فشل في التحقق من كلمة المرور: $e',
        btnOkOnPress: () {},
        btnOkColor: Colors.red,
      ).show();
    }
  }

  // Helper function to build the dialog description text
  String _buildDialogDescription(String strength) {
    switch (strength) {
      case 'Strong':
        return 'كلمة المرور قوية';
      case 'Mid':
        return 'كلمة المرور متوسطة';
      case 'You are using personal info':
        return 'تستخدم بيانات شخصية في كلمة المرور';
      case 'Weak':
      default:
        return 'كلمة المرور ضعيفة';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Main game area
          Expanded(
            flex: isDrawerVisible ? 3 : 4,
            child: Stack(
              children: [
                // Custom background
                BackgroundPhoto(),
                // The "wall" area at bottom
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
          // Right "drawer" that lists all blocks
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
          // Button to check the password
          FloatingActionButton(
            onPressed: _checkSolution,
            child: Icon(Icons.check),
            backgroundColor: Colors.green,
          ),
          SizedBox(height: 16),
          // Toggle the drawer
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
