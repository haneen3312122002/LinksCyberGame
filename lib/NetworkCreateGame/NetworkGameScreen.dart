import 'package:flutter/material.dart';
import 'dart:math';
import 'package:just_audio/just_audio.dart'; // Import just_audio for background music
import 'NetNodes.dart';
import 'Slider.dart';
import 'package:flutter/services.dart';

class NetworkGameScreen extends StatefulWidget {
  @override
  _NetworkGameScreenState createState() => _NetworkGameScreenState();
}

class _NetworkGameScreenState extends State<NetworkGameScreen> {
  final AudioPlayer _backgroundAudioPlayer =
      AudioPlayer(); // Background music player
// الجزء الثابت من عنوان IP
  static const String fixedIPPart = '192.168.1.';

  Offset? startDragPosition;
  Offset? currentDragPosition;
  List<Map<String, dynamic>> connections = [];
  Map<String, int> deviceConnectionsCount = {
    'router': 0,
    'switch': 0,
    'internet': 0, // إضافة الإنترنت
  };
  Map<String, int> devicePositions = {};

  bool isGifPlaying = false;
  int gifPlayingCount = 0;
  bool devicesUnlocked = false;

  // خريطة لتخزين عناوين IP لكل جهاز بناءً على فهرسه
  Map<int, String> deviceIPs = {};

  // مجموعة لتتبع عناوين IP المستخدمة لضمان عدم التكرار
  Set<String> usedIPs = {};

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

    // تحديد مركز الشاشة أفقيًا
    final centerX = screenWidth / 2;

    // تحديد المسافة العمودية بين الطبقات (زيادة المسافة العمودية)
    final verticalSpacing = screenHeight * 0.2; // زيادة من 0.15 إلى 0.2

    // تحديد المسافة العلوية لبدء الطبقة الأولى (زيادة المسافة من أعلى الشاشة)
    final startY =
        screenHeight * 0.05; // تقليل من 0.1 إلى 0.05 لزيادة المسافة العلوية

    // تحديد الطبقات وعدد الأجهزة في كل طبقة
    final layers = [
      1, // الطبقة الأولى: دائرة واحدة
      1, // الطبقة الثانية: دائرة واحدة
      2, // الطبقة الثالثة: دائرتان
      5, // الطبقة الرابعة: خمس دوائر
    ];

    // تحديد المسافة العمودية الإضافية للطبقة الأخيرة
    final extraSpacingLastLayer =
        screenHeight * 0.05; // مسافة إضافية للطبقة الأخيرة

    List<Offset> positions = [];

    for (int layerIndex = 0; layerIndex < layers.length; layerIndex++) {
      int numberOfDevices = layers[layerIndex];
      double layerY = startY + layerIndex * verticalSpacing;

      // إذا كانت الطبقة هي الأخيرة، نضيف المسافة العمودية الإضافية
      if (layerIndex == layers.length - 1) {
        layerY += extraSpacingLastLayer;
      }

      // حساب المسافات الأفقية بناءً على عدد الأجهزة في الطبقة
      // لضمان التوزيع المتساوي والمتمركز
      double horizontalSpacing;
      if (numberOfDevices > 1) {
        // المسافة بين الأجهزة تعتمد على عددها (زيادة المسافة الأفقية)
        horizontalSpacing = screenWidth * 0.15; // زيادة من 0.15 إلى 0.2
      } else {
        // إذا كانت الطبقة تحتوي على جهاز واحد، يتم وضعه في مركز الشاشة
        horizontalSpacing = 0;
      }

      for (int deviceIndex = 0; deviceIndex < numberOfDevices; deviceIndex++) {
        double xPosition;

        if (numberOfDevices == 1) {
          // إذا كانت الطبقة تحتوي على جهاز واحد، يتم وضعه في مركز الشاشة
          xPosition = centerX;
        } else {
          // إذا كانت الطبقة تحتوي على أكثر من جهاز، يتم توزيعها بشكل متساوٍ حول المركز
          // حساب الإزاحة من المركز
          double totalWidth = (numberOfDevices - 1) * horizontalSpacing;
          double startX = centerX - totalWidth / 2;

          xPosition = startX + deviceIndex * horizontalSpacing;
        }

        // إزاحة الدائرة الأولى في الطبقة الثالثة إلى اليسار قليلاً
        if (layerIndex == 2 && deviceIndex == 0) {
          // تحديد مقدار الإزاحة (مثلاً 20 نقطة إلى اليسار)
          double xOffset = -190.0; // تم تقليل الإزاحة من -200.0 إلى -190.0
          xPosition += xOffset;
        }

        // إضافة الموقع إلى القائمة
        positions.add(Offset(xPosition, layerY));
      }
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
    if (startDragPosition != null && canConnectDevice(deviceType ?? '')) {
      Color lineColor = const Color.fromARGB(255, 221, 111, 255);
      if (deviceType == 'Tab' && wifiStatus) {
        lineColor = const Color.fromARGB(
            255, 12, 220, 19); // لون أخضر إذا كان من تابلت مع WiFi مفعل
      }

      setState(() {
        connections.add({
          'start': startDragPosition!,
          'end': end,
          'color': lineColor,
        });
        startDragPosition = null;
        currentDragPosition = null;
        addConnection(deviceType ?? '');
      });
      checkCentralDevices();
    }
  }

