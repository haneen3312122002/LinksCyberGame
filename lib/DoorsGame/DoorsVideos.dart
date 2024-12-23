import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Stage {
  String _stageName;
  Color? textColor;
  Color? backgroundColor;
  double? fontSize;
  IconData? icon;

  // Constructor بتعامل مسمى مع جعل stageName مطلوبًا
  Stage({
    required String stageName,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.redAccent,
    this.fontSize = 26.0,
    this.icon = Icons.videogame_asset,
  }) : _stageName = stageName;

  // Getter للحصول على اسم المرحلة
  String get stageName => _stageName;

  // Setter لتغيير اسم المرحلة
  set stageName(String newName) {
    _stageName = newName;
  }

  // دالة لبناء الـ Widget الذي يعرض اسم المرحلة مع الأيقونة
  Widget buildStageWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 30, // حجم الأيقونة
          color: textColor, // لون الأيقونة
        ),
        SizedBox(width: 10), // مسافة بين الأيقونة والنص
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
