import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'HackerScreen.dart';
import 'VictimScreen.dart';

class TrojanHorseGame extends StatefulWidget {
  @override
  _TrojanHorseGameState createState() => _TrojanHorseGameState();
}

class _TrojanHorseGameState extends State<TrojanHorseGame> {
  final ValueNotifier<String> virusTypeNotifier = ValueNotifier('');
  final ValueNotifier<bool> fakeGoogleIconNotifier = ValueNotifier(false);
  late AudioPlayer backgroundAudioPlayer;

  @override
  void initState() {
    super.initState();
    backgroundAudioPlayer = AudioPlayer();
    _initializeAndPlayBackgroundMusic();
  }

  @override
  void dispose() {
    backgroundAudioPlayer.stop();
    backgroundAudioPlayer.dispose();
    super.dispose();
  }

  Future<void> _initializeAndPlayBackgroundMusic() async {
    try {
      await backgroundAudioPlayer.setReleaseMode(ReleaseMode.loop);
      await backgroundAudioPlayer.play(AssetSource('Evil_laugh.mp3'));
    } catch (error) {
      print("Error playing background music: $error");
    }
  }

  void _onVirusSend(String selectedVirusType) {
    virusTypeNotifier.value = selectedVirusType;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final spacing = screenSize.width * 0.02;

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: HackerScreen(
              onVirusSend: (virusType) => _onVirusSend(virusType),
            ),
          ),
          SizedBox(width: spacing),
          Expanded(
            flex: 1,
            child: VictimScreen(
              virusTypeNotifier: virusTypeNotifier,
              showFakeGoogleIconNotifier: fakeGoogleIconNotifier,
            ),
          ),
        ],
      ),
    );
  }
}
