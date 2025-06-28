import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

// ============ الصفحة الثانية: ConversationPage ============
//  فيها منطق المحادثة والإبلاغ عن الرسائل
class ConversationPage extends StatefulWidget {
  final String username;
  final String avatar;
  final String initialMessage;

  const ConversationPage({
    Key? key,
    required this.username,
    required this.avatar,
    required this.initialMessage,
  }) : super(key: key);

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  // قائمة تمثل جميع رسائل المحادثة
  List<String> conversation = [];

  // للتحكم بنص الرسالة المُراد إرسالها
  TextEditingController _messageController = TextEditingController();

  // متغيّر لحفظ نقاط الطفل
  int _points = 0;

  @override
  void initState() {
    super.initState();
    // الرسالة الأولى (التي نريد عرضها كرسالة واردة)
    conversation.add(widget.initialMessage);
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // دالة لإرسال الرسالة (من الطفل) وإضافتها للمحادثة
  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        conversation.add(text);
      });
      _messageController.clear();
    }
  }

  // دالة لإظهار خيارات الإبلاغ
  // ... (بقية الكود قبل الدالة)

  // دالة لإظهار خيارات الإبلاغ
  void _showReportDialog(String messageText) async {
    final reportOptions = <String>[
      'الاحتيال الإلكتروني',
      'التنمر الإلكتروني',
      'التحرش أو التهديد',
      'انتحال الشخصية',
      'إزعاج',
    ];

    int correctIndex = -1;

    if (messageText.contains('إصلاح حسابك') ||
        messageText.contains('جائزة') ||
        messageText.contains('أرسل اسمك الكامل') ||
        messageText.contains('أرسل كلمة المرور') ||
        messageText.contains('تحديث بياناتك') ||
        messageText.contains('ربحت جائزة')) {
      correctIndex = 0;
    } else if (messageText.contains('غبي') ||
        messageText.contains('معاق') ||
        messageText.contains('سخيف') ||
        messageText.contains('تافه') ||
        messageText.contains('أحمق')) {
      correctIndex = 1;
    } else if (messageText.contains('سوف أؤذيك') ||
        messageText.contains('سوف أجدك') ||
        messageText.contains('تهديد') ||
        messageText.contains('تحرش')) {
      correctIndex = 2;
    } else if (messageText.contains('انتحال') ||
        messageText.contains('اسم مزيف') ||
        messageText.contains('هويتك') ||
        messageText.contains('أنت شخص مزيف')) {
      correctIndex = 3;
    } else if (messageText.contains('لماذا لا ترد؟') ||
        messageText.contains('رد علي فورًا') ||
        messageText.contains('أرسل لي ردك الآن') ||
        messageText.contains('لماذا تتجاهلني؟')) {
      correctIndex = 4;
    }

    // ************* هذا هو المتغير الذي يجب أن يكون هنا *************
    // _selectedOption يجب أن يتم تعريفه داخل الدالة _showReportDialog
    // حتى تتمكن StatefulBuilder من الوصول إليه وتحديثه.
    int _selectedOption = -1;

    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.scale,
      title: 'الإبلاغ عن الرسالة',
      body: StatefulBuilder(
        // <--- تأكد من وجود StatefulBuilder هنا!
        builder: (BuildContext context, StateSetter setStateInDialog) {
          return Column(
            children: [
              Text(
                'نص الرسالة:\n\n$messageText\n',
                style: const TextStyle(fontSize: 14),
              ),
              const Text(
                'اختر التصنيف القانوني المناسب للإبلاغ:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...List.generate(reportOptions.length, (index) {
                return RadioListTile<int>(
                  title: Text(reportOptions[index]),
                  value: index,
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    // ************* هذا هو setStateInDialog اللي بيغير الحالة في الدايالوج *************
                    setStateInDialog(() {
                      _selectedOption = value!;
                    });
                  },
                );
              }),
            ],
          );
        },
      ),
      btnCancel: TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('إلغاء'),
      ),
      btnOk: TextButton(
        onPressed: () {
          if (_selectedOption == -1) {
            _showDialogMessage(
              context,
              title: 'تنبيه',
              content: 'الرجاء اختيار نوع الإبلاغ أولاً.',
              dialogType: DialogType.warning,
            );
            return;
          }
          Navigator.of(context).pop();

          if (_selectedOption == correctIndex && correctIndex != -1) {
            setState(() {
              _points += 10;
            });
            _showDialogMessage(
              context,
              title: 'رائع!',
              content:
                  'أحسنت! لقد اخترت تصنيف الإبلاغ الصحيح وحصلت على 10 نقاط.\n\nنقاطك الحالية: $_points',
              dialogType: DialogType.success,
            );
          } else {
            _showDialogMessage(
              context,
              title: 'تحذير',
              content:
                  'يبدو أنك اخترت تصنيفًا غير مناسب.\nحاول التركيز أكثر على محتوى الرسالة.',
              dialogType: DialogType.error,
            );
          }
        },
        child: const Text('إبلاغ'),
      ),
    ).show();
  }

