import 'package:flutter/material.dart';
import 'dart:math';
import 'NetNodes.dart';
import 'Slider.dart'; // استدعاء القائمة الجانبية

class NetworkGameScreen extends StatefulWidget {
  @override
  _NetworkGameScreenState createState() => _NetworkGameScreenState();
}

class _NetworkGameScreenState extends State<NetworkGameScreen> {
  Offset? startDragPosition;
  Offset? currentDragPosition;
  List<List<Offset>> connections = []; // قائمة لتخزين النقاط المتصلة

  List<Offset> _generateDevicePositions(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final centerX = screenWidth / 2;
    final centerY = screenHeight / 2;
    final radius = min(screenWidth, screenHeight) * 0.45;

    List<Offset> positions = [
      Offset(centerX - screenWidth * 0.05, centerY),
      Offset(centerX + screenWidth * 0.05, centerY),
    ];

    for (int i = 0; i < 6; i++) {
      double angle = (2.2 * pi / 6) * i;
      double x = centerX + radius * cos(angle);
      double y = centerY + radius * sin(angle);
      positions.add(Offset(x, y));
    }

    return positions;
  }

  void startDraggingLine(Offset start) {
    setState(() {
      startDragPosition = start;
      currentDragPosition = start;
    });
  }

  void updateDraggingLine(Offset newPosition) {
    setState(() {
      currentDragPosition = newPosition;
    });
  }

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
      body: Row(
        children: [
          SideMenu(), // استدعاء القائمة الجانبية كعنصر ثابت
          Expanded(
            child: Stack(
              children: [
                CustomPaint(
                  painter: LinePainter(
                      connections, startDragPosition, currentDragPosition),
                  child: Container(),
                ),
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
          ),
        ],
      ),
    );
  }
}
//..................

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
