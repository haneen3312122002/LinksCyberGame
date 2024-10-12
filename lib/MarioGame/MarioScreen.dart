import 'package:flutter/material.dart';
import 'dart:async';
import 'Char.dart';
import 'MovingBack.dart';

class MarioGame extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<MarioGame> {
  double characterX = 50; // تعديل نقطة بدء الشخصية
  double characterY = 70; // مستوى الأرض عند البداية
  bool isMovingRight = true;
  bool isJumping = false;
  double gravity = -0.5; // تعديل قيمة الجاذبية لتناسب القفز
  double velocityY = 0;
  bool onPlatform = false;

  Timer? moveTimer;

  // تحريك الشخصية بشكل سلس عند الضغط المستمر
  void startMoving(bool moveRight) {
    // التأكد من إيقاف أي حركة سابقة
    stopMoving();

    moveTimer = Timer.periodic(Duration(milliseconds: 30), (timer) {
      setState(() {
        double screenWidth = MediaQuery.of(context).size.width; // عرض الشاشة

        if (moveRight) {
          // التأكد من عدم الخروج من الجانب الأيمن
          if (characterX + 5 <= screenWidth - 100) {
            characterX += 5; // تحريك لليمين
            isMovingRight = true;
          }
        } else {
          // التأكد من عدم الخروج من الجانب الأيسر
          if (characterX - 5 >= 0) {
            characterX -= 5; // تحريك لليسار
            isMovingRight = false;
          }
        }
      });
    });
  }

  void stopMoving() {
    if (moveTimer != null) {
      moveTimer?.cancel(); // إلغاء أي حركة مستمرة عند رفع اليد
      moveTimer = null;
    }
  }

  // منطق القفز
  void jump() {
    if (!isJumping && !onPlatform) {
      isJumping = true;
      velocityY = 10; // السرعة الأولية للقفز
      Timer.periodic(Duration(milliseconds: 30), (timer) {
        setState(() {
          characterY += velocityY; // تحديث المحور الرأسي
          velocityY += gravity; // تأثير الجاذبية

          // إذا وصلت الشخصية إلى الأرض
          if (characterY <= 70) {
            characterY = 70; // العودة إلى المستوى الأصلي للأرض
            isJumping = false;
            velocityY = 0;
            timer.cancel();
          }

          // التحقق من التصادم مع المنصة العائمة
          if (characterY <= 150 &&
              characterY > 100 &&
              characterX >= 300 &&
              characterX <= 450) {
            // إذا كانت الشخصية داخل حدود المنصة
            onPlatform = true;
            characterY = 150; // توقف عند مستوى المنصة
            velocityY = 0;
            timer.cancel();
          } else {
            onPlatform = false;
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameBackground(),
          GameGround(),
          GameCharacter(
            characterX: characterX, // تمرير إحداثيات X
            characterY: characterY, // تمرير إحداثيات Y
            isMovingRight: isMovingRight,
          ),
          FloatingPlatform(platformX: 300, platformY: 150), // المنصة العائمة
          Obstacle(obstacleX: 500), // العائق
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onPanStart: (_) => startMoving(true), // بدء الحركة لليمين عند الضغط
            onPanEnd: (_) => stopMoving(), // إيقاف الحركة عند رفع اليد
            child: FloatingActionButton(
              onPressed: () {}, // إضافة onPressed حتى لو لم يكن له وظيفة
              child: Icon(Icons.arrow_forward),
            ),
          ),
          GestureDetector(
            onPanStart: (_) =>
                startMoving(false), // بدء الحركة لليسار عند الضغط
            onPanEnd: (_) => stopMoving(), // إيقاف الحركة عند رفع اليد
            child: FloatingActionButton(
              onPressed: () {}, // إضافة onPressed حتى لو لم يكن له وظيفة
              child: Icon(Icons.arrow_back),
            ),
          ),
          FloatingActionButton(
            onPressed: jump,
            child: Icon(Icons.arrow_upward),
          ),
        ],
      ),
    );
  }
}
