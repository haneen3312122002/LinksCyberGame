import 'package:flutter/material.dart';

class GameBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/Clouds.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
//....................

class GameGround extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      bottom: 0, // الأرضية يجب أن تكون في أسفل الشاشة
      child: Image.asset(
        'assets/UnderGround1.png',
        width: MediaQuery.of(context)
            .size
            .width, // الأرضية تغطي عرض الشاشة بالكامل
        height: 200, // تكبير ارتفاع الأرضية لتتناسب مع الشخصية
        fit: BoxFit.fill, // ملء الأرضية بالكامل
      ),
    );
  }
}

//.....................

class FloatingPlatform extends StatelessWidget {
  final double platformX;
  final double platformY;

  const FloatingPlatform({
    Key? key,
    required this.platformX,
    required this.platformY,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: platformX,
      bottom: platformY, // تأكد أن قيمة platformY تضع المنصة أعلى من الأرض
      child: Container(
        width: 150, // تكبير عرض المنصة
        height: 40, // تكبير ارتفاع المنصة
        color: Colors.brown,
      ),
    );
  }
}

//......................

class Obstacle extends StatelessWidget {
  final double obstacleX;

  const Obstacle({Key? key, required this.obstacleX}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: obstacleX,
      bottom: 100, // Adjust based on ground level
      child: Container(
        width: 60, // تكبير عرض العائق
        height: 60, // تكبير ارتفاع العائق
        color: Colors.red,
      ),
    );
  }
}
