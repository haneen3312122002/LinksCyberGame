import 'package:flutter/material.dart';
import 'Char.dart'; // استيراد كلاس الشخصية
import 'MovingBack.dart'; // استيراد كلاس الأرضية
import 'LettersBox.dart'; // استيراد كلاس الصناديق

class MarioGame extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<MarioGame> {
  bool isMovingRight = true; // لتتبع اتجاه حركة الشخصية
  bool isHoldingButton = false; // لتتبع استمرار الضغط على الأزرار
  bool isMoving = false; // لتتبع حالة حركة الشخصية
  bool isJumping = false; // لتتبع حالة القفز
  double scrollOffset = -500.0; // لجعل الشخصية تبدأ قبل الحرف A
  double characterY = 137.0; // تعديل موضع الشخصية لتكون أعلى في الشاشة
  double groundY = 270.0; // ارتفاع الأرضية (الأرضية الأساسية)
  double initialCharacterY = 137.0; // الموضع الأصلي للشخصية
  double characterX = 0; // لتتبع موضع الشخصية الأفقي

  GlobalKey<State<Ground>> groundKey = GlobalKey(); // استخدام State<Ground>
  Character characterWidget =
      Character(isMovingRight: true, isMoving: false); // استدعاء كلاس الشخصية

  // قائمة الحروف من A إلى Z بترتيب عكسي
  List<Widget> letterBoxes = List.generate(
    26,
    (index) => LetterBox(letter: String.fromCharCode(65 + index)),
  ).reversed.toList(); // عكس الترتيب لعرض الحروف من اليمين إلى اليسار

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

  // تحريك الخلفية والأحرف أثناء الضغط على الزر
  void startMoving() {
    Future.doWhile(() async {
      await Future.delayed(Duration(milliseconds: 16)); // 60 إطار في الثانية
      if (isHoldingButton) {
        setState(() {
          double moveDistance =
              MediaQuery.of(context).size.width * 0.01; // نفس سرعة الخلفية

          // تحريك الأرضية
          (groundKey.currentState as GroundState).moveGround(isMovingRight);

          // التحقق من الاصطدام بالصناديق
          bool isCollision = checkCollisionWithBoxes();

          if (!isCollision) {
            // إذا لم يكن هناك اصطدام، استمر في تحريك الشخصية
            if (isMovingRight) {
              scrollOffset -= moveDistance; // تحريك الأحرف لليسار مع الشخصية
              characterX += moveDistance;
            } else {
              scrollOffset += moveDistance; // تحريك الأحرف لليمين مع الشخصية
              characterX -= moveDistance;
            }
          }
        });
        return true;
      }
      return false;
    });
  }

  // دالة للقفز
  void jump() async {
    if (isJumping) return; // إذا كانت الشخصية تقفز بالفعل فلا تقفز مرة أخرى
    setState(() {
      isJumping = true;
    });

    // القفز لأعلى
    for (int i = 0; i < 15; i++) {
      await Future.delayed(Duration(milliseconds: 30));
      setState(() {
        characterY -= 10; // تحرك الشخصية لأعلى
      });
    }

    // النزول للأسفل
    for (int i = 0; i < 15; i++) {
      await Future.delayed(Duration(milliseconds: 30));
      setState(() {
        if (characterY < groundY) {
          characterY += 10; // تحرك الشخصية للأسفل
        }
      });
    }

    setState(() {
      // إعادة الشخصية إلى الموضع الأصلي بسلاسة بعد النزول الكامل
      characterY = initialCharacterY;
      isJumping = false;
    });
  }

  // التحقق مما إذا كانت الشخصية اصطدمت بصندوق
  bool checkCollisionWithBoxes() {
    double boxWidth = 200.0; // عرض الصندوق
    double boxX = scrollOffset;

    for (int i = 0; i < letterBoxes.length; i++) {
      double boxLeft = boxX + (i * (boxWidth + 20)); // حساب موقع الصندوق
      double boxRight = boxLeft + boxWidth;

      // تحقق مما إذا كانت الشخصية تقترب من الصندوق
      if (characterX + 100 >= boxLeft && characterX + 100 <= boxRight) {
        // إذا كانت الشخصية تصطدم بالصندوق
        if (characterY >= groundY - 50) {
          return true; // تمنع الحركة الأفقية
        }
      }
    }
    return false; // تسمح بالحركة الأفقية إذا لم يكن هناك اصطدام
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الأرضية في الخلف
          Positioned.fill(
            child: Ground(key: groundKey), // الأرضية تتحرك بشكل مستقل
          ),
          // حاوية لدمج الشخصية والصناديق معًا في نفس الطبقة
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Stack(
              children: [
                // الصناديق والشخصية في نفس الطبقة
                Positioned(
                  bottom: 45, // وضع الصناديق فوق الأرضية
                  left: scrollOffset, // تحريك الحروف بشكل مستقل
                  child: Row(
                    mainAxisSize: MainAxisSize
                        .min, // إضافة هذا السطر لتفادي القيود غير النهائية
                    children: letterBoxes, // عرض الحروف
                  ),
                ),
                // الشخصية ثابتة في مكانها ولكن تتحرك عموديًا للقفز
                Positioned(
                  top: characterY, // تحريك الشخصية عموديًا
                  left: MediaQuery.of(context).size.width / 2 -
                      100, // تثبيت الشخصية في وسط الشاشة
                  child: SizedBox(
                    width: 350,
                    height: 350,
                    child: characterWidget,
                  ),
                ),
              ],
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
          // Gesture لتفعيل القفز
          GestureDetector(
            onVerticalDragStart: (_) => jump(), // القفز عند السحب لأعلى
          ),
        ],
      ),
    );
  }
}
