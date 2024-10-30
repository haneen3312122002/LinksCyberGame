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
  Map<String, int> deviceConnectionsCount = {
    'router': 0,
    'switch': 0,
  }; // عدد توصيلات الأجهزة
  Map<String, int> devicePositions = {}; // المواقع لكل جهاز

  List<Offset> _generateDevicePositions(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final centerX = screenWidth / 2;
    final centerY = screenHeight / 2;
    final radius = min(screenWidth, screenHeight) * 0.45;

    List<Offset> positions = [
      Offset(centerX - screenWidth * 0.05, centerY), // الموقع الأول
      Offset(centerX + screenWidth * 0.05, centerY), // الموقع الثاني
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
      checkCentralDevices(); // فحص المواقع بعد إضافة اتصال جديد
    }
  }

  bool canConnectDevice(String deviceType) {
    if (deviceType == 'router' && deviceConnectionsCount['router']! >= 3) {
      _showMessage('الراوتر لا يقبل أكثر من 3 توصيلات. استخدم السويتش.');
      return false;
    } else if (deviceType == 'switch' &&
        deviceConnectionsCount['switch']! >= 4) {
      _showMessage('السويتش متصل بالفعل بأربع أجهزة.');
      return false;
    }
    return true;
  }

  void addConnection(String deviceType) {
    setState(() {
      deviceConnectionsCount[deviceType] =
          deviceConnectionsCount[deviceType]! + 1;
    });
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تنبيه'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void checkCentralDevices() {
    // تحقق أن الراوتر والسويتش في المواقع المركزية فقط
    if (devicePositions['router'] != null &&
        devicePositions['switch'] != null) {
      final routerPosition = devicePositions['router'];
      final switchPosition = devicePositions['switch'];
      if ((routerPosition == 0 || routerPosition == 1) &&
          (switchPosition == 0 || switchPosition == 1)) {
        // الوضع سليم
      } else {
        _showMessage('يجب وضع الراوتر والسويتش في المواقع المركزية فقط.');
      }
    }
  }

  // وظيفة للتحقق من النقر بالقرب من خط معين
  void _handleTapOnConnection(Offset tapPosition) {
    for (int i = 0; i < connections.length; i++) {
      final connection = connections[i];
      final p1 = connection[0];
      final p2 = connection[1];

      // حساب المسافة بين النقطة والنقرة
      double distance = _distanceToLine(tapPosition, p1, p2);
      if (distance < 10.0) {
        setState(() {
          connections.removeAt(i);
        });
        break;
      }
    }
  }

  double _distanceToLine(Offset point, Offset lineStart, Offset lineEnd) {
    final dx = lineEnd.dx - lineStart.dx;
    final dy = lineEnd.dy - lineStart.dy;
    final lengthSquared = dx * dx + dy * dy;
    if (lengthSquared == 0) return (point - lineStart).distance;

    final t = max(
        0,
        min(
            1,
            ((point.dx - lineStart.dx) * dx + (point.dy - lineStart.dy) * dy) /
                lengthSquared));
    final projection = Offset(lineStart.dx + t * dx, lineStart.dy + t * dy);
    return (point - projection).distance;
  }

  @override
  Widget build(BuildContext context) {
    final devicePositionsList = _generateDevicePositions(context);

    return Scaffold(
      body: Row(
        children: [
          SideMenu(), // استدعاء القائمة الجانبية كعنصر ثابت
          Expanded(
            child: GestureDetector(
              onTapDown: (details) {
                _handleTapOnConnection(details.localPosition);
              },
              child: Stack(
                children: [
                  CustomPaint(
                    painter: LinePainter(
                        connections, startDragPosition, currentDragPosition),
                    child: Container(),
                  ),
                  ...devicePositionsList.asMap().entries.map((entry) {
                    int index = entry.key;
                    Offset position = entry.value;
                    return Positioned(
                      left: position.dx,
                      top: position.dy,
                      child: DragTarget<Map<String, String>>(
                        onAccept: (data) {
                          if (data['label'] == 'راوتر') {
                            if (!canConnectDevice('router')) return;
                            addConnection('router');
                            devicePositions['router'] = index;
                          } else if (data['label'] == 'سويتش') {
                            addConnection('switch');
                            devicePositions['switch'] = index;
                          }
                          setState(() {
                            connections.add([startDragPosition!, position]);
                          });
                        },
                        builder: (context, accepted, rejected) {
                          return DeviceBase(
                            onDragStart: (start) => startDraggingLine(start),
                            onDragUpdate: (update) =>
                                updateDraggingLine(update),
                            onDragEnd: (end) => endDraggingLine(end),
                          );
                        },
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//..................
// رسام الخطوط بين الأجهزة
class LinePainter extends CustomPainter {
  final List<List<Offset>> connections; // قائمة الاتصالات
  final Offset? start;
  final Offset? end;

  LinePainter(this.connections, this.start, this.end);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color =
          const Color.fromARGB(255, 122, 240, 255) // تغيير اللون إلى الرمادي
      ..strokeWidth = 10.0 // زيادة السمك لجعل الخط غليظاً
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
