import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'Block.dart';
import '/PasswordGame/photo.dart'; // تأكد من وجود BackgroundPhoto
import 'RightMin.dart'; // تأكد من وجود RightSideMenu
import 'Wall.dart'; // تأكد من وجود WallArea
import '/connection.dart'; // تأكد من إضافة ملف ApiService
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

  late AudioPlayer _audioPlayer; // تعريف مشغل الصوت

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPersonalInfoDialog();
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // تحرير موارد مشغل الصوت عند الخروج
    super.dispose();
  }

  Future<void> _playMusic() async {
    try {
      await _audioPlayer.setLoopMode(LoopMode.one); // تكرار الموسيقى
      await _audioPlayer.setAsset('assets/caselSong.ogg'); // مسار ملف الصوت
      await _audioPlayer.play(); // تشغيل الموسيقى
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
        return AlertDialog(
          backgroundColor: Colors.brown,
          title: Text(
            'ادخل معلوماتك الشخصية من فضلك',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'اسمك',
                  labelStyle: TextStyle(color: Colors.brown),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: birthdayController,
                decoration: InputDecoration(
                  labelText: 'تاريخ ميلادك',
                  labelStyle: TextStyle(color: Colors.brown),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'رقم الهاتف',
                  labelStyle: TextStyle(color: Colors.brown),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // تشغيل الموسيقى بعد تفاعل المستخدم
                await _playMusic();

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
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
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
                : DialogType.error,
        animType: AnimType.scale,
        title: 'قوة كلمة المرور',
        desc: strength == 'Strong'
            ? 'كلمة المرور قوية'
            : strength == 'Mid'
                ? 'كلمة المرور متوسطة'
                : 'كلمة المرور ضعيفة',
        btnOkOnPress: () {},
        btnOkColor: strength == 'Strong'
            ? Colors.green
            : strength == 'Mid'
                ? Colors.orange
                : Colors.red,
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
