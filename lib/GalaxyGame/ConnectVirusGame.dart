// lib/main.dart

import 'package:flutter/material.dart';
import 'dart:ui' as ui; // لاستخدام الرسم منخفض المستوى
import 'GalaxyGameScreen.dart';

/// ويدجت الجذر للتطبيق
class ConnectDotsGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'لعبة توصيل النقاط',
      home: GameScreen(),
    );
  }
}

/// تمثل نقطة واحدة على الشبكة
class Dot {
  final int x;
  final int y;
  final String? imagePath;
  final String? label;
  final Color color;

  Dot({
    required this.x,
    required this.y,
    this.imagePath,
    this.label,
    required this.color,
  });
}

/// تمثل مسارًا مرسومًا بواسطة اللاعب
class PathModel {
  final Color color;
  final List<Offset> gridPositions;

  PathModel({required this.color, required this.gridPositions});
}

/// تمثل مستوى اللعبة بحجم الشبكة والنقاط الخاصة به
class GameLevel {
  final int gridWidth;
  final int gridHeight;
  final List<Dot> dots;

  GameLevel({
    required this.gridWidth,
    required this.gridHeight,
    required this.dots,
  });
}

/// قائمة بالمستويات المعرفة مسبقًا مع ترتيب النقاط
// باقي الكود كما هو...

/// قائمة بالمستويات المعرفة مسبقًا مع ترتيب النقاط
/// قائمة بالمستويات المعرفة مسبقًا مع ترتيب النقاط
final List<GameLevel> levels = [
  // المستوى الأول
  GameLevel(
    gridWidth: 5,
    gridHeight: 5,
    dots: [
      // النقاط الوردية
      Dot(x: 0, y: 0, imagePath: 'assets/TrojanH.png', color: Colors.pink),
      Dot(x: 2, y: 2, label: 'Trojan', color: Colors.pink),

      // النقاط البرتقالية
      Dot(x: 3, y: 4, imagePath: 'assets/Worm.png', color: Colors.orange),
      Dot(x: 1, y: 2, label: 'Worm', color: Colors.orange),

      // النقاط الصفراء
      Dot(x: 0, y: 4, imagePath: 'assets/RansomV.png', color: Colors.yellow),
      Dot(x: 3, y: 1, label: 'Ransomware', color: Colors.yellow),

      // النقاط الزرقاء
      Dot(x: 2, y: 3, imagePath: 'assets/Botnet.png', color: Colors.blue),
      Dot(x: 4, y: 4, label: 'Botnet', color: Colors.blue),
    ],
  ),

  // المستوى الثاني
  GameLevel(
    gridWidth: 6,
    gridHeight: 6,
    dots: [
      // النقاط الصفراء
      Dot(x: 0, y: 3, imagePath: 'assets/Spyware.png', color: Colors.yellow),
      Dot(x: 3, y: 5, label: 'Spyware', color: Colors.yellow),

      // النقاط الحمراء
      Dot(x: 0, y: 4, imagePath: 'assets/DownloaderV.png', color: Colors.red),
      Dot(x: 4, y: 3, label: 'Downloader', color: Colors.red),

      // النقاط الزرقاء
      Dot(x: 3, y: 2, imagePath: 'assets/TimeBumb.png', color: Colors.blue),
      Dot(x: 4, y: 4, label: 'Time Bomb', color: Colors.blue),

      // النقاط البرتقالية
      Dot(x: 0, y: 5, imagePath: 'assets/InfectionV.png', color: Colors.orange),
      Dot(x: 2, y: 2, label: 'Infection', color: Colors.orange),
    ],
  ),
];

// باقي الكود كما هو...

/// شاشة اللعبة الرئيسية حيث يتم اللعب
class GameScreen extends StatefulWidget {
  final int levelIndex;

  GameScreen({this.levelIndex = 0});

  @override
  _GameScreenState createState() => _GameScreenState();
}

/// كلاس الحالة لـ GameScreen
class _GameScreenState extends State<GameScreen> {
  late GameLevel _currentLevel;
  List<PathModel> _completedPaths = [];
  Color? _activeColor;
  List<Offset> _currentPathGridPositions = [];
  int _moveCount = 0;

  @override
  void initState() {
    super.initState();
    _currentLevel = levels[widget.levelIndex];
  }

