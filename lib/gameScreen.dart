import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

//لعبة اختيار اللينك الامن
class _GameScreenState extends State<GameScreen> {
  late List<String> allLinks;
  late List<String> secureLinks;
  late List<String> insecureLinks;

  @override
  void initState() {
    super.initState();
    _resetGame();
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
      btnOkText: isSuccess ? 'المرحلة التالية' : 'إعادة اللعبة',
      btnOkColor: isSuccess ? Colors.green : Colors.red,
      headerAnimationLoop: false,
      dismissOnTouchOutside: false, // يمكن تغيير هذه القيمة حسب الحاجة
      dismissOnBackKeyPress: false, // يمكن تغيير هذه القيمة حسب الحاجة
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
        // حساب العرض والطول بناءً على حجم الشاشة
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
            ElevatedButton(
              onPressed: _checkResult,
              child: Text('تحقق من النتائج'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth * 0.1,
                    vertical: constraints.maxHeight * 0.02),
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
        color: Colors.yellow, // الحفاظ على اللون الأصفر
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
                    color: Colors.yellow, // هنا نضيف اللون الأصفر
                    child: GestureDetector(
                      onLongPress: () => onLinkRemoved(link),
                      child: Text(
                        link,
                        style: TextStyle(
                          color: Colors
                              .black, // تغيير اللون إلى الأسود ليكون واضحا على الخلفية الصفراء
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
      onWillAccept: (data) => true, // السماح بإدخال أي رابط
      onAccept: (data) {
        onLinkAccepted(data!);
      },
    );
  }
}
