import 'package:flutter/material.dart';

class TransparentContainer extends StatelessWidget {
  final String label;

  TransparentContainer({required this.label});

  @override
  Widget build(BuildContext context) {
    // استخدام MediaQuery للحصول على أبعاد الشاشة
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(
        top: screenHeight * 0.1, // مسافة من الأعلى
        bottom: screenHeight * 0.1, // مسافة من الأسفل
      ),
      child: Container(
        width: screenWidth / 3, // ثلث عرض الشاشة
        height: screenHeight / 2, // نصف طول الشاشة
        decoration: BoxDecoration(
          color: Colors.transparent, // إزالة الخلفية
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 241, 69, 1),
            ),
          ),
        ),
      ),
    );
  }
}
