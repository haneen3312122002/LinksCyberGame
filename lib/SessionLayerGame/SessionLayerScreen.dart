import 'package:flutter/material.dart';
import 'dart:math'; // لاستيراد الشيفرة الخاصة بخلط العناصر
import 'Block.dart'; // استدعاء كلاس Block
import 'TunnelBackground.dart'; // استدعاء كلاس الخلفية
import 'SideColumn.dart'; // استدعاء كلاس العمود الجانبي
import 'SecondColumn.dart'; // استدعاء كلاس العمود الثاني
import 'package:fluttertoast/fluttertoast.dart'; // حزمة الاشعارات
import 'package:audioplayers/audioplayers.dart'; // لاستيراد تشغيل الصوت

class SessionLayerScreen extends StatefulWidget {
  @override
  _SessionLayerScreenState createState() => _SessionLayerScreenState();
}

class _SessionLayerScreenState extends State<SessionLayerScreen> {
  List<Block> secondColumnBlocks = []; // قائمة البلوكات في العمود الثاني
  bool hasLost = false; // للتحقق من حالة الخسارة
  final AudioPlayer _audioPlayer = AudioPlayer(); // مشغل الصوت

  // الترتيب الصحيح للبلوكات
  final List<String> correctOrder = [
    'التأسيس',
    'التزامن',
    'إدارة الجلسة',
    'الإنهاء'
  ];

  // خلط ترتيب البلوكات في العمود الجانبي
  List<Block> getShuffledBlocks() {
    List<Block> blocks = [
      Block(text: 'التأسيس'),
      Block(text: 'التزامن'),
      Block(text: 'إدارة الجلسة'),
      Block(text: 'الإنهاء'),
    ];
    blocks.shuffle(Random());
    return blocks;
  }

  // إعادة تعيين اللعبة
  void resetGame() {
    setState(() {
      secondColumnBlocks.clear();
      hasLost = false;
    });
  }

  // تشغيل الصوت
  Future<void> playSound(String assetPath) async {
    await _audioPlayer.play(AssetSource(assetPath));
  }

  // دالة للتحقق من الترتيب
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
        // عرض إشعار النجاح وتشغيل صوت الفوز
        Fluttertoast.showToast(
          msg: "أتممت المهمة بنجاح!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        playSound('victory.mp3'); // تشغيل صوت النجاح
        resetGame(); // إعادة اللعبة بعد النجاح
      } else {
        setState(() {
          hasLost = true; // اللاعب خسر اللعبة
        });
        playSound('Winning.mp3'); // تشغيل صوت الخسارة
      }
    }
  }

  // دالة لإضافة البلوك إلى العمود الثاني
  void onBlockDragged(Block block) {
    setState(() {
      // تحقق من أن البلوك لم يتم إضافته مسبقًا لتجنب التكرار
      if (!secondColumnBlocks.contains(block)) {
        secondColumnBlocks.add(block);
        checkOrder(); // تحقق من الترتيب بعد إضافة البلوك
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // التخلص من مشغل الصوت عند انتهاء الشاشة
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // عرض الشاشة
    final screenHeight = MediaQuery.of(context).size.height; // ارتفاع الشاشة

    return Scaffold(
      body: Row(
        children: [
          // استدعاء العمود الجانبي مع تمرير قائمة من الكتل المختلطة
          SideColumn(
            blocks: getShuffledBlocks(), // البلوكات المختلطة
            columnWidth: screenWidth * 0.3, // 30% من عرض الشاشة
            columnHeight: screenHeight, // طول الشاشة للعمود
            backgroundColor: Colors.blueGrey[100], // خلفية العمود الجانبي
          ),
          Expanded(
            child: Stack(
              children: [
                TunnelBackground(), // استخدام الخلفية
                if (hasLost)
                  Center(
                    child: AlertDialog(
                      title: Text('لقد خسرت!'),
                      content: Text('قم بالمحاولة مرة أخرى.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            resetGame(); // إعادة اللعبة
                            Navigator.of(context).pop();
                          },
                          child: Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          // استدعاء العمود الثاني مع تمرير الكتل المسقطة
          SecondColumn(
            blocks: secondColumnBlocks,
            columnWidth: screenWidth * 0.3, // 30% من عرض الشاشة
            columnHeight: screenHeight, // طول الشاشة للعمود
            onBlockAccepted: onBlockDragged, // قبول البلوكات المسقطة
            backgroundColor: Colors.green[100], // خلفية العمود الثاني
          ),
        ],
      ),
    );
  }
}
