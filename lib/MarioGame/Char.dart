import 'package:flutter/material.dart';

class Character extends StatelessWidget {
  final bool isMovingRight;
  final bool isMoving;

  Character({required this.isMovingRight, required this.isMoving});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      isMoving
          ? (isMovingRight
              ? 'assets/RightChar.gif'
              : 'assets/LeftChar.gif') // صورة متحركة أثناء الحركة
          : (isMovingRight
              ? 'assets/StaticRightChar.png'
              : 'assets/StaticLeftChar.png'), // صورة ثابتة حسب الاتجاه الأخير
      fit: BoxFit.contain,
    );
  }
}
