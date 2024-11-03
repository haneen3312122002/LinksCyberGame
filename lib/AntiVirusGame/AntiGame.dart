import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

// شاشة اللعبة: التحكم الرئيسي في واجهة المستخدم ومنطق اللعبة
class AntiGameScreen extends StatefulWidget {
  @override
  _AntiGameScreenState createState() => _AntiGameScreenState();
}

// حالة شاشة اللعبة
class _AntiGameScreenState extends State<AntiGameScreen> {
  int timeLeft = 120; // مدة اللعبة بالثواني
  List<FileItem> fileList = [];
  AntivirusProgram antivirusProgram = AntivirusProgram();
  Timer? timer;
  int virusCount = 0;
  String message = '';
  bool gameEnded = false;

  // خيارات المسح
  String selectedScanOption = 'سريع'; // الافتراضي هو المسح السريع
  List<String> scanOptions = ['سريع', 'كامل', 'مخصص'];
  List<FileItem> customScanFiles = []; // للملفات المختارة في المسح المخصص

  // حالة إظهار نافذة برنامج المسح
  bool showAntivirusWindow = false;

  @override
  void initState() {
    super.initState();
    initializeGame();
    startTimer();
  }

  // تهيئة اللعبة بإنشاء ملفات مع إمكانية الإصابة
  void initializeGame() {
    fileList = [];
    virusCount = 0;
    Random random = Random();

    // قائمة بأنواع الفيروسات
    List<String> virusTypes = ['حصان طروادة', 'دودة', 'فيروس تجسس'];

    // إنشاء ملفات، بعضها مصاب بأنواع مختلفة من الفيروسات
    for (int i = 1; i <= 20; i++) {
      bool isVirus = random.nextBool();
      String? virusType;

      if (isVirus) {
        virusType = virusTypes[random.nextInt(virusTypes.length)];
        virusCount++;
      }

      FileItem file = FileItem(
        fileName: 'ملف_$i.txt',
        isInfected: isVirus,
        virusType: virusType,
      );

      fileList.add(file);
    }
  }

