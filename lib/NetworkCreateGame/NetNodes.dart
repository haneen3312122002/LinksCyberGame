import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart'; // Import the just_audio package

class DeviceBase extends StatefulWidget {
  final Function(Offset) onDragStart;
  final Function(Offset) onDragUpdate;
  final Function(Offset, String?, bool) onDragEnd;
  final String? asset;
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
  String? deviceType;

  final AudioPlayer _audioPlayer = AudioPlayer(); // Audio player instance

  @override
  void initState() {
    super.initState();
    currentAsset = widget.asset;
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

    return DragTarget<Map<String, String>>(
      onAccept: (receivedData) {
        setState(() {
          currentAsset = receivedData['asset'];
          deviceType = receivedData['label'];
          showVideoControl = (currentAsset == 'assets/RO.png' ||
              currentAsset == 'assets/SW.png');
          showWifiControl = (currentAsset == 'assets/Tab.png');
        });
        // Initialize the audio player if the device is a router
        if (deviceType == 'راوتر') {
          _audioPlayer.setAsset('assets/Router.mp3');
        }
      },
      builder: (context, accepted, rejected) {
        return Column(
          children: [
            GestureDetector(
              onPanStart: (details) {
                if (deviceType == 'تابلت' && !isWifiOn) {
                  return;
                }
                widget.onDragStart(details.globalPosition);
              },
              onPanUpdate: (details) {
                if (deviceType == 'تابلت' && !isWifiOn) {
                  return;
                }
                widget.onDragUpdate(details.globalPosition);
              },
              onPanEnd: (details) {
                if (deviceType == 'تابلت' && !isWifiOn) {
                  return;
                }
                widget.onDragEnd(details.globalPosition, deviceType, isWifiOn);
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

                  // Play or stop the audio if the device is a router
                  if (deviceType == 'راوتر') {
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
}
