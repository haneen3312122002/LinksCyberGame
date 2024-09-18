import 'package:flutter/material.dart';

class SideColumn extends StatelessWidget {
  final Function(String) onBlockDragged; // تمرير الدالة لاستقبال العنصر المسحوب

  SideColumn({required this.onBlockDragged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3, // 30% من عرض الشاشة
      color: Colors.grey[200], // خلفية للعمود
      child: Column(
        children: [
          buildDraggableBlock('الصفحة الرئيسية', Icons.home),
          buildDraggableBlock('الشبكات', Icons.network_wifi),
          buildDraggableBlock('الأمان', Icons.security),
          buildDraggableBlock('الإعدادات', Icons.settings),
        ],
      ),
    );
  }

  // دالة لبناء بلوك قابل للسحب
  Widget buildDraggableBlock(String label, IconData icon) {
    return Draggable<String>(
      data: label, // البيانات المسحوبة
      feedback: Material(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blueGrey[50],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: ListTile(
            leading: Icon(icon, color: Colors.blue),
            title: Text(label),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5, // تغيير الشفافية أثناء السحب
        child: buildBlock(label, icon),
      ),
      child: buildBlock(label, icon),
    );
  }

  // دالة لبناء البلوك
  Widget buildBlock(String label, IconData icon) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(label),
      ),
    );
  }
}
