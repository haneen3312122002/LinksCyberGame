import 'package:flutter/material.dart';

class Stage extends StatelessWidget {
  final String stageName; // اسم المرحلة
  final Color textColor; // لون النص
  final double fontSize; // حجم النص
  final FontWeight fontWeight; // سمك الخط
  final IconData icon; // الأيقونة بجانب النص
  final String fontFamily; // عائلة الخط

  // Constructor مع قيم افتراضية للخصائص
  Stage({
    required this.stageName,
    this.textColor =
        const Color.fromARGB(255, 250, 71, 0), // اللون الافتراضي للنص هو الأبيض
    this.fontSize = 22.0, // الحجم الافتراضي للنص هو 22
    this.fontWeight = FontWeight.bold, // سمك الخط الافتراضي هو bold
    this.icon = Icons.timeline, // الأيقونة الافتراضية هي نجمة
    this.fontFamily = 'Roboto', // الخط الافتراضي هو Roboto (يمكن تغييره)
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon, // الأيقونة التي تظهر بجانب النص
          color: textColor, // نفس لون النص
          size: fontSize + 5, // حجم الأيقونة يعتمد على حجم النص
        ),
        SizedBox(width: 8), // مسافة صغيرة بين الأيقونة والنص
        Text(
          stageName,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: textColor,
            fontFamily: fontFamily, // استخدام الخط المخصص
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
