import 'package:flutter/material.dart';
import 'Block.dart'; // استدعاء كلاس Block

class SecondColumn extends StatelessWidget {
  final List<Block> blocks; // قائمة البلوكات المسقطة
  final double columnWidth; // عرض العمود
  final double columnHeight; // ارتفاع العمود
  final Color? backgroundColor; // لون خلفية العمود
  final Function(Block) onBlockAccepted; // الدالة التي تستقبل البلوك

  SecondColumn(
      {required this.blocks,
      required this.columnWidth,
      required this.columnHeight,
      required this.backgroundColor,
      required this.onBlockAccepted});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: columnWidth, // العرض الديناميكي للعمود
      height: columnHeight,
      color: backgroundColor, // الخلفية الخاصة بالعمود
      child: Column(
        children: [
          ...blocks
              .map((block) => Container(
                    height: columnHeight * 0.25, // كل بلوك يأخذ ربع طول العمود
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildBlock(block.text, columnWidth),
                    ),
                  ))
              .toList(),
          Expanded(
            child: DragTarget<Block>(
              onAccept: (block) {
                onBlockAccepted(block); // استقبال العنصر المسحوب
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
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
  Widget buildBlock(String label, double width) {
    return Container(
      width: width,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.green[200], // لون خلفية البلوك
        borderRadius: BorderRadius.circular(10), // تدوير الحواف
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: width * 0.07, // حجم الخط كنسبة من عرض العمود
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