// ... (بقية الكود بعد الدالة)
  // نافذة رسالة سريعة
  void _showDialogMessage(
    BuildContext context, {
    required String title,
    required String content,
    required DialogType dialogType, // Pass the dialog type
  }) {
    AwesomeDialog(
      context: context,
      dialogType: dialogType, // Use success for correct and error for incorrect
      animType: AnimType.scale,
      title: title,
      desc: content,
      btnOkText: 'موافق',
      btnOkOnPress: () {},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar مع إظهار نقاط الطفل
      appBar: AppBar(
        title: Text(
          widget.username,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 500),
              child: Text(
                'نقاطي: $_points',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // عرض المحادثة
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: conversation.length,
              itemBuilder: (context, index) {
                final messageText = conversation[index];
                // نجعل الرسالة الأولى (index == 0) كأنها من الشخص الآخر
                final isSender = index != 0;

                return Align(
                  alignment:
                      isSender ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: isSender ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // نص الرسالة
                        Flexible(
                          child: Text(messageText),
                        ),
                        // زر الإبلاغ (يظهر فقط في رسالة "الشخص الآخر")
                        if (!isSender)
                          IconButton(
                            icon: const Icon(Icons.flag, color: Colors.red),
                            onPressed: () {
                              _showReportDialog(messageText);
                            },
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // منطقة إدخال الرسالة وإرسالها
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            color: Colors.grey[200],
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(widget.avatar),
                  radius: 20.0,
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'اكتب رسالتك...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============ الصفحة الرئيسية: MessagesPage ============
//  فيها قائمة الرسائل وعند الضغط على أي رسالة يتم الانتقال إلى ConversationPage
class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  // قائمة تمثل الرسائل
  // تم تعديلها لتشمل 5 رسائل (كما طلبت) من أنواع مختلفة:
  // 1) احتيال إلكتروني
  // 2) تحرش/تهديد
  // 3) تنمر وتهديد مبطن
  // 4) إزعاج
  // 5) انتحال شخصية
  List<Map<String, String>> messages = [
    // 1) احتيال إلكتروني
    {
      "avatar": "assets/st6.png",
      "username": "ScammerPro",
      "message":
          "مرحبًا! هناك مفاجأة كبرى بانتظارك. جائزة نقدية ضخمة قريبًا. أرسل رقم حسابك البنكي فورًا لتحصل عليها.",
    },
    // 2) تحرش / تهديد
    {
      "avatar": "assets/st4.png",
      "username": "HarasserGuy",
      "message":
          "دعنا نلتقي بالحديقة، لدي هدية سرية لك. ولا تحاول إخبار أهلك وإلا قد ألجأ للتحرش أو التهديد.",
    },
    // 3) تنمر وتهديد مبطن
    {
      "avatar": "assets/st5.png",
      "username": "BullyingThreat",
      "message":
          "يا غبي، لا تتباهى كثيرًا بما تفعل. أنت تافه بالفعل، وسأعرف قريبًا كيف أجعلك تندم.",
    },
    // 4) إزعاج
    {
      "avatar": "assets/st9.png",
      "username": "AnnoyingUser",
      "message":
          "أين اختفيت؟ لماذا لا ترد؟ أرسل لي ردك الآن أو فسأواصل مراسلتك بلا توقف!",
    },
    // 5) انتحال شخصية
    {
      "avatar": "assets/st1.png",
      "username": "leen",
      "message":
          "مرحبًا، أنا الشخص المسؤول عن حسابك. هل تعلم أنني أستخدم اسم مزيف؟ لا تقلق على هويتك.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 19.0,
          ),
        ),
        elevation: 2.0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop(); // أو تنفيذ أي منطق آخر
          },
          child: Icon(Icons.arrow_back,
              color: const Color.fromARGB(255, 140, 0, 255), size: 30.0),
        ),
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: 20.0),
            child: Icon(
              FontAwesomeIcons.video,
              color: const Color.fromARGB(255, 127, 95, 255),
              size: 22.0,
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          // حقل البحث
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: TextField(
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.6),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.6),
                ),
                hintText: "بحث",
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search, size: 23.0),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              'الرسائل',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
          ),
          const SizedBox(height: 23.0),

          // عرض الرسائل
          ...List.generate(messages.length, (index) {
            final msg = messages[index];
            return ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: CircleAvatar(
                backgroundImage: AssetImage(msg["avatar"]!),
                radius: 30.0,
              ),
              title: Text(
                msg["username"]!,
                style: const TextStyle(
                    fontSize: 15.0, fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                msg["message"]!,
                style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // الانتقال لصفحة المحادثة ConversationPage
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConversationPage(
                      username: msg["username"]!,
                      avatar: msg["avatar"]!,
                      initialMessage: msg["message"]!,
                    ),
                  ),
                );
              },
              // زر حذف الرسالة
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    messages.removeAt(index);
                  });
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
