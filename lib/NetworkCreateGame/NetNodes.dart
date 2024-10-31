import 'package:flutter/material.dart';

class DeviceBase extends StatefulWidget {
  final Function(Offset) onDragStart;
  final Function(Offset) onDragUpdate;
  final Function(Offset) onDragEnd;
  final String? asset; // The initial asset path for the device image
  final Function(bool) onVideoStatusChanged;

  DeviceBase({
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    this.asset,
    required this.onVideoStatusChanged,
  });

  @override
  _DeviceBaseState createState() => _DeviceBaseState();
}

class _DeviceBaseState extends State<DeviceBase> {
  String? currentAsset;
  bool showVideoControl = false;
  bool isVideoOpen = false;
  bool isWifiOn = false;
  bool showWifiControl = false;
  String? deviceType; // New variable to store the device type (e.g., 'tablet')

  @override
  void initState() {
    super.initState();
    currentAsset = widget.asset;
  }

  // Getter to expose the WiFi status
  bool get wifiStatus => isWifiOn;

  // Getter to expose the device type
  String? get getDeviceType => deviceType;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return DragTarget<Map<String, String>>(
      onAccept: (receivedData) {
        setState(() {
          currentAsset = receivedData['asset'];
          deviceType = receivedData['label']; // Store the device type
          // Check if the device is a router or switch to show video control
          showVideoControl = (currentAsset == 'assets/RO.png' ||
              currentAsset == 'assets/SW.png');
          // Check if the device is a tablet to show WiFi control
          showWifiControl = (currentAsset == 'assets/Tab.png');
        });
      },
      builder: (context, accepted, rejected) {
        return Column(
          children: [
            GestureDetector(
              onPanStart: (details) {
                // Check if the tablet's WiFi is on before starting to draw a line
                if (deviceType == 'تابلت' && !isWifiOn) {
                  // Do not allow drawing if WiFi is off
                  return;
                }
                widget.onDragStart(details.globalPosition);
              },
              onPanUpdate: (details) {
                // Only update the line if it's allowed to be drawn
                if (deviceType == 'تابلت' && !isWifiOn) {
                  return;
                }
                widget.onDragUpdate(details.globalPosition);
              },
              onPanEnd: (details) {
                // Only end the line if it was being drawn
                if (deviceType == 'تابلت' && !isWifiOn) {
                  return;
                }
                widget.onDragEnd(details.globalPosition);
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  currentAsset == null
                      ? Container(
                          width: screenWidth * 0.08,
                          height: screenWidth * 0.08,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blueAccent,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        )
                      : Image.asset(
                          currentAsset!,
                          width: screenWidth * 0.08,
                          height: screenWidth * 0.08,
                          fit: BoxFit.contain,
                        ),
                  // Show WiFi icon if it's a tablet
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
                onPressed: () {
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
                  // Notify parent about the change
                  widget.onVideoStatusChanged(isVideoOpen);
                },
              ),
          ],
        );
      },
    );
  }
}
