import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'Block.dart';
import '/PasswordGame/photo.dart'; // Make sure BackgroundPhoto exists
import 'RightMin.dart'; // Make sure RightSideMenu exists
import 'Wall.dart'; // Make sure WallArea exists
import '/connection.dart'; // Ensure ApiService is added
import 'package:awesome_dialog/awesome_dialog.dart';

class CryptoGameScreen extends StatefulWidget {
  @override
  _CryptoGameScreenState createState() => _CryptoGameScreenState();
}

class _CryptoGameScreenState extends State<CryptoGameScreen> {
  bool isDrawerVisible = true;
  Map<String, String> personalInfo = {};
  List<Block> correctPassword = [];
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

    // Start playing music automatically when the game starts
    _playMusic();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPersonalInfoDialog();
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playMusic() async {
    try {
      await _audioPlayer.setAsset('caselSong.mp3'); // Path to the audio file
      await _audioPlayer.setLoopMode(LoopMode.one); // Repeat the audio
      await _audioPlayer.play(); // Play the audio
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  void _showPersonalInfoDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController birthdayController = TextEditingController();
    TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final double screenWidth = MediaQuery.of(context).size.width;
        final double screenHeight = MediaQuery.of(context).size.height;
        final double fontSize = screenWidth * 0.02;

        return AlertDialog(
          backgroundColor: Colors.brown,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'ادخل معلوماتك الشخصية من فضلك',
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                  controller: nameController,
                  label: 'اسمك',
                  fontSize: fontSize,
                  screenWidth: screenWidth / 4,
                ),
                SizedBox(height: screenHeight * 0.015),
                _buildTextField(
                  controller: birthdayController,
                  label: 'تاريخ ميلادك',
                  fontSize: fontSize,
                  screenWidth: screenWidth,
                ),
                SizedBox(height: screenHeight * 0.015),
                _buildTextField(
                  controller: phoneController,
                  label: 'رقم الهاتف',
                  fontSize: fontSize,
                  screenWidth: screenWidth,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                personalInfo = {
                  'name': nameController.text,
                  'birthday': birthdayController.text,
                  'phone': phoneController.text,
                };

                setState(() {
                  if (personalInfo['name']!.isNotEmpty) {
                    allBlocks.add(Block(text: personalInfo['name']!));
                  }
                  if (personalInfo['birthday']!.isNotEmpty) {
                    allBlocks.add(Block(text: personalInfo['birthday']!));
                  }
                  if (personalInfo['phone']!.isNotEmpty) {
                    allBlocks.add(Block(text: personalInfo['phone']!));
                  }
                });

                Navigator.of(context).pop();
              },
              child: Text(
                'ابدا اللعبة ',
                style: TextStyle(color: Colors.white, fontSize: fontSize * 0.9),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required double fontSize,
    required double screenWidth,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.brown,
          fontSize: fontSize,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          vertical: screenWidth * 0.02,
          horizontal: screenWidth * 0.03,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      style: TextStyle(fontSize: fontSize * 0.9),
    );
  }

  void removeBlockFromMenu(Block block) {
    setState(() {
      allBlocks.remove(block);
      correctPassword.add(block);
    });
  }

  void _checkSolution() async {
    String password = correctPassword.map((block) => block.text).join();

    try {
      String strength = await ApiServicePasswordGame.checkPasswordAndInfo(
          password, personalInfo);

      AwesomeDialog(
        context: context,
        dialogType: strength == 'Strong'
            ? DialogType.success
            : strength == 'Mid'
                ? DialogType.warning
                : strength == 'Weak'
                    ? DialogType.error
                    : DialogType.info, // For 'You are using personal info'
        animType: AnimType.scale,
        title: 'قوة كلمة المرور',
        desc: strength == 'Strong'
            ? 'كلمة المرور قوية'
            : strength == 'Mid'
                ? 'كلمة المرور متوسطة'
                : strength == 'Weak'
                    ? 'كلمة المرور ضعيفة'
                    : 'كلمة المرور تحتوي على معلومات شخصية', // Custom message
        btnOkOnPress: () {},
        btnOkColor: strength == 'Strong'
            ? Colors.green
            : strength == 'Mid'
                ? Colors.orange
                : strength == 'Weak'
                    ? Colors.red
                    : Colors.blue, // Custom color for personal info case
      ).show();
    } catch (e) {
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
