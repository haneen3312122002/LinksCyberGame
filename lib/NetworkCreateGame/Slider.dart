import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  final bool devicesUnlocked;

  SideMenu({required this.devicesUnlocked});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180, // عرض القائمة
      color: Colors.blueAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: devicesUnlocked
            ? [
                buildDraggableItem('assets/Computer1.png', "كمبيوتر 1"),
                buildDraggableItem('assets/Computer2.png', "كمبيوتر 2"),
                buildDraggableItem('assets/Computer3.png', "كمبيوتر 3"),
                buildDraggableItem('assets/Printer.png', "طابعة"),
                buildDraggableItem('assets/RO.png', "راوتر"),
                buildDraggableItem('assets/SW.png', "سويتش"),
                buildDraggableItem('assets/Tab.png', "تابلت"),
              ]
            : [
                buildDraggableItem('assets/RO.png', "راوتر"),
                buildDraggableItem('assets/SW.png', "سويتش"),
              ],
      ),
    );
  }

  Widget buildDraggableItem(String assetPath, String label) {
    return Draggable<Map<String, String>>(
      data: {'asset': assetPath, 'label': label},
      feedback: Material(
        color: Colors.transparent,
        child: Image.asset(assetPath, width: 40),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: Image.asset(assetPath, width: 40),
      ),
      child: ListTile(
        leading: Image.asset(assetPath, width: 40),
        title: Text(label, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