  /// تبني واجهة المستخدم لشاشة اللعبة
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 14, 81, 136),
      // خلفية داكنة للتباين
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // الأزرار الجانبية
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton.icon(
                  onPressed: _restartLevel,
                  icon: Icon(Icons.refresh),
                  label: Text('إعادة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    // وظيفة المساعدة (غير مفعلة حالياً)
                  },
                  icon: Icon(Icons.lightbulb),
                  label: Text('مساعدة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (widget.levelIndex == 1) const SizedBox(height: 10),
                if (widget.levelIndex == 1 || widget.levelIndex == 0)
                  ElevatedButton.icon(
                    onPressed: () {
                      // الانتقال مباشرة إلى لعبة الفضاء
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => GalaxyAttackGame(),
                        ),
                      );
                    },
                    icon: Icon(Icons.skip_next),
                    label: Text('تخطي'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.greenAccent, // لون مميز لزر التخطي
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                    ),
                  ),
                // -- نهاية الإضافة --
              ],
            ),
            const SizedBox(width: 10),
            // شبكة اللعبة
            Expanded(
              child: Center(
                child: _buildGrid(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// تبني شبكة اللعبة مع النقاط
  Widget _buildGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int gridWidth = _currentLevel.gridWidth;
        int gridHeight = _currentLevel.gridHeight;

        // حساب حجم الخلية بناءً على العرض والارتفاع
        double cellWidth = constraints.maxWidth / gridWidth;
        double cellHeight = constraints.maxHeight / gridHeight;
        double cellSize = cellWidth < cellHeight ? cellWidth : cellHeight;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (details) => _onPanStart(details, cellSize),
          onPanUpdate: (details) => _onPanUpdate(details, cellSize),
          onPanEnd: _onPanEnd,
          onTapDown: (details) => _onTapDown(details, cellSize),
          child: Container(
            width: cellSize * gridWidth,
            height: cellSize * gridHeight,
            child: Stack(
              children: [
                GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridWidth,
                  ),
                  itemCount: gridWidth * gridHeight,
                  itemBuilder: (context, index) {
                    int x = index % gridWidth;
                    int y = index ~/ gridWidth;
                    Dot? dot = _getDotAtPosition(x, y);

                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Center(
                        child: dot != null
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: dot.color,
                                    radius: cellSize * 0.3, // تصغير الدائرة
                                  ),
                                  if (dot.imagePath != null)
                                    ClipOval(
                                      child: Image.asset(
                                        dot.imagePath!,
                                        fit: BoxFit.contain,
                                        width: cellSize * 0.5,
                                        height: cellSize * 0.5,
                                      ),
                                    ),
                                  if (dot.label != null)
                                    Container(
                                      width: cellSize * 0.8,
                                      padding: EdgeInsets.all(2.0),
                                      child: Text(
                                        dot.label!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: cellSize * 0.12,
                                        ),
                                      ),
                                    ),
                                ],
                              )
                            : null,
                      ),
                    );
                  },
                ),
                CustomPaint(
                  size: Size(cellSize * gridWidth, cellSize * gridHeight),
                  painter: PathPainter(
                    paths: _completedPaths,
                    currentPath: _currentPathGridPositions,
                    currentColor: _activeColor,
                    gridWidth: gridWidth,
                    gridHeight: gridHeight,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// استرجاع النقطة في موقع شبكة معين
  Dot? _getDotAtPosition(int x, int y) {
    for (var dot in _currentLevel.dots) {
      if (dot.x == x && dot.y == y) {
        return dot;
      }
    }
    return null;
  }

  /// معالجة بداية حدث اللمس
  void _onPanStart(DragStartDetails details, double cellSize) {
    Offset localPosition = details.localPosition;
    Offset gridPosition = _getGridPosition(localPosition, cellSize);

    Color? dotColor = _getColorAtGridPosition(gridPosition);
    if (dotColor != null) {
      setState(() {
        _activeColor = dotColor;
        _currentPathGridPositions = [gridPosition];
      });
    }
  }

  /// معالجة تحديث اللمس أثناء السحب
  void _onPanUpdate(DragUpdateDetails details, double cellSize) {
    if (_activeColor == null) return;

    Offset localPosition = details.localPosition;
    Offset gridPosition = _getGridPosition(localPosition, cellSize);

    if (_isValidMove(gridPosition)) {
      setState(() {
        // منع إضافة مواقع مكررة
        if (!_currentPathGridPositions.contains(gridPosition)) {
          _currentPathGridPositions.add(gridPosition);
        }

        // التحقق إذا كان الموقع الحالي هو النقطة الأخرى من نفس اللون
        if (_isConnectingCorrectDots(
            _currentPathGridPositions.first, gridPosition)) {
          // قبول المسار
          _completedPaths.removeWhere((path) => path.color == _activeColor);
          _completedPaths.add(
            PathModel(
              color: _activeColor!,
              gridPositions: List.from(_currentPathGridPositions),
            ),
          );
          _currentPathGridPositions = [];
          _activeColor = null;
          _moveCount++; // زيادة عدد التحركات
          _checkGameCompletion();
        }
      });
    }
  }

  /// معالجة نهاية حدث اللمس
  void _onPanEnd(DragEndDetails details) {
    if (_activeColor == null) return;

    // إذا لم يكتمل المسار، إعادة تعيينه
    setState(() {
      _currentPathGridPositions = [];
      _activeColor = null;
    });
  }

  /// معالجة النقر على الشبكة
  void _onTapDown(TapDownDetails details, double cellSize) {
    Offset localPosition = details.localPosition;
    Offset gridPosition = _getGridPosition(localPosition, cellSize);

    // البحث عن المسار الذي يحتوي على موقع الشبكة هذا
    PathModel? pathToRemove;
    for (var path in _completedPaths) {
      for (var pos in path.gridPositions) {
        if (pos.dx == gridPosition.dx && pos.dy == gridPosition.dy) {
          pathToRemove = path;
          break;
        }
      }
      if (pathToRemove != null) break;
    }

    if (pathToRemove != null) {
      setState(() {
        _completedPaths.remove(pathToRemove);
      });
    }
  }

  /// تحويل موقع اللمس إلى موقع الشبكة
  Offset _getGridPosition(Offset localPosition, double cellSize) {
    int x = (localPosition.dx / cellSize).floor();
    int y = (localPosition.dy / cellSize).floor();

    return Offset(x.toDouble(), y.toDouble());
  }

  /// استرجاع لون النقطة في موقع شبكة معين
  Color? _getColorAtGridPosition(Offset gridPosition) {
    int x = gridPosition.dx.toInt();
    int y = gridPosition.dy.toInt();

    Dot? dot = _getDotAtPosition(x, y);
    return dot?.color;
  }

  /// التحقق إذا كان المسار يربط بين نقطتين من نفس اللون
  bool _isConnectingCorrectDots(Offset startPos, Offset endPos) {
    int startX = startPos.dx.toInt();
    int startY = startPos.dy.toInt();
    int endX = endPos.dx.toInt();
    int endY = endPos.dy.toInt();

    Dot? startDot = _getDotAtPosition(startX, startY);
    Dot? endDot = _getDotAtPosition(endX, endY);

    // التأكد من أن كلا الطرفين هما نقطتان من نفس اللون وليستا نفس النقطة
    if (startDot != null &&
        endDot != null &&
        startDot.color == endDot.color &&
        (startDot.x != endDot.x || startDot.y != endDot.y)) {
      return true;
    }
    return false;
  }

  /// تحديد ما إذا كانت الحركة صالحة
  bool _isValidMove(Offset gridPosition) {
    int x = gridPosition.dx.toInt();
    int y = gridPosition.dy.toInt();

    // التحقق من حدود الشبكة
    if (x < 0 ||
        y < 0 ||
        x >= _currentLevel.gridWidth ||
        y >= _currentLevel.gridHeight) {
      return false;
    }

    // التحقق من التجاور
    if (_currentPathGridPositions.isNotEmpty) {
      Offset lastPosition = _currentPathGridPositions.last;
      int dx = (gridPosition.dx - lastPosition.dx).abs().toInt();
      int dy = (gridPosition.dy - lastPosition.dy).abs().toInt();

      if (!((dx == 1 && dy == 0) || (dx == 0 && dy == 1))) {
        // ليس مجاورًا
        return false;
      }
    }

    // التحقق إذا كان يتحرك إلى النقطة الأخرى من نفس اللون
    Color? dotColorAtPosition = _getColorAtGridPosition(gridPosition);
    Offset startGridPosition = _currentPathGridPositions.first;
    if (dotColorAtPosition == _activeColor &&
        gridPosition != startGridPosition) {
      // إنها النقطة الأخرى من نفس اللون، السماح بالحركة
      return true;
    }

    // منع التداخل مع المسارات الأخرى
    for (var path in _completedPaths) {
      if (path.gridPositions.contains(gridPosition) &&
          path.color != _activeColor) {
        return false;
      }
    }

    return true;
  }

  /// التحقق مما إذا كان مستوى اللعبة قد اكتمل
  void _checkGameCompletion() {
    // التحقق من تغطية جميع الخلايا
    int totalCells = _currentLevel.gridWidth * _currentLevel.gridHeight;
    Set<Offset> coveredPositions = {};

    for (var path in _completedPaths) {
      coveredPositions.addAll(path.gridPositions);
    }

    // إذا تم تغطية جميع الخلايا وعدد الخلايا المغطاة يساوي إجمالي الخلايا
    if (coveredPositions.length == totalCells) {
      _showLevelCompleteDialog();
    }
  }

  /// عرض حوار عند اكتمال المستوى
  void _showLevelCompleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('لقد أكملت المستوى!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _goToNextLevel();
            },
            child: Text('المستوى التالي'),
          ),
        ],
      ),
    );
  }

  /// الانتقال إلى مستوى اللعبة التالي

  void _goToNextLevel() {
    if (widget.levelIndex + 1 < levels.length) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => GameScreen(levelIndex: widget.levelIndex + 1),
        ),
      );
    } else {
      // الانتقال إلى GalaxyAttackGame بعد المستوى الثاني
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => GalaxyAttackGame(),
        ),
      );
    }
  }

  /// عرض حوار عند اكتمال جميع المستويات
  void _showGameCompletedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تهانينا!'),
        content: Text('لقد أكملت جميع المستويات.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _restartLevel();
            },
            child: Text('إعادة البدء'),
          ),
        ],
      ),
    );
  }

  /// إعادة بدء المستوى الحالي
  void _restartLevel() {
    setState(() {
      _completedPaths.clear();
      _currentPathGridPositions.clear();
      _activeColor = null;
      _moveCount = 0; // إعادة تعيين عدد التحركات
    });
  }

  /// وظيفة اختيار المستوى (غير مفعلة حالياً)
  void _selectLevel() {
    // تنفيذ التنقل إلى شاشة اختيار المستوى
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('اختيار المستوى غير متاح حالياً')),
    );
  }
}

