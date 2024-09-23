import 'package:audioplayers/audioplayers.dart';

//for stop audio:
class AudioPlayerManager {
  static final AudioPlayer _audioPlayer = AudioPlayer();

  // Method to play the Stop.mp3 sound
  static Future<void> playStopSound() async {
    await _audioPlayer.play(AssetSource('Stop.mp3'));
  }

  // Optionally, you can add methods to stop or pause the sound
  static Future<void> stopSound() async {
    await _audioPlayer.stop();
  }

  static Future<void> pauseSound() async {
    await _audioPlayer.pause();
  }

  static Future<void> resumeSound() async {
    await _audioPlayer.resume();
  }
}

//for walking audio:
class AudioPlayerManagerWalking {
  static final AudioPlayer _audioPlayer = AudioPlayer();

  // Method to play the Stop.mp3 sound
  static Future<void> playWalkingSound() async {
    await _audioPlayer.play(AssetSource('Stop.mp3'));
  }

  // Optionally, you can add methods to stop or pause the sound
  static Future<void> stopSound() async {
    await _audioPlayer.stop();
  }

  static Future<void> pauseSound() async {
    await _audioPlayer.pause();
  }

  static Future<void> resumeSound() async {
    await _audioPlayer.resume();
  }
}
