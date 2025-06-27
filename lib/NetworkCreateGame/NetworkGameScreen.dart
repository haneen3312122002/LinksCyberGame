import 'package:flutter/material.dart';
import 'dart:math';
import 'package:just_audio/just_audio.dart'; // Import just_audio for background music
import 'NetNodes.dart';
import 'Slider.dart';
import 'package:flutter/services.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class NetworkGameScreen extends StatefulWidget {
  @override
  _NetworkGameScreenState createState() => _NetworkGameScreenState();
}

class _NetworkGameScreenState extends State<NetworkGameScreen> {
  Map<int, String> placedDevices = {};
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

  // --- بداية التعديل: منطق جديد لإضافة التوصيلات ---
  void endDraggingLine(Offset end, String? deviceType, bool wifiStatus) {
    if (startDragPosition == null) return;

    // البحث عن الجهاز الهدف الذي تم إفلات الخط فوقه
    int? targetIndex = _getDeviceIndexAtPosition(end);

    // إذا لم يتم الإفلات على جهاز صالح، أو إذا كان الجهاز الهدف هو نفس المصدر، قم بإلغاء العملية
    int? sourceIndex = _getDeviceIndexAtPosition(startDragPosition!);
    if (targetIndex == null ||
        sourceIndex == null ||
        sourceIndex == targetIndex) {
      setState(() {
        startDragPosition = null;
        currentDragPosition = null;
      });
      return;
    }

    // التحقق من صلاحية التوصيل المنطقي
    String? errorMessage = _isConnectionValid(sourceIndex, targetIndex);

    if (errorMessage == null) {
      // التوصيل صالح، قم بإضافته
      setState(() {
        connections.add({
          // استخدم إحداثيات مركز الجهاز المصدر والهدف
          'start': _generateDevicePositions(context)[sourceIndex],
          'end': _generateDevicePositions(context)[targetIndex],
          'color': const Color.fromARGB(255, 114, 224, 249),
        });
      });
      _checkWinCondition();
    } else {
      // التوصيل غير صالح، أظهر رسالة خطأ
      _showMessage(errorMessage);
    }

    // إعادة تعيين متغيرات السحب في كل الحالات
    setState(() {
      startDragPosition = null;
      currentDragPosition = null;
    });
  }

  String? _isConnectionValid(int sourceIndex, int targetIndex) {
    String sourceType = _getDeviceTypeByIndex(sourceIndex);
    String targetType = _getDeviceTypeByIndex(targetIndex);

    var connectionPair = {sourceType, targetType};
    var indexedPair = {sourceIndex, targetIndex};

    // منع إنشاء توصيلة موجودة بالفعل
    for (var conn in connections) {
      int? s = _getDeviceIndexAtPosition(conn['start']);
      int? e = _getDeviceIndexAtPosition(conn['end']);
      if (s != null && e != null && ({s, e} == indexedPair)) {
        return "هذان الجهازان متصلان بالفعل.";
      }
    }

    int sourceConnections = _countConnectionsForDevice(sourceIndex);

    // القاعدة 1: الإنترنت (Wi-Fi) يتصل بالراوتر فقط
    if (sourceType == 'internet' || targetType == 'internet') {
      if (!connectionPair.contains('router'))
        return "يجب توصيل الإنترنت (Wi-Fi) بالراوتر فقط.";
      if (_countConnectionsForDevice(0) >= 1) return "الإنترنت متصل بالفعل.";
    }
    // القاعدة 2: الراوتر يتصل بالإنترنت والسويتشات
    else if (sourceType == 'router' || targetType == 'router') {
      if (!connectionPair.contains('switch') &&
          !connectionPair.contains('internet'))
        return "يجب توصيل الراوتر بالإنترنت أو بالسويتشات.";
      if (_countConnectionsForDevice(1) >= 3)
        return "الراوتر ممتلئ (يقبل توصيلة من الإنترنت وتوصيلتين للسويتشات).";
    }
    // القاعدة 3: السويتش يتصل بالراوتر والأجهزة الطرفية
    else if (sourceType == 'switch' || targetType == 'switch') {
      if (!connectionPair.contains('router') &&
          !_isEndDevice(sourceType) &&
          !_isEndDevice(targetType)) {
        return "يجب توصيل السويتش بالراوتر أو بالأجهزة الطرفية.";
      }
      int switchIndex = sourceType == 'switch' ? sourceIndex : targetIndex;
      if (_countConnectionsForDevice(switchIndex) >= 4)
        return "هذا السويتش ممتلئ."; // 1 للراوتر + 3 أجهزة
    }
    // القاعدة 4: الأجهزة الطرفية تتصل بالسويتشات فقط
    else if (_isEndDevice(sourceType) || _isEndDevice(targetType)) {
      if (!connectionPair.contains('switch'))
        return "يجب توصيل الأجهزة الطرفية بالسويتش فقط.";
      if (_isEndDevice(sourceType) && sourceConnections >= 1)
        return "هذا الجهاز متصل بالفعل.";
      if (_isEndDevice(targetType) &&
          _countConnectionsForDevice(targetIndex) >= 1)
        return "هذا الجهاز متصل بالفعل.";
    } else {
      return "توصيلة غير معروفة.";
    }

    return null; // التوصيل صالح
  }
// --- نهاية التعديل ---

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
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      headerAnimationLoop: false,
      title: 'تنبيه',
      desc: message,
      btnOkOnPress: () {},
      btnOkColor: Colors.orangeAccent,
    ).show();
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

