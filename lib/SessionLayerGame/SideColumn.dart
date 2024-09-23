import 'package:flutter/material.dart';
import 'Block.dart'; // استدعاء كلاس Block

class SideColumn extends StatelessWidget {
  final List<Block> blocks; // قائمة البلوكات
  final double columnWidth; // عرض العمود
  final double columnHeight; // ارتفاع العمود
  final Color? backgroundColor; // لون خلفية العمود

  SideColumn({
    required this.blocks,
    required this.columnWidth,
    required this.columnHeight,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: columnWidth, // العرض الديناميكي للعمود
      height: columnHeight,
      color: backgroundColor, // الخلفية الخاصة بالعمود
      child: ListView(
        children: blocks.map((block) {
          return Container(
            height: columnHeight * 0.2, // تعديل الحجم ليناسب عدد البلوكات
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LongPressDraggable<Block>(
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
      width: width * 0.8, // تقليل العرض ليبدو أفضل
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blueGrey[200], // لون خلفية البلوك
        borderRadius: BorderRadius.circular(10), // تدوير الحواف
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: width * 0.05, // حجم الخط كنسبة من عرض العمود
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
