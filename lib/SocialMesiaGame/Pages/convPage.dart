import 'package:flutter/material.dart';
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

    int _selectedOption = -1;

    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.scale,
      title: 'الإبلاغ عن الرسالة',
      body: Column(
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
                setState(() {
                  _selectedOption = value!;
                });
              },
            );
          }),
        ],
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
            );
          } else {
            _showDialogMessage(
              context,
              title: 'تحذير',
              content:
                  'يبدو أنك اخترت تصنيفًا غير مناسب.\nحاول التركيز أكثر على محتوى الرسالة.',
            );
          }
        },
        child: const Text('إبلاغ'),
      ),
    ).show();
  }

  // نافذة رسالة سريعة
  void _showDialogMessage(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
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