// --- دوال مساعدة جديدة ---
  int? _getDeviceIndexAtPosition(Offset position) {
    final positions = _generateDevicePositions(context);
    for (int i = 0; i < positions.length; i++) {
      if ((position - positions[i]).distance < 35) {
        return i;
      }
    }
    return null;
  }

  String _getDeviceTypeByIndex(int index) {
    if (index == 0) return 'internet';
    if (index == 1) return 'router';
    if (index == 2 || index == 3) return 'switch';
    // بالنسبة للأجهزة الطرفية، استخدم النوع من الخريطة
    return placedDevices[index] ?? 'device_placeholder'; // Placeholder type
  }

  bool _isEndDevice(String type) {
    return type == 'Computer1' ||
        type == 'Computer2' ||
        type == 'Computer3' ||
        type == 'Printer' ||
        type == 'Tab' ||
        type == 'device_placeholder';
  }

  int _countConnectionsForDevice(int deviceIndex) {
    int count = 0;
    for (var conn in connections) {
      int? startIndex = _getDeviceIndexAtPosition(conn['start']);
      int? endIndex = _getDeviceIndexAtPosition(conn['end']);
      if (startIndex == deviceIndex || endIndex == deviceIndex) {
        count++;
      }
    }
    return count;
  }

  bool _isConnected(int index1, int index2) {
    var targetPair = {index1, index2};
    for (var conn in connections) {
      int? startIndex = _getDeviceIndexAtPosition(conn['start']);
      int? endIndex = _getDeviceIndexAtPosition(conn['end']);
      if (startIndex != null && endIndex != null) {
        if ({startIndex, endIndex} == targetPair) {
          return true;
        }
      }
    }
    return false;
  }

