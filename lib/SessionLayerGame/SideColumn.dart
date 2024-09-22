import 'package:flutter/material.dart';
import 'Block.dart'; // استدعاء كلاس Block

class SideColumn extends StatelessWidget {
  final List<Block> blocks; // قائمة البلوكات
  final double columnWidth; // عرض العمود
  final double columnHeight; // ارتفاع العمود
  final Color? backgroundColor; // لون خلفية العمود

  SideColumn(
      {required this.blocks,
      required this.columnWidth,
      required this.columnHeight,
      required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: columnWidth, // العرض الديناميكي للعمود
      height: columnHeight,
      color: backgroundColor, // الخلفية الخاصة بالعمود
      child: Column(
        children: blocks.map((block) {
          return Container(
            height: columnHeight * 0.25, // كل بلوك يأخذ ربع طول العمود
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Draggable<Block>(
                data: block,
                feedback: Material(
                  color: Colors.transparent, // لجعل السحب يبدو واضحًا
                  child: buildBlock(block.text, columnWidth),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.5, // تقليل الشفافية عند السحب
                  child: buildBlock(block.text, columnWidth),
                ),
                child: buildBlock(block.text, columnWidth),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // دالة لبناء البلوك
  Widget buildBlock(String label, double width) {
    return Container(
      width: width,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blueGrey[200], // لون خلفية البلوك
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
