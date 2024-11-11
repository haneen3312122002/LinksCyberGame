import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'dart:math';

void main() => runApp(GalaxyAttackGame());

class GalaxyAttackGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: GameScreen(),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late VideoPlayerController _videoController;
  int playerScore = 10; // النقاط المبدئية
  List<Target> targets = [];
  List<Bullet> bullets = [];
  Timer? targetSpawnTimer;
  Timer? gameLoopTimer;
  bool gameOver = false;
  final Random random = Random();
  double playerXPosition = 0; // موقع مركبة اللاعب أفقياً

  // قائمة الصور المختلفة للفيروسات
  final List<String> virusImages = [
    'assets/TrojanH.png',
    'assets/Worm.png',
    'assets/RansomV.png',
    'assets/Botnet.png',
    'assets/Spyware.png',
    'assets/DownloaderV.png',
    'assets/TimeBumb.png',
    'assets/InfectionV.png',
  ];

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    startGame();
  }

  void _initializeVideo() {
    _videoController = VideoPlayerController.asset('assets/GalaxyBack.mp4')
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
        _videoController.setLooping(true);
      });
  }

  void startGame() {
    gameOver = false;
    playerScore = 10; // تحديد النقاط المبدئية
    targets.clear();
    bullets.clear();

    // تشغيل مؤقت اللعبة لتحديث الكائنات بشكل مستمر
    gameLoopTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      updateGame();
    });

    // توليد الأعداء بشكل دوري
    targetSpawnTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      double posX = random.nextDouble() *
          (MediaQuery.of(context).size.width - 40); // موقع عشوائي أفقياً
      bool isVirus =
          random.nextDouble() < 0.3; // احتمال 30% للفيروسات و70% للملفات

      targets.add(Target(
        position: Offset(posX, 0),
        type: isVirus ? TargetType.virus : TargetType.safeFile,
        imagePath:
            isVirus ? virusImages[random.nextInt(virusImages.length)] : '',
        points: isVirus ? 10 : 0,
        penalty: isVirus ? 0 : 5,
        speed: 2.0 + (timer.tick % 5) / 5.0,
      ));
      setState(() {});
    });
  }

  @override
  void dispose() {
    gameLoopTimer?.cancel();
    targetSpawnTimer?.cancel();
    _videoController.dispose();
    super.dispose();
  }

  void updateGame() {
    if (gameOver) return;

    moveBullets();
    moveTargets();
    checkCollisions();
    checkGameOver();
  }

  void moveBullets() {
    setState(() {
      bullets.forEach((bullet) {
        bullet.position =
            Offset(bullet.position.dx, bullet.position.dy - bullet.speed);
      });
    });
    bullets.removeWhere((bullet) => bullet.position.dy < 0);
  }

  void moveTargets() {
    setState(() {
      targets.forEach((target) {
        target.position =
            Offset(target.position.dx, target.position.dy + target.speed);
      });
    });
    targets.removeWhere(
        (target) => target.position.dy > MediaQuery.of(context).size.height);
  }

  void checkCollisions() {
    List<Bullet> bulletsToRemove = [];
    List<Target> targetsToRemove = [];

    for (var bullet in bullets) {
      for (var target in targets) {
        if (checkCollision(bullet.getRect(), target.getRect())) {
          onBulletHit(target);
          bulletsToRemove.add(bullet);
          targetsToRemove.add(target);
          break;
        }
      }
    }

    bullets.removeWhere((bullet) => bulletsToRemove.contains(bullet));
    targets.removeWhere((target) => targetsToRemove.contains(target));
  }

  bool checkCollision(Rect bulletRect, Rect targetRect) {
    return bulletRect.overlaps(targetRect);
  }

  void onBulletHit(Target target) {
    setState(() {
      if (target.type == TargetType.virus) {
        playerScore += target.points;
      } else if (target.type == TargetType.safeFile) {
        playerScore -= target.penalty;
      }
    });
  }

  void checkGameOver() {
    if (playerScore <= 0 && !gameOver) {
      endGame();
    }
  }

  void endGame() {
    gameLoopTimer?.cancel();
    targetSpawnTimer?.cancel();
    gameOver = true;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Game Over'),
        content: Text('You lost all your points!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              startGame();
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  void shoot() {
    setState(() {
      bullets.add(Bullet(Offset(
          playerXPosition + 32.5, MediaQuery.of(context).size.height - 90)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // الخلفية الفيديو
        if (_videoController.value.isInitialized)
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController.value.size.width,
                height: _videoController.value.size.height,
                child: VideoPlayer(_videoController),
              ),
            ),
          ),
        // محتوى اللعبة
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              playerXPosition += details.delta.dx;
              playerXPosition = playerXPosition.clamp(
                  0.0, MediaQuery.of(context).size.width - 70);
            });
          },
          onTapDown: (_) => shoot(),
          child: Stack(
            children: [
              Positioned(
                bottom: 20,
                left: playerXPosition,
                child:
                    Image.asset('assets/SpaceCraft.png', width: 70, height: 70),
              ),
              ...targets.map((target) => Positioned(
                    top: target.position.dy,
                    left: target.position.dx,
                    child: target.type == TargetType.virus
                        ? Image.asset(target.imagePath, width: 40, height: 40)
                        : Icon(Icons.insert_drive_file,
                            color: const Color.fromARGB(255, 24, 161, 24),
                            size: 40),
                  )),
              ...bullets.map((bullet) => Positioned(
                    top: bullet.position.dy,
                    left: bullet.position.dx,
                    child: Container(
                      width: 5,
                      height: 25,
                      color: Colors.red,
                    ),
                  )),
              Positioned(
                top: 50,
                right: 20,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.speed, // أيقونة العداد
                      color: Colors.white,
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$playerScore',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Target {
  Offset position;
  TargetType type;
  String imagePath;
  int points;
  int penalty;
  double speed;

  Target({
    required this.position,
    required this.type,
    required this.imagePath,
    this.points = 10,
    this.penalty = 5,
    this.speed = 2.0,
  });

  Rect getRect() {
    return Rect.fromLTWH(position.dx, position.dy, 40, 40);
  }
}

class Bullet {
  Offset position;
  double speed;

  Bullet(this.position, {this.speed = 5.0});

  Rect getRect() {
    return Rect.fromLTWH(position.dx, position.dy, 5, 25);
  }
}

enum TargetType { virus, safeFile }
