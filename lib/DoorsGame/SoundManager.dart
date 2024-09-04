import 'package:just_audio/just_audio.dart'; // مكتبة لتشغيل الصوت

class SoundManager {
  final AudioPlayer _player = AudioPlayer(); // مشغل الصوت

  // دالة لتشغيل صوت الخطأ
  Future<void> playErrorSound() async {
    try {
      // تعيين مسار ملف الصوت
      await _player.setAsset('assets/error.mp3');
      _player.play();
    } catch (e) {
      print('Error playing sound: $e'); // طباعة أي خطأ يظهر أثناء التشغيل
    }
  }

  // دالة لإيقاف الصوت عند الانتهاء من الاستخدام
  void dispose() {
    _player.dispose();
  }
}
