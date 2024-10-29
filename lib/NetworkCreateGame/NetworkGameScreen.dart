import 'package:flutter/material.dart';
import 'dart:math';

class NetworkGameScreen extends StatefulWidget {
  @override
  _NetworkGameScreenState createState() => _NetworkGameScreenState();
}

class _NetworkGameScreenState extends State<NetworkGameScreen> {
  Offset? startDragPosition;
  Offset? currentDragPosition;
  List<List<Offset>> connections = []; // قائمة لتخزين النقاط المتصلة

  List<Offset> _generateDevicePositions(BuildContext context) {
    // الحصول على حجم الشاشة
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // حساب المركز
    final centerX = screenWidth / 2;
    final centerY = screenHeight / 2;

    // نصف قطر الدائرة للقواعد المحيطة
    final radius = min(screenWidth, screenHeight) * 0.45;

    // القاعدتان في المنتصف بشكل متساوي حول المركز
    List<Offset> positions = [
      Offset(centerX - screenWidth * 0.05, centerY), // القاعدة المركزية الأولى
      Offset(centerX + screenWidth * 0.05, centerY), // القاعدة المركزية الثانية
    ];

    // توزيع 6 قواعد حول الشاشة على شكل دائرة
    for (int i = 0; i < 6; i++) {
      double angle = (2.2 * pi / 6) * i; // حساب الزاوية لكل قاعدة
      double x = centerX + radius * cos(angle);
      double y = centerY + radius * sin(angle);
      positions.add(Offset(x, y));
    }

    return positions;
  }

  // دالة لبدء الرسم من القاعدة
  void startDraggingLine(Offset start) {
    setState(() {
      startDragPosition = start;
      currentDragPosition = start;
    });
  }

  // دالة لتحديث موضع الخط أثناء السحب
  void updateDraggingLine(Offset newPosition) {
    setState(() {
      currentDragPosition = newPosition;
    });
  }

  // دالة لإنهاء السحب عند توصيل الخط بقاعدة أخرى
  void endDraggingLine(Offset end) {
    if (startDragPosition != null) {
      setState(() {
        connections.add([startDragPosition!, end]);
        startDragPosition = null;
        currentDragPosition = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final devicePositions = _generateDevicePositions(context);

    return Scaffold(
      body: Stack(
        children: [
          // رسم الخطوط الثابتة المحفوظة في قائمة connections
          CustomPaint(
            painter: LinePainter(
                connections, startDragPosition, currentDragPosition),
            child: Container(),
          ),
          // عرض القواعد باستخدام صورة Stand.png
          ...devicePositions.asMap().entries.map((entry) {
            int index = entry.key;
            Offset position = entry.value;
            return Positioned(
              left: position.dx,
              top: position.dy,
              child: DeviceBase(
                onDragStart: (start) => startDraggingLine(start),
                onDragUpdate: (update) => updateDraggingLine(update),
                onDragEnd: (end) => endDraggingLine(end),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

// كلاس لرسم جميع الاتصالات
class LinePainter extends CustomPainter {
  final List<List<Offset>> connections; // قائمة الاتصالات
  final Offset? start;
  final Offset? end;

  LinePainter(this.connections, this.start, this.end);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // رسم الخطوط المحفوظة في قائمة connections
    for (var connection in connections) {
      canvas.drawLine(connection[0], connection[1], paint);
    }

    // رسم الخط الديناميكي أثناء السحب
    if (start != null && end != null) {
      canvas.drawLine(start!, end!, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

// ويدجت DeviceBase لتمثيل القاعدة باستخدام صورة Stand.png
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
