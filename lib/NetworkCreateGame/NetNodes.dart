import 'package:flutter/material.dart';

class DeviceBase extends StatefulWidget {
  final Function(Offset) onDragStart;
  final Function(Offset) onDragUpdate;
  final Function(Offset) onDragEnd;
  final String? asset; // المسار للصورة الثابتة في البداية

  DeviceBase({
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    this.asset,
  });

  @override
  _DeviceBaseState createState() => _DeviceBaseState();
}

class _DeviceBaseState extends State<DeviceBase> {
  String? currentAsset; // الصورة الحالية التي سيتم عرضها في الدائرة
  bool showVideoControl = false; // التحكم في عرض زر الفيديو
  bool isVideoOpen = false; // حالة الفيديو (مفتوح أم مغلق)

  @override
  void initState() {
    super.initState();
    currentAsset = widget.asset; // تعيين الصورة الأولية
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return DragTarget<Map<String, String>>(
      onAccept: (receivedData) {
        setState(() {
          currentAsset = receivedData['asset']; // تحديث الصورة داخل الدائرة
          // تحقق إذا كانت الصورة من نوع راوتر أو سويتش
          showVideoControl = (currentAsset == 'assets/RO.png' ||
              currentAsset == 'assets/SW.png');
        });
      },
      builder: (context, accepted, rejected) {
        return Column(
          children: [
            GestureDetector(
              onPanStart: (details) =>
                  widget.onDragStart(details.globalPosition),
              onPanUpdate: (details) =>
                  widget.onDragUpdate(details.globalPosition),
              onPanEnd: (details) => widget.onDragEnd(details.globalPosition),
              child: currentAsset == null
                  ? Container(
                      width: screenWidth * 0.08,
                      height: screenWidth * 0.08,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blueAccent, // لون الخلفية
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    )
                  : Image.asset(
                      currentAsset!,
                      width: screenWidth * 0.08,
                      height: screenWidth * 0.08,
                      fit: BoxFit.contain,
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
                    // التحقق من نوع الصورة الأصلية وتشغيل الصورة المتحركة المقابلة
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
                },
              ),
          ],
        );
      },
    );
  }
}
