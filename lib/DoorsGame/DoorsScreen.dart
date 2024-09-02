import 'package:flutter/material.dart';

class DoorsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ضبط الصورة لتغطي كامل الخلفية
        Positioned.fill(
          child: Image.asset(
            'assets/doors.png',
            fit: BoxFit.cover, // جعل الصورة تغطي كامل المساحة
          ),
        ),
        // الأبواب القابلة للضغط مع خلفية خلف النصوص
        Positioned.fill(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDoor(context, 'إضافة بيانات الطلب', false),
              _buildDoor(context, 'إرسال الطلب', false),
              _buildDoor(context, 'اختيار بروتوكول', true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDoor(BuildContext context, String label, bool isCorrect) {
    return GestureDetector(
      onTap: () {
        if (isCorrect) {
          // تنفيذ الأكشن المناسب عند اختيار الخيار الصحيح
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('أحسنت! $label هو الخيار الصحيح.')),
          );
        } else {
          // تنفيذ الأكشن المناسب عند اختيار خيار خاطئ
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('خاطئ! $label ليس الخيار الصحيح.')),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 150), // تعديل لرفع النصوص قليلاً إلى الأعلى
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 229, 130, 8)
                  .withOpacity(0.6), // خلفية نصف شفافة
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
