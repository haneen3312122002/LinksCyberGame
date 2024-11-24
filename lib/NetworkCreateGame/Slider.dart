import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  final bool devicesUnlocked;

  SideMenu({required this.devicesUnlocked});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130, // تقليل عرض القائمة
      color: Colors.blueAccent.withOpacity(0.0), // جعل الخلفية شفافة تمامًا
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: devicesUnlocked
            ? [
                buildDraggableItem(
                    assetPath: 'assets/Computer1.png',
                    deviceType: "Computer1",
                    displayLabel: "كمبيوتر 1"),
                buildDraggableItem(
                    assetPath: 'assets/Computer2.png',
                    deviceType: "Computer2",
                    displayLabel: "كمبيوتر 2"),
                buildDraggableItem(
                    assetPath: 'assets/Computer3.png',
                    deviceType: "Computer3",
                    displayLabel: "كمبيوتر 3"),
                buildDraggableItem(
                    assetPath: 'assets/Printer.png',
                    deviceType: "Printer",
                    displayLabel: "طابعة"),
                buildDraggableItem(
                    assetPath: 'assets/RO.png',
                    deviceType: "router",
                    displayLabel: "راوتر"),
                buildDraggableItem(
                    assetPath: 'assets/SW.png',
                    deviceType: "switch",
                    displayLabel: "سويتش"),
                buildDraggableItem(
                    assetPath: 'assets/Tab.png',
                    deviceType: "Tab",
                    displayLabel: "تابلت"),
                buildDraggableItem(
                  iconData: Icons.wifi, // استخدام أيقونة مدمجة للإنترنت
                  deviceType: "internet",
                  displayLabel: "إنترنت",
                ),
              ]
            : [
                buildDraggableItem(
                  iconData: Icons.wifi, // استخدام أيقونة مدمجة للإنترنت
                  deviceType: "internet",
                  displayLabel: "إنترنت",
                ),
                buildDraggableItem(
                    assetPath: 'assets/RO.png',
                    deviceType: "router",
                    displayLabel: "راوتر"),
                buildDraggableItem(
                    assetPath: 'assets/SW.png',
                    deviceType: "switch",
                    displayLabel: "سويتش"),
              ],
      ),
    );
  }

  Widget buildDraggableItem({
    String? assetPath,
    IconData? iconData,
    required String deviceType,
    required String displayLabel,
  }) {
    return Draggable<Map<String, dynamic>>(
      data: {
        'asset': assetPath,
        'icon': iconData,
        'label': deviceType, // deviceType باللغة الإنجليزية
      },
      feedback: Material(
        color: Colors.transparent,
        child: buildItemContent(
            assetPath: assetPath,
            iconData: iconData,
            displayLabel: displayLabel),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: buildItemContent(
            assetPath: assetPath,
            iconData: iconData,
            displayLabel: displayLabel),
      ),
      child: buildItemContent(
        assetPath: assetPath,
        iconData: iconData,
        isListTile: true,
        displayLabel: displayLabel,
      ),
    );
  }

  Widget buildItemContent({
    String? assetPath,
    IconData? iconData,
    bool isListTile = false,
    String? displayLabel,
  }) {
    if (isListTile && displayLabel != null) {
      return ListTile(
        leading: assetPath != null
            ? Image.asset(assetPath, width: 40)
            : Icon(iconData, color: Colors.white, size: 40),
        title: Text(
          displayLabel,
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
      );
    } else {
      return assetPath != null
          ? Image.asset(assetPath, width: 40)
          : Icon(iconData, color: Colors.white, size: 40);
    }
  }
}
