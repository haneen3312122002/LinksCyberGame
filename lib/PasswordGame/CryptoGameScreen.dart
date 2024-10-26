import 'package:flutter/material.dart';
import 'Block.dart';
import '/PasswordGame/photo.dart'; // Ensure BackgroundPhoto is implemented
import 'RightMin.dart'; // Ensure RightSideMenu is implemented
import 'Wall.dart'; // Ensure WallArea is implemented
import '/connection.dart'; // تأكد من إضافة ملف ApiService
import 'package:awesome_dialog/awesome_dialog.dart';

class CryptoGameScreen extends StatefulWidget {
  @override
  _CryptoGameScreenState createState() => _CryptoGameScreenState();
}

class _CryptoGameScreenState extends State<CryptoGameScreen> {
  bool isDrawerVisible = true; // State to track if the drawer is open or closed
  Map<String, String> personalInfo = {}; // Store personal info locally

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPersonalInfoDialog();
    });
  }

  // Method to display dialog to gather personal information
  void _showPersonalInfoDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController birthdayController = TextEditingController();
    TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown, // Brown background for the dialog
          title: Text(
            'ادخل معلوماتك الشخصية من فضلك',
            style: TextStyle(color: Colors.white), // White text color
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
              onPressed: () {
                // Collect and save the entered personal info locally
                personalInfo = {
                  'name': nameController.text,
                  'birthday': birthdayController.text,
                  'phone': phoneController.text,
                };

                setState(() {
                  // Add personal info to blocks if not empty
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

                Navigator.of(context).pop(); // Close the dialog
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
      // Send the complete password and personal info to the backend
      String strength = await ApiServicePasswordGame.checkPasswordAndInfo(
          password, personalInfo);

      // Display the result in an AwesomeDialog based on the password strength
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
      // Show an error if there's a problem with checking the password
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