/// رسام مخصص لرسم المسارات على الشبكة
class PathPainter extends CustomPainter {
  final List<PathModel> paths;
  final List<Offset> currentPath;
  final Color? currentColor;
  final int gridWidth;
  final int gridHeight;

  PathPainter({
    required this.paths,
    required this.currentPath,
    required this.currentColor,
    required this.gridWidth,
    required this.gridHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double cellSize = size.width / gridWidth;
    double radius = cellSize * 0.3; // نصف قطر الدائرة

    Paint pathPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // رسم المسارات المكتملة
    for (var path in paths) {
      pathPaint
        ..color = path.color
        ..strokeWidth = cellSize * 0.2;

      Path drawPath = Path();
      for (int i = 0; i < path.gridPositions.length; i++) {
        Offset gridPos = path.gridPositions[i];
        Offset point = Offset(
          (gridPos.dx + 0.5) * cellSize,
          (gridPos.dy + 0.5) * cellSize,
        );

        if (i == 0) {
          // بدء الخط عند حافة الدائرة الأولى
          Offset nextPoint = Offset(
            (path.gridPositions[i + 1].dx + 0.5) * cellSize,
            (path.gridPositions[i + 1].dy + 0.5) * cellSize,
          );
          Offset direction = (nextPoint - point).normalize() * radius;
          drawPath.moveTo(
            point.dx + direction.dx,
            point.dy + direction.dy,
          );
        } else {
          // إنهاء الخط عند حافة الدائرة الأخيرة
          Offset previousPoint = Offset(
            (path.gridPositions[i - 1].dx + 0.5) * cellSize,
            (path.gridPositions[i - 1].dy + 0.5) * cellSize,
          );
          Offset direction = (point - previousPoint).normalize() * radius;
          drawPath.lineTo(
            point.dx - direction.dx,
            point.dy - direction.dy,
          );
        }
      }
      canvas.drawPath(drawPath, pathPaint);
    }

    // رسم المسار الحالي
    if (currentColor != null && currentPath.isNotEmpty) {
      pathPaint
        ..color = currentColor!
        ..strokeWidth = cellSize * 0.2;

      Path drawPath = Path();
      for (int i = 0; i < currentPath.length; i++) {
        Offset gridPos = currentPath[i];
        Offset point = Offset(
          (gridPos.dx + 0.5) * cellSize,
          (gridPos.dy + 0.5) * cellSize,
        );

        if (i == 0) {
          Offset nextPoint = Offset(
            (currentPath[i + 1].dx + 0.5) * cellSize,
            (currentPath[i + 1].dy + 0.5) * cellSize,
          );
          Offset direction = (nextPoint - point).normalize() * radius;
          drawPath.moveTo(
            point.dx + direction.dx,
            point.dy + direction.dy,
          );
        } else {
          Offset previousPoint = Offset(
            (currentPath[i - 1].dx + 0.5) * cellSize,
            (currentPath[i - 1].dy + 0.5) * cellSize,
          );
          Offset direction = (point - previousPoint).normalize() * radius;
          drawPath.lineTo(
            point.dx - direction.dx,
            point.dy - direction.dy,
          );
        }
      }
      canvas.drawPath(drawPath, pathPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

extension on Offset {
  Offset normalize() {
    double length = this.distance;
    if (length == 0) return Offset.zero;
    return Offset(this.dx / length, this.dy / length);
  }
}
