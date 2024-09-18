import 'package:flutter/material.dart';

class SecondColumn extends StatelessWidget {
  final List<String> blocks; // قائمة البلوكات المسقطة

  SecondColumn({required this.blocks});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3, // 30% من عرض الشاشة
      color: Colors.grey[300], // خلفية للعمود
      child: Column(
        children: [
          ...blocks.map((block) => buildBlock(block)).toList(),
          Expanded(
            child: DragTarget<String>(
              onAccept: (data) {
                // استقبال العنصر المسحوب
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  height: 100,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      'إسقاط هنا',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // دالة لبناء البلوك
  Widget buildBlock(String label) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: ListTile(
        title: Text(label),
      ),
    );
  }
}
