import 'package:flutter/material.dart';

class AdCryptoGame extends StatefulWidget {
  @override
  _AdCryptoGameState createState() => _AdCryptoGameState();
}

class _AdCryptoGameState extends State<AdCryptoGame>
    with TickerProviderStateMixin {
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  bool _isKeyVisible = false;
  bool _isKeyInSenderPhone = false; // للإشارة إلى وجود المفتاح في هاتف المرسل
  bool _isMessageSent = false; // للإشارة إلى أن الرسالة قد تم إرسالها
  bool _isDecrypting = false; // للإشارة إلى عملية فك التشفير

  String _encryptedMessage = ""; // الرسالة المشفرة للمستقبل
  String _decryptedMessage = ""; // الرسالة بعد فك التشفير للمستقبل
  String _originalMessage = ""; // الرسالة الأصلية من المرسل

  // التاريخ الصحيح للمفتاح
  final String correctDay = '12';
  final String correctMonth = '12';
  final String correctYear = '1983';

  // متحكمات الأنيميشن
  late AnimationController _keyAnimationController;
  late Animation<double> _keyAnimation;

  late AnimationController _messageAnimationController;
  late Animation<double> _messageAnimation;

  // مفاتيح GlobalKeys للحصول على مواقع العناصر
  final GlobalKey _keyIconKey = GlobalKey();
  final GlobalKey _senderPhoneKey = GlobalKey();
  final GlobalKey _receiverPhoneKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _keyAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _messageAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _keyAnimation = CurvedAnimation(
      parent: _keyAnimationController,
      curve: Curves.easeInOut,
    );

    _messageAnimation = CurvedAnimation(
      parent: _messageAnimationController,
      curve: Curves.easeInOut,
    );
  }

  // التحقق من صحة التاريخ المدخل
  void _checkAnswer() {
    if (_dayController.text == correctDay &&
        _monthController.text == correctMonth &&
        _yearController.text == correctYear) {
      _startKeyAnimation();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('التاريخ غير صحيح! حاول مرة أخرى.')),
      );
    }
  }

  // بدء أنيميشن المفتاح
  void _startKeyAnimation() {
    setState(() {
      _isKeyVisible = true;
    });

    _keyAnimationController.forward().then((_) {
      setState(() {
        _isKeyInSenderPhone = true;
      });
      _keyAnimationController.reset();
    });
  }

  // تشفير وإرسال الرسالة
  void _sendEncryptedMessage() {
    if (_isKeyInSenderPhone) {
      setState(() {
        _originalMessage = _messageController.text;
        _encryptedMessage = _encryptMessage(_messageController.text);
        _decryptedMessage = "";
        _messageController.clear();
        _isMessageSent = true;
      });

      _messageAnimationController.forward().then((_) {
        setState(() {
          // يمكنك إضافة أي إجراءات أخرى هنا إذا لزم الأمر
        });
        _messageAnimationController.reset();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يجب عليك إيجاد المفتاح أولاً!')),
      );
    }
  }

  // تشفير بسيط (تحويل كل حرف إلى الحرف التالي)
  String _encryptMessage(String message) {
    return message
        .split('')
        .map((char) => String.fromCharCode(char.codeUnitAt(0) + 1))
        .join();
  }

  // فك تشفير الرسالة مع إزالة المفتاح
  void _decryptMessage() {
    setState(() {
      _decryptedMessage = _encryptedMessage
          .split('')
          .map((char) => String.fromCharCode(char.codeUnitAt(0) - 1))
          .join();
      _encryptedMessage = "";
      _isKeyInSenderPhone = false; // إخفاء المفتاح بعد فك التشفير
      _isDecrypting = true;
    });

    // إعادة تعيين الحالة بعد فترة قصيرة لإخفاء الرسالة الأصلية
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isDecrypting = false;
      });
    });
  }

  @override
  void dispose() {
    _keyAnimationController.dispose();
    _messageAnimationController.dispose();
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent[100], // خلفية زاهية
      body: Stack(
        children: [
          Row(
            children: [
              // واجهة الدردشة داخل إطار الهاتف
              Expanded(
                child: Row(
                  children: [
                    // إطار الهاتف الأول (حنين)
                    _buildPhoneFrame(
                      key: _senderPhoneKey,
                      name: "حنين",
                      alignment: Alignment.bottomLeft,
                      message: _originalMessage.isNotEmpty
                          ? _originalMessage
                          : "المرسل",
                      isSender: true,
                      showKeyIcon: _isKeyInSenderPhone,
                      imagePath: 'assets/hanenChat.png',
                    ),
                    // إطار الهاتف الثاني (بتول)
                    _buildPhoneFrame(
                      key: _receiverPhoneKey,
                      name: "بتول",
                      alignment: Alignment.bottomLeft,
                      message: _isMessageSent
                          ? (_decryptedMessage.isNotEmpty
                              ? _decryptedMessage
                              : _encryptedMessage)
                          : "المستقبل",
                      showDecryptButton: _encryptedMessage.isNotEmpty,
                      onDecrypt: _decryptMessage,
                      imagePath: 'assets/batoolChat.png',
                    ),
                  ],
                ),
              ),
              // قسم إدخال المفتاح وزر التحقق
              Container(
                width: 150,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.yellow[100], // خلفية زاهية
                  borderRadius: BorderRadius.circular(20), // حواف مستديرة
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "اكتب معلومات المفتاح",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple, // لون نص مرح
                        fontFamily:
                            'ComicSans', // خط مرح (تأكد من إضافة الخط في pubspec.yaml)
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    _buildTextField(_dayController, 'اليوم'),
                    SizedBox(height: 10),
                    _buildTextField(_monthController, 'الشهر'),
                    SizedBox(height: 10),
                    _buildTextField(_yearController, 'السنة'),
                    SizedBox(height: 20),
                    GestureDetector(
                      key: _keyIconKey,
                      onTap: _checkAnswer,
                      child: Icon(
                        Icons.check,
                        size: 30,
                        color: Colors.green,
                      ),
                    ),
                    if (_isKeyVisible && !_isKeyInSenderPhone)
                      AnimatedOpacity(
                        opacity: _isKeyInSenderPhone ? 0.0 : 1.0,
                        duration: Duration(milliseconds: 500),
                        child: Icon(
                          Icons.vpn_key,
                          size: 40,
                          color: Colors.orange,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          // أنيميشن المفتاح والرسالة
          _buildAnimations(),
        ],
      ),
    );
  }

  Widget _buildAnimations() {
    return Stack(
      children: [
        // أنيميشن المفتاح
        if (_isKeyVisible && !_isKeyInSenderPhone)
          AnimatedBuilder(
            animation: _keyAnimationController,
            builder: (context, child) {
              final RenderBox keyIconBox =
                  _keyIconKey.currentContext!.findRenderObject() as RenderBox;
              final keyIconPosition = keyIconBox.localToGlobal(Offset.zero);

              final RenderBox senderPhoneBox = _senderPhoneKey.currentContext!
                  .findRenderObject() as RenderBox;
              final senderPhonePosition =
                  senderPhoneBox.localToGlobal(Offset.zero);

              return Positioned(
                left: Tween<double>(
                        begin:
                            keyIconPosition.dx + keyIconBox.size.width / 2 - 20,
                        end: senderPhonePosition.dx +
                            senderPhoneBox.size.width / 2 -
                            20)
                    .animate(_keyAnimation)
                    .value,
                top: Tween<double>(
                        begin: keyIconPosition.dy +
                            keyIconBox.size.height / 2 -
                            20,
                        end: senderPhonePosition.dy + 10)
                    .animate(_keyAnimation)
                    .value,
                child: Opacity(
                  opacity: 1.0 - _keyAnimationController.value,
                  child: Icon(
                    Icons.vpn_key,
                    size: 40,
                    color: Colors.orange,
                  ),
                ),
              );
            },
          ),
        // أنيميشن الرسالة مع المفتاح
        if (_isMessageSent)
          AnimatedBuilder(
            animation: _messageAnimationController,
            builder: (context, child) {
              final RenderBox senderPhoneBox = _senderPhoneKey.currentContext!
                  .findRenderObject() as RenderBox;
              final senderPhonePosition =
                  senderPhoneBox.localToGlobal(Offset.zero);

              final RenderBox receiverPhoneBox =
                  _receiverPhoneKey.currentContext!.findRenderObject()
                      as RenderBox;
              final receiverPhonePosition =
                  receiverPhoneBox.localToGlobal(Offset.zero);

              return Positioned(
                left: Tween<double>(
                        begin: senderPhonePosition.dx +
                            senderPhoneBox.size.width / 2 -
                            20,
                        end: receiverPhonePosition.dx +
                            receiverPhoneBox.size.width / 2 -
                            20)
                    .animate(_messageAnimation)
                    .value,
                top: Tween<double>(
                        begin: senderPhonePosition.dy + 80,
                        end: receiverPhonePosition.dy + 10)
                    .animate(_messageAnimation)
                    .value,
                child: Opacity(
                  opacity: 1.0 - _messageAnimationController.value,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.vpn_key,
                        color: Colors.orange,
                        size: 20,
                      ),
                      SizedBox(width: 5),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.lightGreenAccent.withOpacity(0.8),
                          borderRadius:
                              BorderRadius.circular(20), // حواف مستديرة
                        ),
                        child: Text(
                          _encryptedMessage,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily:
                                'ComicSans', // خط مرح (تأكد من إضافة الخط في pubspec.yaml)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildPhoneFrame({
    required Key key,
    required String name,
    required Alignment alignment,
    required String message,
    String? imagePath,
    bool showKeyIcon = false,
    bool showDecryptButton = false,
    VoidCallback? onDecrypt,
    bool isSender = false,
  }) {
    return Expanded(
      child: Container(
        key: key,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), // حواف مستديرة لإطار الهاتف
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge, // قص المحتوى الزائد
        child: Stack(
          children: [
            // خلفية الهاتف
            if (imagePath != null)
              Positioned.fill(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.fill,
                ),
              ),
            // محتوى الهاتف (المحادثة)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // شريط العنوان (اسم المستخدم) على حافة إطار الهاتف
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent, // لون مرح
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.yellow,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          SizedBox(width: 10),
                          Text(
                            name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily:
                                  'ComicSans', // خط مرح (تأكد من إضافة الخط في pubspec.yaml)
                            ),
                          ),
                          if (showKeyIcon)
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Icon(
                                Icons.vpn_key,
                                color: Colors.orange,
                                size: 24,
                              ),
                            ),
                        ],
                      ),
                      // ظهور أيقونة المفتاح animating
                      if (showKeyIcon && isSender)
                        Positioned(
                          right: 10,
                          top: 0,
                          child: AnimatedOpacity(
                            opacity: _isKeyInSenderPhone ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 500),
                            child: Icon(
                              Icons.vpn_key,
                              color: Colors.orange,
                              size: 24,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // منطقة الرسائل
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: Align(
                      alignment: alignment,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (message.isNotEmpty)
                              Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                      Colors.lightGreenAccent.withOpacity(0.8),
                                  borderRadius:
                                      BorderRadius.circular(20), // حواف مستديرة
                                ),
                                child: Text(
                                  message,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily:
                                        'ComicSans', // خط مرح (تأكد من إضافة الخط في pubspec.yaml)
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (isSender)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: "اكتب رسالة",
                              hintStyle: TextStyle(
                                color: Colors.purple,
                                fontFamily:
                                    'ComicSans', // خط مرح (تأكد من إضافة الخط في pubspec.yaml)
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send, color: Colors.orange),
                          onPressed: _sendEncryptedMessage,
                        ),
                      ],
                    ),
                  ),
                if (showDecryptButton && onDecrypt != null && !isSender)
                  Center(
                    child: IconButton(
                      icon: Icon(Icons.lock_open, color: Colors.red, size: 30),
                      onPressed: onDecrypt,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Container(
      width: 60,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15), // حواف مستديرة
          ),
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.purple, // لون نص مرح
            fontFamily:
                'ComicSans', // خط مرح (تأكد من إضافة الخط في pubspec.yaml)
          ),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
