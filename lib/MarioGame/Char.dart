import 'package:flutter/material.dart';

class GameCharacter extends StatefulWidget {
  final double characterX;
  final double characterY;
  final bool isMovingRight;

  const GameCharacter({
    Key? key,
    required this.characterX,
    required this.characterY,
    required this.isMovingRight,
  }) : super(key: key);

  @override
  _GameCharacterState createState() => _GameCharacterState();
}

class _GameCharacterState extends State<GameCharacter> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.characterX,
      bottom: widget.characterY, // استخدم characterY لتحديد الموقع الرأسي
      child: Image.asset(
        widget.isMovingRight ? 'assets/RightChar.gif' : 'assets/LeftChar.gif',
        width: 150, // تكبير حجم الشخصية
        height: 150,
        fit: BoxFit.contain,
      ),
    );
  }
}
