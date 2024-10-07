import 'package:flutter/material.dart';

class Ground extends StatefulWidget {
  Ground({Key? key}) : super(key: key); // إضافة المفتاح إلى المنشئ
  @override
  GroundState createState() => GroundState(); // جعل الكلاس عامًا
}

class GroundState extends State<Ground> {
  final List<String> groundImages = [
    'assets/Ground1.png',
    'assets/Ground2.png',
    'assets/Ground3.png',
  ];

  double backgroundX1 = 0.0;
  double backgroundX2 = 0.0;
  double screenWidth = 0.0;
  double screenHeight = 0.0;
  bool hasMovedRight = false; // لتتبع ما إذا كانت الشخصية تحركت لليمين أولًا

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // احصل على عرض الشاشة وارتفاعها
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    // ضبط الخلفية الثانية لتكون تابعة للأولى مباشرة
    backgroundX2 = screenWidth;
  }

  // دالة لتحريك الأرضية بناءً على اتجاه الحركة
  void moveGround(bool isMovingRight) {
    setState(() {
      if (!hasMovedRight && !isMovingRight) {
        return; // لا تتحرك إذا كانت الشخصية تتحرك لليسار ولم تتحرك لليمين بعد
      }

      double moveDistance = screenWidth * 0.01; // سرعة التحرك

      if (isMovingRight) {
        hasMovedRight = true;
        backgroundX1 -= moveDistance;
        backgroundX2 -= moveDistance;
      } else {
        backgroundX1 += moveDistance;
        backgroundX2 += moveDistance;
      }

      // إعادة ضبط الخلفيات عند تجاوزها الشاشة لتجنب المساحات البيضاء
      if (backgroundX1 <= -screenWidth) {
        backgroundX1 = backgroundX2 + screenWidth;
      }
      if (backgroundX2 <= -screenWidth) {
        backgroundX2 = backgroundX1 + screenWidth;
      }

      if (backgroundX1 >= screenWidth) {
        backgroundX1 = backgroundX2 - screenWidth;
      }
      if (backgroundX2 >= screenWidth) {
        backgroundX2 = backgroundX1 - screenWidth;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // الخلفية الأولى
        Positioned(
          left: backgroundX1,
          child: Image.asset(
            groundImages[0], // عرض الصورة الأولى
            width: screenWidth,
            height: screenHeight,
            fit: BoxFit.cover,
          ),
        ),
        // الخلفية الثانية
        Positioned(
          left: backgroundX2,
          child: Image.asset(
            groundImages[1], // عرض الصورة الثانية
            width: screenWidth,
            height: screenHeight,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
