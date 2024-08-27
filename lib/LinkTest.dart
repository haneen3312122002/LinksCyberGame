import 'package:flutter/material.dart';

class LinkCheckerScreen extends StatefulWidget {
  @override
  _LinkCheckerScreenState createState() => _LinkCheckerScreenState();
}

// تأكد من إنشاء هذا الملف وحفظه في نفس المسار
class LinkChecker {
  static Future<String> checkLink(String link) async {
    // هنا يمكنك وضع كود لفحص الرابط باستخدام البايثون أو أي طريقة أخرى
    // حالياً سنعيد رسالة ثابتة كمثال
    return 'الرابط آمن'; // يمكن تغيير هذه القيمة لاختبار الحالة الأخرى
  }
}

class _LinkCheckerScreenState extends State<LinkCheckerScreen> {
  final TextEditingController _linkController = TextEditingController();

  String result = '';

  void checkLink() async {
    String link = _linkController.text;

    // استخدام الوظيفة من الملف الآخر لفحص الرابط
    String linkResult = await LinkChecker.checkLink(link);

    setState(() {
      result = linkResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    // الحصول على حجم الشاشة الحالي
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    // تحديد لون الصندوق بناءً على النتيجة
    Color boxColor;
    if (result == 'الرابط آمن') {
      boxColor = Colors.green;
    } else if (result == 'الرابط غير آمن') {
      boxColor = Colors.orange;
    } else {
      boxColor = Colors.transparent; // اللون الافتراضي قبل ظهور النتيجة
    }

    return Scaffold(
      backgroundColor:
          Colors.lightBlue[50], // تحديد خلفية الشاشة باللون الأزرق الفاتح
      appBar: AppBar(title: Text('فحص الرابط')),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05, // عرض الحواف يساوي 5% من عرض الشاشة
          vertical: screenHeight * 0.02, // طول الحواف يساوي 2% من طول الشاشة
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // خلفية الحقل بيضاء
                borderRadius: BorderRadius.circular(20.0), // حواف مستديرة
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25), // لون الظل
                    offset: Offset(0, 4), // تحديد موقع الظل
                    blurRadius: 8.0, // تحديد مدى انتشار الظل
                  ),
                ],
              ),
              child: TextField(
                controller: _linkController,
                decoration: InputDecoration(
                  hintText: 'أدخل الرابط هنا',
                  prefixIcon: Icon(Icons.link),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0), // حواف مستديرة
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(
                    color: Colors.blue), // لون النص الذي يكتب داخل الحقل
              ),
            ),
            SizedBox(
                height: screenHeight *
                    0.03), // المسافة بين العناصر تساوي 3% من طول الشاشة
            SizedBox(
              width: screenWidth * 0.5, // عرض الزر يساوي 50% من عرض الشاشة
              height: screenHeight * 0.07, // ارتفاع الزر يساوي 7% من طول الشاشة
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // لون الزر أحمر
                ),
                onPressed: checkLink,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'افحص الرابط',
                      style: TextStyle(
                        color: Colors.white, // لون النص أبيض
                        fontSize: screenHeight * 0.025, // حجم النص
                      ),
                    ),
                    SizedBox(width: 8), // مسافة صغيرة بين النص والسهم
                    Icon(
                      Icons.arrow_forward, // السهم داخل الزر
                      color: Colors.white, // لون السهم أبيض
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            if (result.isNotEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  result,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenHeight * 0.025,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
