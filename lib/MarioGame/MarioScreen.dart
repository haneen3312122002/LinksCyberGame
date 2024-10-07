import 'package:flutter/material.dart';
import 'Char.dart'; // استيراد كلاس الشخصية
import 'MovingBack.dart'; // استيراد كلاس الأرضية

class MarioGame extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<MarioGame> {
  bool isMovingRight = true; // لتتبع اتجاه حركة الشخصية
  bool isHoldingButton = false; // لتتبع استمرار الضغط على الأزرار
  bool isMoving = false; // لتتبع حالة حركة الشخصية

  GlobalKey<State<Ground>> groundKey = GlobalKey(); // استخدام State<Ground>
  Character characterWidget =
      Character(isMovingRight: true, isMoving: false); // استدعاء كلاس الشخصية

  // دالة لبدء الحركة عند الضغط المستمر
  void onLongPressStart(bool isRight) {
    setState(() {
      isHoldingButton = true;
      isMovingRight = isRight;
      isMoving = true; // بدء الحركة
      characterWidget =
          Character(isMovingRight: isMovingRight, isMoving: isMoving);
    });
    startMoving();
  }

  void onLongPressEnd() {
    setState(() {
      isHoldingButton = false;
      isMoving = false; // إيقاف الحركة
      characterWidget =
          Character(isMovingRight: isMovingRight, isMoving: isMoving);
    });
  }

  // تحريك الشخصية والأرضية أثناء الضغط على الزر
  void startMoving() {
    Future.doWhile(() async {
      await Future.delayed(Duration(
          milliseconds:
              16)); // تقليل التأخير لجعل الحركة أسرع (حوالي 60 إطار في الثانية)
      if (isHoldingButton) {
        setState(() {
          (groundKey.currentState as GroundState)
              .moveGround(isMovingRight); // تحريك الأرضية عبر المفتاح
        });
        return true;
      }
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الأرضية المتحركة
          Positioned.fill(
            child: Ground(key: groundKey), // تمرير المفتاح إلى الأرضية
          ),
          // الشخصية فوق الأرضية
          Positioned(
            top: 270,
            left: 20, // ضبط الشخصية لتكون في البداية
            child: Container(
              width: 350, // حجم الشخصية
              height: 350, // حجم الشخصية
              child: characterWidget,
            ),
          ),
          // الأزرار للتحكم في الحركة
          Positioned(
            bottom: 30,
            left: 20,
            child: GestureDetector(
              onLongPress: () => onLongPressStart(false), // الحركة لليسار
              onLongPressUp: onLongPressEnd, // إيقاف الحركة عند رفع الضغط
              child: Icon(Icons.arrow_left, size: 50),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 20,
            child: GestureDetector(
              onLongPress: () => onLongPressStart(true), // الحركة لليمين
              onLongPressUp: onLongPressEnd, // إيقاف الحركة عند رفع الضغط
              child: Icon(Icons.arrow_right, size: 50),
            ),
          ),
        ],
      ),
    );
  }
}
