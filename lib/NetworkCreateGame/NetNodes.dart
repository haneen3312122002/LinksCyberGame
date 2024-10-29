import 'package:flutter/material.dart';

class DeviceBase extends StatelessWidget {
  final Function(Offset) onDragStart;
  final Function(Offset) onDragUpdate;
  final Function(Offset) onDragEnd;

  DeviceBase({
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    // الحصول على عرض الشاشة لتحديد الأبعاد النسبية
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onPanStart: (details) {
        onDragStart(details.globalPosition);
      },
      onPanUpdate: (details) {
        onDragUpdate(details.globalPosition);
      },
      onPanEnd: (details) {
        onDragEnd(details.globalPosition);
      },
      child: Image.asset(
        'assets/Stand.png',
        width: screenWidth * 0.08, // عرض أصغر للصورة
        height: screenWidth * 0.08, // ارتفاع أصغر للصورة
        fit: BoxFit.contain, // لضمان أن الصورة تحتفظ بنسبة الطول والعرض
      ),
    );
  }
}
