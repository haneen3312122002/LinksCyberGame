import 'package:flutter/material.dart';
import 'dart:math';
import 'package:just_audio/just_audio.dart'; // Import just_audio for background music
import 'NetNodes.dart';
import 'Slider.dart';

class NetworkGameScreen extends StatefulWidget {
  @override
  _NetworkGameScreenState createState() => _NetworkGameScreenState();
}

class _NetworkGameScreenState extends State<NetworkGameScreen> {
  final AudioPlayer _backgroundAudioPlayer =
      AudioPlayer(); // Background music player

  Offset? startDragPosition;
  Offset? currentDragPosition;
  List<Map<String, dynamic>> connections = [];
  Map<String, int> deviceConnectionsCount = {
    'router': 0,
    'switch': 0,
  };
  Map<String, int> devicePositions = {};

  bool isGifPlaying = false;
  int gifPlayingCount = 0;
  bool devicesUnlocked = false;

  @override
  void initState() {
    super.initState();
    _playBackgroundMusic();
  }

  @override
  void dispose() {
    _backgroundAudioPlayer.dispose(); // Dispose of the audio player
    super.dispose();
  }

  Future<void> _playBackgroundMusic() async {
    await _backgroundAudioPlayer.setAsset('assets/networkbuild.mp3');
    _backgroundAudioPlayer
        .setLoopMode(LoopMode.one); // Loop the background music
    await _backgroundAudioPlayer.play(); // Start playing
  }

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

  void endDraggingLine(Offset end, String? deviceType, bool wifiStatus) {
    if (startDragPosition != null) {
      Color lineColor = const Color.fromARGB(255, 221, 111, 255);
      if (deviceType == 'تابلت' && wifiStatus) {
        lineColor = const Color.fromARGB(
            255, 12, 220, 19); // Green color if from tablet with WiFi on
      }

      setState(() {
        connections.add({
          'start': startDragPosition!,
          'end': end,
          'color': lineColor,
        });
        startDragPosition = null;
        currentDragPosition = null;
      });
      checkCentralDevices();
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
    if (devicePositions['router'] != null &&
        devicePositions['switch'] != null) {
      final routerPosition = devicePositions['router'];
      final switchPosition = devicePositions['switch'];
      if ((routerPosition == 0 || routerPosition == 1) &&
          (switchPosition == 0 || switchPosition == 1)) {
        // Correct positioning
      } else {
        _showMessage('يجب وضع الراوتر والسويتش في المواقع المركزية فقط.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final devicePositionsList = _generateDevicePositions(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/NetworkBack.png'), // Set background image
            fit: BoxFit.cover, // Make it cover the full screen
          ),
        ),
        child: Row(
          children: [
            SideMenu(devicesUnlocked: devicesUnlocked),
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
                        child: DeviceBase(
                          onDragStart: (start) => startDraggingLine(start),
                          onDragUpdate: (update) => updateDraggingLine(update),
                          onDragEnd: (end, deviceType, wifiStatus) =>
                              endDraggingLine(end, deviceType, wifiStatus),
                          onVideoStatusChanged: (isPlaying) {
                            setState(() {
                              if (isPlaying) {
                                gifPlayingCount++;
                                isGifPlaying = true;
                                devicesUnlocked = true;
                              } else {
                                gifPlayingCount = max(0, gifPlayingCount - 1);
                                isGifPlaying = gifPlayingCount > 0;
                              }
                            });
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
      ),
    );
  }

  void _handleTapOnConnection(Offset tapPosition) {
    for (int i = 0; i < connections.length; i++) {
      final connection = connections[i];
      final p1 = connection['start'];
      final p2 = connection['end'];
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
}

class LinePainter extends CustomPainter {
  final List<Map<String, dynamic>> connections;
  final Offset? start;
  final Offset? end;

  LinePainter(this.connections, this.start, this.end);

  @override
  void paint(Canvas canvas, Size size) {
    for (var connection in connections) {
      Paint paint = Paint()
        ..color =
            connection['color'] ?? const Color.fromARGB(255, 114, 224, 249)
        ..strokeWidth = 10.0
        ..style = PaintingStyle.stroke;
      canvas.drawLine(connection['start'], connection['end'], paint);
    }

    if (start != null && end != null) {
      Paint paint = Paint()
        ..color = const Color.fromARGB(255, 255, 0, 0)
        ..strokeWidth = 10.0
        ..style = PaintingStyle.stroke;
      canvas.drawLine(start!, end!, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
