import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'DoorsScreen2.dart';
import 'stage.dart'; // استدعاء Stage class
import 'SoundManager.dart'; // استدعاء SoundManager class

class DoorsScreen extends StatelessWidget {
  final int currentStep = 1; // المرحلة الحالية هي 1 من 10
  final Stage currentStage = Stage(
      stageName:
          "المرحلة 1"); // لا حاجة لذكر الخصائص هنا، سيتم توريث الخصائص الافتراضية
  final SoundManager soundManager =
      SoundManager(); // إنشاء instance من SoundManager

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            currentStage, // استخدام Stage widget لعرض اسم المرحلة مع الخصائص الافتراضية
        centerTitle: true, // توسيط العنوان
      ),
      body: Column(
        children: [
          SizedBox(height: 40), // مساحة قبل شريط التقدم
          // شريط التقدم مع زوايا دائرية
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0), // ضبط المسافات
            child: ClipRRect(
              borderRadius:
                  BorderRadius.all(Radius.circular(20)), // زوايا دائرية
              child: LinearProgressIndicator(
                value: currentStep / 10, // التقدم (1 من 10 خطوات)
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  currentStep == 1
                      ? Colors.blue // لون الخطوة الحالية
                      : Colors.yellow, // الخطوات المستقبلية تبقى صفراء
                ),
                minHeight: 20, // ضبط ارتفاع شريط التقدم
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                // الصورة الخلفية تغطي الشاشة بالكامل
                Positioned.fill(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Image.asset('assets/doors.png'),
                  ),
                ),
                // الأبواب التفاعلية مع النصوص
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildDoor(context, 'اختيار البروتوكول',
                          isCorrect: true), // الباب الصحيح
                      _buildDoor(context, 'اضافة بيانات الطلب',
                          isCorrect: false),
                      _buildDoor(context, 'ارسال الطلب', isCorrect: false),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoor(BuildContext context, String label,
      {required bool isCorrect}) {
    return GestureDetector(
      onTap: () {
        if (isCorrect) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VideoScreen()),
          );
        } else {
          soundManager
              .playErrorSound(); // تشغيل صوت الخطأ عند اختيار الإجابة الخاطئة
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$label تم الضغط عليه')),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 150), // رفع النص قليلاً
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 229, 130, 8)
                  .withOpacity(0.6), // خلفية شبه شفافة
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

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/door1.mp4')
      ..initialize().then((_) {
        // Start the video automatically
        _controller.play();
        setState(() {});
      })
      ..setLooping(false);

    // Navigate to the next screen when the video ends
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DoorsScreen2()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller.value.isInitialized
          ? SizedBox.expand(
              // لتغطية الشاشة بالكامل
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()), // عرض مؤشر التحميل
    );
  }
}