  bool canConnectDevice(String deviceType) {
    if (deviceType == 'router' && deviceConnectionsCount['router']! >= 1) {
      _showMessage('الراوتر لا يقبل أكثر من توصيل واحد.');
      return false;
    } else if (deviceType == 'switch' &&
        deviceConnectionsCount['switch']! >= 2) {
      // طبقة 3 بها سويتشين
      _showMessage('السويتش متصل بالفعل بحد أقصى.');
      return false;
    } else if (deviceType == 'internet' &&
        deviceConnectionsCount['internet']! >= 1) {
      // طبقة 1 تسمح بجهاز واحد
      // مثال على حد التوصيل للإنترنت
      _showMessage('الإنترنت متصل بالفعل بجهاز واحد.');
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
        devicePositions['switch'] != null &&
        devicePositions['internet'] != null) {
      // التأكد من وجود الإنترنت
      final routerPosition = devicePositions['router'];
      final switchPosition = devicePositions['switch'];
      final internetPosition = devicePositions['internet'];
      if ((routerPosition == 0 || routerPosition == 1) &&
          (switchPosition == 0 || switchPosition == 1) &&
          (internetPosition == 0 || internetPosition == 1)) {
        // الوضع الصحيح للأجهزة المركزية
      } else {
        _showMessage(
            'يجب وضع الراوتر والسويتش والإنترنت في المواقع المركزية فقط.');
      }
    }
  }

  // دالة للتعامل مع الضغط على جهاز معين لإدخال عنوان IP
  void _onDeviceTap(int index) {
    String? currentIP = deviceIPs[index];
    // استخراج الخانة الرابعة من عنوان IP الحالي إذا كانت موجودة
    String currentLastOctet = '';
    if (currentIP != null && currentIP.startsWith(fixedIPPart)) {
      currentLastOctet = currentIP.substring(fixedIPPart.length);
    }
    TextEditingController _ipController =
        TextEditingController(text: currentLastOctet);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('إدخال عنوان IP'),
          content: Row(
            children: [
              Text(fixedIPPart),
              Expanded(
                child: TextField(
                  controller: _ipController,
                  decoration: InputDecoration(
                    hintText: 'الخانة الرابعة',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                String enteredLastOctet = _ipController.text.trim();
                String fullIP = fixedIPPart + enteredLastOctet;
                if (!_validateLastOctet(enteredLastOctet)) {
                  _showMessage(
                      'الخانة الرابعة غير صالحة. يجب أن تكون بين 0 و 255.');
                  return;
                }
                if (usedIPs.contains(fullIP) && deviceIPs[index] != fullIP) {
                  _showMessage('هذا عنوان IP مستخدم بالفعل.');
                  return;
                }
                setState(() {
                  if (deviceIPs.containsKey(index)) {
                    usedIPs.remove(deviceIPs[index]!);
                  }
                  deviceIPs[index] = fullIP;
                  usedIPs.add(fullIP);
                });
                Navigator.of(context).pop();
              },
              child: Text('حفظ'),
            ),
          ],
        );
      },
    );
  }

  // دالة للتحقق من صحة عنوان IP
  // دالة للتحقق من صحة الخانة الرابعة من عنوان IP
  bool _validateLastOctet(String octet) {
    if (octet.isEmpty) return false;
    int? num = int.tryParse(octet);
    if (num == null || num < 0 || num > 255) return false;
    return true;
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
                      String? deviceTypeAtPosition;

                      // تحديد نوع الجهاز بناءً على الفهرس
                      if (index == 0) {
                        deviceTypeAtPosition = 'internet';
                      } else if (index == 1) {
                        deviceTypeAtPosition = 'router';
                      } else if (index == 2 || index == 3) {
                        deviceTypeAtPosition = 'switch';
                      } else {
                        deviceTypeAtPosition = 'device'; // عام
                      }

                      // تحديد أنواع الأجهزة المسموح بها لكل طبقة
                      List<String> allowedDeviceTypes;
                      if (index == 0) {
                        allowedDeviceTypes = ['internet'];
                      } else if (index == 1) {
                        allowedDeviceTypes = ['router'];
                      } else if (index == 2 || index == 3) {
                        allowedDeviceTypes = ['switch'];
                      } else {
                        allowedDeviceTypes = [
                          'Computer1',
                          'Computer2',
                          'Computer3',
                          'Printer',
                          'Tab'
                        ];
                      }

                      return Positioned(
                        left: position.dx,
                        top: position.dy,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () => _onDeviceTap(index),
                              child: DeviceBase(
                                allowedDeviceTypes:
                                    allowedDeviceTypes, // تمرير أنواع الأجهزة المسموح بها
                                onDragStart: (start) =>
                                    startDraggingLine(start),
                                onDragUpdate: (update) =>
                                    updateDraggingLine(update),
                                onDragEnd: (end, deviceType, wifiStatus) =>
                                    endDraggingLine(
                                        end, deviceType, wifiStatus),
                                onVideoStatusChanged: (isPlaying) {
                                  setState(() {
                                    if (isPlaying) {
                                      gifPlayingCount++;
                                      isGifPlaying = true;
                                      devicesUnlocked = true;
                                    } else {
                                      gifPlayingCount =
                                          max(0, gifPlayingCount - 1);
                                      isGifPlaying = gifPlayingCount > 0;
                                    }
                                  });
                                },
                              ),
                            ),
                            if (deviceIPs.containsKey(index))
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  deviceIPs[index]!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    backgroundColor: Colors.black54,
                                  ),
                                ),
                              ),
                          ],
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
          // هنا يمكنك تعديل deviceConnectionsCount إذا لزم الأمر
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
