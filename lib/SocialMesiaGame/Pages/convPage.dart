import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    // أمثلة على أنواع الإبلاغ
    final reportOptions = <String>[
      'الاحتيال الإلكتروني',
      'التنمر الإلكتروني',
      'التحرش أو التهديد',
      'انتحال الشخصية',
      'إزعاج', // تمّت إضافة خيار "إزعاج" هنا
    ];

    // منطق بسيط لتحديد الخيار الصحيح بناءً على نص الرسالة.
    int correctIndex = -1; // افتراض عدم وجود تطابق في البداية

    if (messageText.contains('إصلاح حسابك') ||
        messageText.contains('جائزة') ||
        messageText.contains('أرسل اسمك الكامل') ||
        messageText.contains('أرسل كلمة المرور') ||
        messageText.contains('تحديث بياناتك') ||
        messageText.contains('ربحت جائزة')) {
      // إذا كانت الرسالة ذات محتوى "احتيالي" أو "تصيد"
      correctIndex = 0; // الاحتيال الإلكتروني
    } else if (messageText.contains('غبي') ||
        messageText.contains('معاق') ||
        messageText.contains('سخيف') ||
        messageText.contains('تافه') ||
        messageText.contains('أحمق')) {
      // إذا كانت الرسالة فيها تنمر
      correctIndex = 1; // التنمر الإلكتروني
    } else if (messageText.contains('سوف أؤذيك') ||
        messageText.contains('سوف أجدك') ||
        messageText.contains('تهديد') ||
        messageText.contains('تحرش')) {
      // رسالة تتضمن تهديد أو تحرش
      correctIndex = 2; // التحرش أو التهديد
    } else if (messageText.contains('انتحال') ||
        messageText.contains('اسم مزيف') ||
        messageText.contains('هويتك') ||
        messageText.contains('أنت شخص مزيف')) {
      // إذا كانت الرسالة تتعلق بانتحال الشخصية
      correctIndex = 3; // انتحال الشخصية
    }
    // أضفنا الشرط الخاص بالإزعاج:
    else if (messageText.contains('لماذا لا ترد؟') ||
        messageText.contains('رد علي فورًا') ||
        messageText.contains('أرسل لي ردك الآن') ||
        messageText.contains('لماذا تتجاهلني؟')) {
      correctIndex = 4; // إزعاج
    }

    int _selectedOption = -1; // لحفظ خيار الطفل

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text(
            'الإبلاغ عن الرسالة',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, setStateDialog) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                    // عرض الخيارات كـ RadioListTile
                    ...List.generate(reportOptions.length, (index) {
                      return RadioListTile<int>(
                        title: Text(reportOptions[index]),
                        value: index,
                        groupValue: _selectedOption,
                        onChanged: (value) {
                          setStateDialog(() {
                            _selectedOption = value!;
                          });
                        },
                      );
                    }),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                if (_selectedOption == -1) {
                  _showDialogMessage(
                    context,
                    title: 'تنبيه',
                    content: 'الرجاء اختيار نوع الإبلاغ أولاً.',
                  );
                  return;
                }
                Navigator.of(ctx).pop(); // إغلاق الـ Dialog

                if (_selectedOption == correctIndex && correctIndex != -1) {
                  // اختيار صحيح
                  setState(() {
                    _points += 10; // كمثال: +10 نقاط
                  });
                  _showDialogMessage(
                    context,
                    title: 'رائع!',
                    content:
                        'أحسنت! لقد اخترت تصنيف الإبلاغ الصحيح وحصلت على 10 نقاط.\n\nنقاطك الحالية: $_points',
                  );
                } else {
                  // اختيار خاطئ
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
          ],
        );
      },
    );
  }

  // نافذة رسالة سريعة
  void _showDialogMessage(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('موافق'),
            ),
          ],
        );
      },
    );
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
