import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart'; // Import the just_audio package

class DeviceBase extends StatefulWidget {
  final Function(Offset) onDragStart;
  final Function(Offset) onDragUpdate;
  final Function(Offset, String?, bool) onDragEnd;
  final Function(bool) onVideoStatusChanged;
  final List<String> allowedDeviceTypes; // قائمة بأنواع الأجهزة المسموح بها

  DeviceBase({
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onVideoStatusChanged,
    required this.allowedDeviceTypes, // تمرير القائمة عبر البنية
  });

  @override
  _DeviceBaseState createState() => _DeviceBaseState();
}

class _DeviceBaseState extends State<DeviceBase> {
  String? currentAsset;
  IconData? currentIcon;
  bool showVideoControl = false;
  bool isVideoOpen = false;
  bool isWifiOn = false;
  bool showWifiControl = false;
  String? deviceType;

  final AudioPlayer _audioPlayer = AudioPlayer(); // Audio player instance

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dispose of the audio player
    super.dispose();
  }

  bool get wifiStatus => isWifiOn;
  String? get getDeviceType => deviceType;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return DragTarget<Map<String, dynamic>>(
      onAccept: (receivedData) async {
        String incomingDeviceType = receivedData['label'];

        // التحقق مما إذا كان الجهاز المسموح به
        if (widget.allowedDeviceTypes.contains(incomingDeviceType)) {
          setState(() {
            currentAsset = receivedData['asset'];
            currentIcon = receivedData['icon'];
            deviceType = incomingDeviceType;
            // تحديث شرط عرض التحكم بالفيديو بناءً على نوع الجهاز
            showVideoControl = (currentAsset == 'assets/RO.png' ||
                currentAsset == 'assets/SW.png');
            showWifiControl = (deviceType == 'Tab');
          });

          // Initialize the audio player based on device type
          if (deviceType == 'router') {
            await _audioPlayer.setAsset('assets/Router.mp3');
          }
          // إزالة تحميل Internet.mp3 لأنه لم يعد له فائدة
          // else if (deviceType == 'internet') {
          //   await _audioPlayer.setAsset('assets/Internet.mp3'); // تأكد من وجود هذا الملف
          // }
        } else {
          // عرض رسالة تنبيه إذا كان الجهاز غير مسموح به في هذه الطبقة
          _showInvalidDeviceMessage();
        }
      },
      builder: (context, accepted, rejected) {
        return Column(
          children: [
            GestureDetector(
              onPanStart: (details) {
                if (deviceType == 'Tab' && !isWifiOn) {
                  return;
                }
                widget.onDragStart(details.globalPosition);
              },
              onPanUpdate: (details) {
                if (deviceType == 'Tab' && !isWifiOn) {
                  return;
                }
                widget.onDragUpdate(details.globalPosition);
              },
              onPanEnd: (details) {
                if (deviceType == 'Tab' && !isWifiOn) {
                  return;
                }
                widget.onDragEnd(details.globalPosition, deviceType, isWifiOn);
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  (currentAsset == null && currentIcon == null)
                      ? Container(
                          width: screenWidth * 0.08,
                          height: screenWidth * 0.08,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blueAccent,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        )
                      : (currentAsset != null
                          ? Image.asset(
                              currentAsset!,
                              width: screenWidth * 0.08,
                              height: screenWidth * 0.08,
                              fit: BoxFit.contain,
                            )
                          : Icon(
                              currentIcon,
                              color: Colors.white,
                              size: screenWidth * 0.08,
                            )),
                  if (showWifiControl)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(
                          isWifiOn ? Icons.wifi : Icons.wifi_off,
                          color: isWifiOn ? Colors.green : Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            isWifiOn = !isWifiOn;
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),
            if (showVideoControl)
              IconButton(
                icon: Icon(
                  isVideoOpen
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  color: Colors.red,
                ),
                onPressed: () async {
                  setState(() {
                    isVideoOpen = !isVideoOpen;
                    if (currentAsset == 'assets/RO.png' ||
                        currentAsset == 'assets/ROVID.gif') {
                      currentAsset =
                          isVideoOpen ? 'assets/ROVID.gif' : 'assets/RO.png';
                    } else if (currentAsset == 'assets/SW.png' ||
                        currentAsset == 'assets/SWVID.gif') {
                      currentAsset =
                          isVideoOpen ? 'assets/SWVID.gif' : 'assets/SW.png';
                    }
                  });

                  // Play or stop the audio based on device type
                  if (deviceType == 'router') {
                    if (isVideoOpen) {
                      await _audioPlayer.play();
                    } else {
                      await _audioPlayer.stop();
                    }
                  }

                  widget.onVideoStatusChanged(isVideoOpen);
                },
              ),
          ],
        );
      },
    );
  }

  void _showInvalidDeviceMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تنبيه'),
        content: Text('هذا الجهاز غير مسموح به في هذه الطبقة.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}
