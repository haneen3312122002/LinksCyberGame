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
  static final AudioPlayer _audioPlayerWalking = AudioPlayer();
  static final AudioPlayer _audioPlayerStop = AudioPlayer();

  // Method to play the walking sound
  static Future<void> playWalkingSound() async {
    await _audioPlayerWalking.setSource(AssetSource('walking_sound.mp3'));
    await _audioPlayerWalking.setReleaseMode(ReleaseMode.loop);
    await _audioPlayerWalking.resume();
  }

  // Method to stop the walking sound
  static Future<void> stopWalkingSound() async {
    await _audioPlayerWalking.stop();
  }

  // Method to play the Stop.mp3 sound
  static Future<void> playStopSound() async {
    await _audioPlayerStop.play(AssetSource('Stop.mp3'));
  }

  // Methods to control the Stop sound playback
  static Future<void> stopStopSound() async {
    await _audioPlayerStop.stop();
  }

  static Future<void> pauseStopSound() async {
    await _audioPlayerStop.pause();
  }

  static Future<void> resumeStopSound() async {
    await _audioPlayerStop.resume();
  }
}
//music class

class AudioPlayerManagerHttpMusic {
  static final AudioPlayer _audioPlayerHttpMusic = AudioPlayer();

  // Method to play HttpMusic.mp3
  static Future<void> playHttpMusic() async {
    await _audioPlayerHttpMusic.setSource(AssetSource('HttpMusic.mp3'));
    await _audioPlayerHttpMusic.setReleaseMode(ReleaseMode.loop);
    await _audioPlayerHttpMusic.resume();
  }

  // Method to stop HttpMusic.mp3
  static Future<void> stopHttpMusic() async {
    await _audioPlayerHttpMusic.stop();
  }
}
