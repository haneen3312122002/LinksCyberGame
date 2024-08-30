import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'LinkTest.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late List<String> allLinks;
  late List<String> secureLinks;
  late List<String> insecureLinks;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _resetGame();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _resetGame() {
    setState(() {
      allLinks = [
        'http://example.com',
        'https://secure.com',
        'http://unsafe.com',
        'https://safe.com',
      ];
      secureLinks = [];
      insecureLinks = [];
    });
  }

  void _checkResult() {
    if (secureLinks.isEmpty && insecureLinks.isEmpty) {
      _showCustomDialog(context, false, "الرجاء تعبئة السلات أولاً.");
      return;
    }

    bool success = secureLinks.every((link) => link.startsWith('https')) &&
        insecureLinks.every(
            (link) => link.startsWith('http') && !link.startsWith('https'));

    if (success) {
      _showCustomDialog(context, true, "لقد صنفت الروابط بشكل صحيح!");
    } else {
      _showCustomDialog(context, false, "هناك خطأ في التصنيف.");
    }
  }

  void _showCustomDialog(BuildContext context, bool isSuccess, String message) {
    AwesomeDialog(
      context: context,
      dialogType: isSuccess ? DialogType.success : DialogType.error,
      animType: AnimType.scale,
      title: isSuccess ? 'نجاح!' : 'فشل!',
      desc: message,
      btnOkOnPress: () {
        _resetGame();
      },
      btnOkText: isSuccess ? 'اعادة اللعبة' : 'إعادة اللعبة',
      btnOkColor: isSuccess ? Color.fromARGB(255, 0, 119, 255) : Colors.red,
      btnCancelOnPress: isSuccess
          ? () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LinkCheckerScreen()),
              );
            }
          : null,
      btnCancelText: isSuccess ? 'التحدي التالي' : null,
      btnCancelColor: Color.fromARGB(255, 3, 255, 28),
      headerAnimationLoop: false,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
    ).show();
  }

  void _returnLink(String link) {
    setState(() {
      allLinks.add(link);
      secureLinks.remove(link);
      insecureLinks.remove(link);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/back.png', // تأكد من أن الصورة موجودة في المسار الصحيح
              fit: BoxFit.cover, // لتغطية كامل الشاشة بالصورة
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              double linkHeight = constraints.maxHeight * 0.1;
              double trashBinSize = constraints.maxWidth * 0.25;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: allLinks
                        .map((link) =>
                            LinkWidget(link: link, height: linkHeight))
                        .toList(),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TrashBinWidget(
                        imageAsset:
                            'assets/blueBasket.png', // صورة السلة الزرقاء
                        isSecure: true,
                        links: secureLinks,
                        onLinkAccepted: (link) {
                          setState(() {
                            secureLinks.add(link);
                            allLinks.remove(link);
                          });
                        },
                        onLinkRemoved: _returnLink,
                        size: trashBinSize,
                      ),
                      TrashBinWidget(
                        imageAsset:
                            'assets/redBasket.png', // صورة السلة الحمراء
                        isSecure: false,
                        links: insecureLinks,
                        onLinkAccepted: (link) {
                          setState(() {
                            insecureLinks.add(link);
                            allLinks.remove(link);
                          });
                        },
                        onLinkRemoved: _returnLink,
                        size: trashBinSize,
                      ),
                    ],
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: GestureDetector(
                      onTapDown: (_) => _animationController.forward(),
                      onTapUp: (_) => _animationController.reverse(),
                      onTapCancel: () => _animationController.reverse(),
                      child: ElevatedButton(
                        onPressed: _checkResult,
                        child: Text(
                          'تحقق من النتائج',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 243, 176, 255), // لون الزر بنفسجي
                          padding: EdgeInsets.symmetric(
                            horizontal: constraints.maxWidth * 0.1,
                            vertical: constraints.maxHeight * 0.02,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class LinkWidget extends StatefulWidget {
  final String link;
  final double height;

  LinkWidget({required this.link, required this.height});

  @override
  _LinkWidgetState createState() => _LinkWidgetState();
}

class _LinkWidgetState extends State<LinkWidget> {
  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: widget.link,
      child: Container(
        height: widget.height,
        padding: EdgeInsets.all(10),
        color: Colors.yellow,
        child: Row(
          children: [
            Icon(Icons.link),
            SizedBox(width: 5),
            Text(
              widget.link,
              style: TextStyle(fontSize: widget.height * 0.25),
            ),
          ],
        ),
      ),
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          height: widget.height,
          padding: EdgeInsets.all(10),
          color: Colors.yellow.withOpacity(0.7),
          child: Row(
            children: [
              Icon(Icons.link),
              SizedBox(width: 5),
              Text(
                widget.link,
                style: TextStyle(fontSize: widget.height * 0.25),
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Container(
        height: widget.height,
        padding: EdgeInsets.all(10),
        color: Colors.yellow,
        child: Row(
          children: [
            Icon(Icons.link),
            SizedBox(width: 5),
            Text(
              widget.link,
              style: TextStyle(fontSize: widget.height * 0.25),
            ),
          ],
        ),
      ),
    );
  }
}

class TrashBinWidget extends StatefulWidget {
  final bool isSecure;
  final List<String> links;
  final Function(String) onLinkAccepted;
  final Function(String) onLinkRemoved;
  final double size;
  final String imageAsset;

  TrashBinWidget({
    required this.isSecure,
    required this.links,
    required this.onLinkAccepted,
    required this.onLinkRemoved,
    required this.size,
    required this.imageAsset,
  });

  @override
  _TrashBinWidgetState createState() => _TrashBinWidgetState();
}

class _TrashBinWidgetState extends State<TrashBinWidget> {
  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return GestureDetector(
          onTap: () => _showBinContents(context),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.imageAsset),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
      onWillAccept: (data) => true,
      onAccept: (data) {
        setState(() {
          widget.onLinkAccepted(data!);
        });
      },
    );
  }

  void _showBinContents(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(widget.isSecure
              ? 'محتويات السلة الآمنة'
              : 'محتويات السلة غير الآمنة'),
          content: Container(
            width: double.maxFinite,
            height: 300.0, // يمكن تخصيص الحجم حسب الحاجة
            child: ListView.builder(
              itemCount: widget.links.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.links[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        widget.onLinkRemoved(widget.links[index]);
                      });
                      Navigator.of(context).pop(); // إغلاق الصندوق المنبثق
                    },
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text('إغلاق'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
