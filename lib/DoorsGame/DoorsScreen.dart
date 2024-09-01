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
              _buildDoor(context, 'الباب 1'),
              _buildDoor(context, 'الباب 2'),
              _buildDoor(context, 'الباب 3'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDoor(BuildContext context, String label) {
    return GestureDetector(
      onTap: () {
        // يمكنك تنفيذ الأكشن المناسب عند الضغط على الباب هنا
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label تم الضغط عليه')),
        );
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
              borderRadius: BorderRadius.circular(80),
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
