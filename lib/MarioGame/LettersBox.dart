import 'package:flutter/material.dart';

class LetterBox extends StatelessWidget {
  final String letter;

  LetterBox({required this.letter});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200, // عرض الصندوق
      height: 60, // ارتفاع الصندوق
      margin: EdgeInsets.symmetric(horizontal: 100), // مسافة بين الصناديق
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 201, 143, 16),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            offset: Offset(5, 5), // الظل الرئيسي لتحسين العمق
            blurRadius: 8,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            offset: Offset(-3, -3), // ظلال عكسية لإعطاء التأثير البارز
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 3,
                color: Colors.black.withOpacity(0.5), // إضافة ظل للنص أيضًا
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