  // بدء مؤقت اللعبة
  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          t.cancel();
          gameEnded = true;
          showLoseDialog();
        }
      });
    });
  }

  // تنفيذ المسح بناءً على الخيار المحدد
  void performScan() {
    List<FileItem> filesToScan = [];

    if (selectedScanOption == 'سريع') {
      // مسح سريع: مسح أول 10 ملفات فقط
      filesToScan = fileList.take(10).toList();
      message = 'تم إجراء مسح سريع على الملفات الأساسية.';
    } else if (selectedScanOption == 'كامل') {
      // مسح كامل: مسح جميع الملفات
      filesToScan = fileList;
      message = 'تم إجراء مسح كامل على جميع الملفات.';
    } else if (selectedScanOption == 'مخصص') {
      // مسح مخصص: مسح الملفات المختارة
      if (customScanFiles.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('يرجى اختيار الملفات للمسح المخصص.')),
        );
        return;
      }
      filesToScan = customScanFiles;
      message = 'تم إجراء مسح مخصص على الملفات المختارة.';
    }

    // مسح الملفات
    antivirusProgram.scanFiles(filesToScan);

    // إغلاق نافذة برنامج مكافحة الفيروسات
    closeAntivirusWindow();

    // تحديث واجهة المستخدم
    setState(() {});
  }

  // محاولة اللاعب لحذف ملف مصاب بالفيروس
  void attemptDeleteVirus(FileItem file) {
    if (file.isInfected && file.scanned) {
      // بدء تحدي الوقت العكسي بناءً على نوع الفيروس
      startReverseTimeChallenge(file);
    } else if (file.scanned) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('هذا الملف سليم.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى إجراء المسح أولاً.')),
      );
    }
  }

  // بدء تحدي الوقت العكسي
  void startReverseTimeChallenge(FileItem file) {
    int challengeTime = 15; // الوقت الممنوح لحل التحدي
    Timer? challengeTimer;
    int timeRemaining = challengeTime;
    bool challengeCompleted = false;

    // اختيار سؤال بناءً على نوع الفيروس
    Question question =
        antivirusProgram.getQuestionByVirusType(file.virusType!);

    // بدء مؤقت التحدي
    challengeTimer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (timeRemaining > 0) {
          timeRemaining--;
        } else {
          t.cancel();
          if (!challengeCompleted) {
            Navigator.of(context).pop(); // إغلاق النافذة
            // فشل التحدي
            virusSpread();
          }
        }
      });
    });

    // عرض نافذة التحدي
    showDialog(
      context: context,
      barrierDismissible: false, // منع إغلاق النافذة
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('تحدي الوقت العكسي'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('الوقت المتبقي: $timeRemaining ثانية'),
                SizedBox(height: 10),
                Text(question.questionText),
                SizedBox(height: 10),
                ...question.options.map((option) {
                  return ListTile(
                    title: Text(option),
                    leading: Radio<String>(
                      value: option,
                      groupValue: question.selectedOption,
                      onChanged: (value) {
                        setState(() {
                          question.selectedOption = value;
                        });
                      },
                    ),
                  );
                }).toList(),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (question.selectedOption == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('يرجى اختيار إجابة.')),
                    );
                    return;
                  }
                  if (question.selectedOption == question.correctAnswer) {
                    // إجابة صحيحة
                    challengeCompleted = true;
                    challengeTimer?.cancel();
                    Navigator.of(context).pop(); // إغلاق النافذة
                    deleteVirus(file);
                  } else {
                    // إجابة خاطئة
                    challengeCompleted = true;
                    challengeTimer?.cancel();
                    Navigator.of(context).pop(); // إغلاق النافذة
                    virusSpread();
                  }
                },
                child: Text('إرسال'),
              ),
            ],
          );
        });
      },
    );
  }

  // معالجة انتشار الفيروس عند فشل التحدي
  void virusSpread() {
    setState(() {
      // انتشار الفيروس إلى ملف عشوائي آخر
      List<FileItem> uninfectedFiles =
          fileList.where((file) => !file.isInfected).toList();
      if (uninfectedFiles.isNotEmpty) {
        Random random = Random();
        FileItem newInfectedFile =
            uninfectedFiles[random.nextInt(uninfectedFiles.length)];
        newInfectedFile.isInfected = true;
        newInfectedFile.virusType = [
          'حصان طروادة',
          'دودة',
          'فيروس تجسس'
        ][random.nextInt(3)]; // نوع فيروس عشوائي
        virusCount++;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('انتشر الفيروس إلى ملف آخر!')),
        );
      } else {
        // لا توجد ملفات أخرى للإصابة، يخسر اللاعب
        timer?.cancel();
        gameEnded = true;
        showLoseDialog();
      }
    });
  }

  // إزالة الفيروس من الملف
  void deleteVirus(FileItem file) {
    setState(() {
      file.isInfected = false;
      file.virusType = null;
      virusCount--;
      if (virusCount == 0) {
        timer?.cancel();
        gameEnded = true;
        showWinDialog();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تمت إزالة الفيروس بنجاح.')),
      );
    });
  }

  // عرض نافذة عند فوز اللاعب
  void showWinDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('تهانينا!'),
          content: Text('لقد نجحت في إزالة جميع الفيروسات.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // إعادة تشغيل اللعبة إذا رغبت
              },
              child: Text('موافق'),
            )
          ],
        );
      },
    );
  }

  // عرض نافذة عند خسارة اللاعب
  void showLoseDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('انتهت اللعبة'),
          content: Text(
              'لم تقم بإزالة جميع الفيروسات في الوقت المحدد. حاول مرة أخرى.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // إعادة تشغيل اللعبة إذا رغبت
              },
              child: Text('موافق'),
            )
          ],
        );
      },
    );
  }

  // إغلاق نافذة برنامج مكافحة الفيروسات
  void closeAntivirusWindow() {
    setState(() {
      showAntivirusWindow = false;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // بناء واجهة المستخدم للعبة
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // لا نستخدم AppBar لنعطي شعور سطح المكتب
      body: Stack(
        children: [
          // خلفية سطح المكتب
          Container(
            color: Colors.blueGrey.shade700, // استخدم لون خلفية بدلاً من الصورة
          ),
          // عرض أيقونات الملفات على سطح المكتب
          Positioned.fill(
            child: Padding(
              padding:
                  EdgeInsets.fromLTRB(16.0, 60.0, 16.0, 16.0), // تعديل الحشوة
              child: GridView.builder(
                itemCount: fileList.length + 1, // +1 لبرنامج مكافحة الفيروسات
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // أيقونة برنامج مكافحة الفيروسات
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showAntivirusWindow = true;
                            });
                          },
                          child: Icon(
                            Icons.shield,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'مكافحة الفيروسات',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    );
                  } else {
                    FileItem file = fileList[index - 1];

                    // تحديد لون الأيقونة بناءً على حالة الملف
                    Color iconColor = Colors.white;
                    if (file.scanned && file.isInfected) {
                      iconColor = Colors.red; // الملفات المصابة
                    } else if (file.scanned && !file.isInfected) {
                      iconColor = Colors.green; // الملفات السليمة
                    }

                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            attemptDeleteVirus(file);
                          },
                          child: Icon(
                            Icons.insert_drive_file,
                            color: iconColor,
                            size: 40,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          file.fileName,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
          // إضافة المؤقت في الزاوية العلوية اليمنى
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.black54,
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: Colors.white,
                  ),
                  SizedBox(width: 5),
                  Text(
                    '$timeLeft ثانية',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          // عرض نافذة برنامج مكافحة الفيروسات إذا تم فتحها
          if (showAntivirusWindow)
            Positioned(
              left: 50,
              top: 50,
              right: 50,
              bottom: 50,
              child: Material(
                elevation: 5,
                color: Colors.white,
                child: Column(
                  children: [
                    // شريط العنوان مع زر الإغلاق
                    Container(
                      color: Colors.blueGrey,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Text(
                            'برنامج مكافحة الفيروسات',
                            style: TextStyle(color: Colors.white),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: closeAntivirusWindow,
                            child: Icon(Icons.close, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    // محتوى النافذة
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            // عرض الرسالة
                            if (message.isNotEmpty)
                              Text(
                                message,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.green),
                              ),
                            SizedBox(height: 10),
                            // اختيار نوع المسح
                            Row(
                              children: [
                                Text('اختر نوع المسح: '),
                                DropdownButton<String>(
                                  value: selectedScanOption,
                                  items: scanOptions.map((option) {
                                    return DropdownMenuItem<String>(
                                      value: option,
                                      child: Text(option),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedScanOption = value!;
                                      if (selectedScanOption != 'مخصص') {
                                        customScanFiles.clear();
                                      }
                                    });
                                  },
                                ),
                                Spacer(),
                                ElevatedButton(
                                  onPressed: performScan,
                                  child: Text('مسح'),
                                ),
                              ],
                            ),
                            // إذا كان المسح مخصصًا، عرض تعليمات واختيار الملفات
                            if (selectedScanOption == 'مخصص')
                              Expanded(
                                child: ListView.builder(
                                  itemCount: fileList.length,
                                  itemBuilder: (context, index) {
                                    FileItem file = fileList[index];
                                    bool isSelected =
                                        customScanFiles.contains(file);
                                    return ListTile(
                                      leading: Icon(
                                        Icons.insert_drive_file,
                                        color: Colors.blue,
                                      ),
                                      title: Text(file.fileName),
                                      onTap: () {
                                        setState(() {
                                          if (isSelected) {
                                            customScanFiles.remove(file);
                                          } else {
                                            customScanFiles.add(file);
                                          }
                                        });
                                      },
                                      selected: isSelected,
                                      selectedTileColor: Colors.grey.shade200,
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// فئة برنامج مكافحة الفيروسات: توفر المسح والأسئلة للتحدي
class AntivirusProgram {
  List<Question> trojanQuestions = [
    Question(
      questionText: 'ما هو حصان طروادة في عالم الكمبيوتر؟',
      options: [
        'برنامج مفيد',
        'فيروس يتنكر كبرنامج شرعي',
        'أداة لتحسين الأداء',
        'نوع من الأجهزة'
      ],
      correctAnswer: 'فيروس يتنكر كبرنامج شرعي',
    ),
    // أضف المزيد من الأسئلة حول حصان طروادة
  ];

  List<Question> wormQuestions = [
    Question(
      questionText: 'كيف تنتشر الدودة في الشبكات؟',
      options: [
        'من خلال نسخ نفسها عبر الشبكة',
        'عن طريق المستخدمين فقط',
        'لا تنتشر على الإطلاق',
        'من خلال الأجهزة الخارجية فقط'
      ],
      correctAnswer: 'من خلال نسخ نفسها عبر الشبكة',
    ),
    // أضف المزيد من الأسئلة حول الديدان
  ];

  List<Question> spywareQuestions = [
    Question(
      questionText: 'ما هو الهدف الرئيسي لفيروسات التجسس؟',
      options: [
        'تحسين أداء النظام',
        'جمع المعلومات الشخصية',
        'تدمير الملفات',
        'تحديث البرامج'
      ],
      correctAnswer: 'جمع المعلومات الشخصية',
    ),
    // أضف المزيد من الأسئلة حول برامج التجسس
  ];

  // إرجاع سؤال بناءً على نوع الفيروس
  Question getQuestionByVirusType(String virusType) {
    Random random = Random();
    if (virusType == 'حصان طروادة') {
      return trojanQuestions[random.nextInt(trojanQuestions.length)];
    } else if (virusType == 'دودة') {
      return wormQuestions[random.nextInt(wormQuestions.length)];
    } else if (virusType == 'فيروس تجسس') {
      return spywareQuestions[random.nextInt(spywareQuestions.length)];
    } else {
      // افتراضيًا، إذا لم يتم تحديد النوع
      return trojanQuestions[random.nextInt(trojanQuestions.length)];
    }
  }

  // مسح الملفات للبحث عن الفيروسات
  void scanFiles(List<FileItem> filesToScan) {
    // تحديث حالة الملفات لتكون "تم المسح"
    for (var file in filesToScan) {
      file.scanned = true;
    }
  }
}

// فئة السؤال: تمثل سؤالاً في الأمن السيبراني
class Question {
  String questionText;
  List<String> options;
  String correctAnswer;
  String? selectedOption;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    this.selectedOption,
  });
}

// فئة الملف: تمثل ملفاً
class FileItem {
  String fileName;
  bool isInfected;
  String? virusType; // نوع الفيروس
  bool scanned = false; // لمعرفة ما إذا تم مسح الملف أم لا

  FileItem({
    required this.fileName,
    this.isInfected = false,
    this.virusType,
  });
}