// --- نهاية الدوال المساعدة الجديدة ---
  // دالة للتعامل مع الضغط على جهاز معين لإدخال عنوان IP
  void _onDeviceTap(int index) {
    String? currentIP = deviceIPs[index];
    String currentLastOctet = '';
    if (currentIP != null && currentIP.startsWith(fixedIPPart)) {
      currentLastOctet = currentIP.substring(fixedIPPart.length);
    }
    TextEditingController _ipController =
        TextEditingController(text: currentLastOctet);

    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.scale,
      headerAnimationLoop: false,
      title: 'إدخال عنوان IP',
      body: Row(
        children: [
          Text(
            fixedIPPart,
            style: TextStyle(color: Colors.black87, fontSize: 18),
          ),
          Expanded(
            child: TextField(
              controller: _ipController,
              decoration: InputDecoration(
                hintText: 'الخانة الرابعة',
                hintStyle: TextStyle(color: Colors.grey),
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
      btnOkText: 'حفظ',
      btnOkOnPress: () {
        String enteredLastOctet = _ipController.text.trim();
        String fullIP = fixedIPPart + enteredLastOctet;
        if (!_validateLastOctet(enteredLastOctet)) {
          _showMessage('الخانة الرابعة غير صالحة. يجب أن تكون بين 0 و 255.');
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
        _checkWinCondition(); // Check win condition after setting IP
      },
      btnCancelText: 'إلغاء',
      btnCancelOnPress: () {},
    ).show();
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
                        left: position.dx - 35, // اطرح نصف عرض الجهاز
                        top: position.dy - 35,
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
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    deviceIPs[index]!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
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

  // دالة لفحص شروط الفوز
  // --- بداية التعديل: منطق جديد للتحقق من الفوز ---
// --- بداية التعديل: منطق جديد للتحقق من الفوز ---
  void _checkWinCondition() {
    // الشرط 1: يجب أن يكون لجميع الأجهزة التسعة عناوين IP فريدة
    if (deviceIPs.length != 9 || usedIPs.length != 9) {
      return;
    }

    // الشرط 2: التحقق من التوصيلات الصحيحة
    bool internetToRouter = _isConnected(0, 1);
    int routerToSwitchCount =
        (_isConnected(1, 2) ? 1 : 0) + (_isConnected(1, 3) ? 1 : 0);

    int connectedEndDevicesCount = 0;
    for (int i = 4; i <= 8; i++) {
      if (_isConnected(i, 2) || _isConnected(i, 3)) {
        connectedEndDevicesCount++;
      }
    }

    // شروط الفوز:
    // 1. الإنترنت متصل بالراوتر.
    // 2. الراوتر متصل بالسويتشين.
    // 3. كل الأجهزة الطرفية الخمسة متصلة.
    if (internetToRouter &&
        routerToSwitchCount == 2 &&
        connectedEndDevicesCount == 5) {
      _showWinDialog();
    }
  }

// --- نهاية التعديل ---
// --- نهاية التعديل ---
  // دالة للحصول على نوع الجهاز بناءً على موقع التوصيل
  String _getDeviceTypeByPosition(Offset position) {
    for (int index = 0;
        index < _generateDevicePositions(context).length;
        index++) {
      Offset devicePos = _generateDevicePositions(context)[index];
      // حساب مدى قرب نقطة التوصيل من موقع الجهاز
      double distance = (devicePos - position).distance;
      if (distance < 30.0) {
        // حد قريب
        String? deviceType = _getDeviceTypeAtLayer(index);
        return deviceType ?? '';
      }
    }
    return '';
  }

  // دالة للحصول على نوع الجهاز في طبقة معينة
  String? _getDeviceTypeAtLayer(int index) {
    if (index == 0) return 'internet';
    if (index == 1) return 'router';
    if (index == 2 || index == 3) return 'switch';
    if (index >= 4 && index <= 8) {
      // يمكن تخصيص أنواع الأجهزة لكل فهرس إذا لزم الأمر
      return deviceIPs[index] != null
          ? deviceTypeFromIP(deviceIPs[index]!)
          : null;
    }
    return null;
  }

  // دالة لاسترجاع نوع الجهاز من عنوان IP (يمكن تعديلها حسب الحاجة)
  String deviceTypeFromIP(String ip) {
    // هنا يمكنك تحديد نوع الجهاز بناءً على IP أو أي منطق آخر
    // على سبيل المثال:
    if (ip.endsWith('1')) return 'Computer1';
    if (ip.endsWith('2')) return 'Computer2';
    if (ip.endsWith('3')) return 'Computer3';
    if (ip.endsWith('4')) return 'Printer';
    if (ip.endsWith('5')) return 'Tab';
    return 'device';
  }

  // دالة لعرض مربع حوار الفوز
  void _showWinDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      headerAnimationLoop: false,
      title: 'تهانينا!',
      desc: 'لقد فزت في اللعبة!',
      btnOkText: 'إعادة',
      btnOkOnPress: () {
        _resetGame();
      },
      btnOkColor: Colors.blueAccent,
    ).show();
  }

  // دالة لإعادة ضبط اللعبة بعد الفوز
  void _resetGame() {
    setState(() {
      connections.clear();
      deviceConnectionsCount = {
        'router': 0,
        'switch': 0,
        'internet': 0,
      };
      deviceIPs.clear();
      usedIPs.clear();
    });
  }

  // دالة لفحص شروط الفوز
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
