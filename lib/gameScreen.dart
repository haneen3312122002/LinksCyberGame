import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:guarded_button/guarded_button.dart';
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

  Future<void> _playSound(String sound) async {}

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
      _playSound('success');
      _showCustomDialog(context, true, "لقد صنفت الروابط بشكل صحيح!");
    } else {
      _playSound('error');
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
              Navigator.push(
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
    return LayoutBuilder(
      builder: (context, constraints) {
        double linkHeight = constraints.maxHeight * 0.1;
        double trashBinSize = constraints.maxWidth * 0.25;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  allLinks.map((link) => LinkWidget(link, linkHeight)).toList(),
            ),
            SizedBox(height: constraints.maxHeight * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TrashBinWidget(
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
                child: GuardedElevatedButton(
                  guard: Guard(), // Add your Guard logic if needed
                  onPressed: _checkResult,
                  onLongPress: () {}, // Optional long press action
                  child: Text(
                    'تحقق من النتائج',
                    style: TextStyle(color: Colors.white),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 243, 176,
                        255), // Change the button color to purple
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
    );
  }
}

class LinkWidget extends StatelessWidget {
  final String link;
  final double height;

  LinkWidget(this.link, this.height);

  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: link,
      child: Container(
        height: height,
        padding: EdgeInsets.all(10),
        color: Colors.yellow,
        child: Row(
          children: [
            Icon(Icons.link),
            SizedBox(width: 5),
            Text(
              link,
              style: TextStyle(fontSize: height * 0.25),
            ),
          ],
        ),
      ),
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          height: height,
          padding: EdgeInsets.all(10),
          color: Colors.yellow.withOpacity(0.7),
          child: Row(
            children: [
              Icon(Icons.link),
              SizedBox(width: 5),
              Text(
                link,
                style: TextStyle(fontSize: height * 0.25),
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Container(
        height: height,
        padding: EdgeInsets.all(10),
        color: Colors.yellow,
        child: Row(
          children: [
            Icon(Icons.link),
            SizedBox(width: 5),
            Text(
              link,
              style: TextStyle(fontSize: height * 0.25),
            ),
          ],
        ),
      ),
    );
  }
}

class TrashBinWidget extends StatelessWidget {
  final bool isSecure;
  final List<String> links;
  final Function(String) onLinkAccepted;
  final Function(String) onLinkRemoved;
  final double size;

  TrashBinWidget({
    required this.isSecure,
    required this.links,
    required this.onLinkAccepted,
    required this.onLinkRemoved,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: isSecure ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.delete,
                color: Colors.white,
                size: size * 0.5,
              ),
              ...links.map((link) => Container(
                    color: Colors.yellow,
                    child: GestureDetector(
                      onLongPress: () => onLinkRemoved(link),
                      child: Text(
                        link,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size * 0.1,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )),
            ],
          ),
        );
      },
      onWillAccept: (data) => true,
      onAccept: (data) {
        onLinkAccepted(data!);
      },
    );
  }
}
