// stage.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Stage extends StatelessWidget {
  final String stageName;
  final Color textColor;
  final Color backgroundColor;
  final double fontSize;
  final IconData icon;

  // Constructor بتعامل مسمى مع جعل stageName مطلوبًا
  Stage({
    required this.stageName,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.redAccent,
    this.fontSize = 26.0,
    this.icon = Icons.videogame_asset,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 30, // حجم الأيقونة
          color: textColor, // لون الأيقونة
        ),
        SizedBox(width: 10.w), // مسافة بين الأيقونة والنص
        Text(
          stageName,
          style: TextStyle(
            fontSize: fontSize, // حجم الخط
            color: textColor, // لون النص
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
