import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import "AntiVirusProgram.dart";
import 'Questions.dart';

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
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightBlueAccent, Colors.lightGreenAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                // للسماح بالتمرير إذا كان المحتوى كبيرًا
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'الوقت المتبقي: $timeRemaining ثانية',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Icon(
                      Icons.alarm,
                      size: 60,
                      color: Colors.yellowAccent,
                    ),
                    SizedBox(height: 10),
                    Text(
                      question.questionText,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    // تعديل الخيارات لاستبدال الصور بأيقونات Flutter
                    ...question.options.map((option) {
                      bool isSelected = question.selectedOption == option;
                      int optionIndex = question.options.indexOf(option);
                      IconData optionIcon;

                      // اختيار أيقونة من Flutter لكل خيار
                      switch (optionIndex % 4) {
                        case 0:
                          optionIcon = Icons.star;
                          break;
                        case 1:
                          optionIcon = Icons.favorite;
                          break;
                        case 2:
                          optionIcon = Icons.lightbulb;
                          break;
                        default:
                          optionIcon = Icons.cake;
                      }

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            question.selectedOption = option;
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          decoration: BoxDecoration(
                            color:
                                isSelected ? Colors.pinkAccent : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.black26),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                optionIcon,
                                color: isSelected ? Colors.white : Colors.grey,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        elevation: 5,
                      ),
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
                      child: Text(
                        'إرسال',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
  // عرض نافذة عند فوز اللاعب
  void showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // منع إغلاق النافذة بالنقر خارجها
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightGreenAccent, Colors.greenAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.emoji_events,
                  color: Colors.yellow,
                  size: 80,
                ),
                SizedBox(height: 10),
                Text(
                  'تهانينا!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'لقد نجحت في إزالة جميع الفيروسات!',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // إعادة تشغيل اللعبة
                    resetGame();
                  },
                  child: Text(
                    'العب مرة أخرى',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// عرض نافذة عند خسارة اللاعب
  void showLoseDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // منع إغلاق النافذة بالنقر خارجها
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.redAccent, Colors.orangeAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.sentiment_dissatisfied,
                  color: Colors.white,
                  size: 80,
                ),
                SizedBox(height: 10),
                Text(
                  'انتهت اللعبة',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'لم تقم بإزالة جميع الفيروسات في الوقت المحدد.\nحاول مرة أخرى!',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // إعادة تشغيل اللعبة
                    resetGame();
                  },
                  child: Text(
                    'حاول مرة أخرى',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// دالة لإعادة تشغيل اللعبة
  void resetGame() {
    setState(() {
      timeLeft = 120;
      message = '';
      gameEnded = false;
      initializeGame();
      startTimer();
    });
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
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/AntiGameBack.png'),
                fit: BoxFit.cover,
              ),
            ),
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
                          child: Image.asset(
                            'assets/antivirus_icon.png',
                            width: 50,
                            height: 50,
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

                    // تحديد الصورة المناسبة بناءً على حالة الملف
                    String imagePath = 'assets/child_file.png';
                    if (file.scanned && file.isInfected) {
                      imagePath = 'assets/child_file_infected.png';
                    } else if (file.scanned && !file.isInfected) {
                      imagePath = 'assets/child_file_safe.png';
                    }

                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            attemptDeleteVirus(file);
                          },
                          child: Image.asset(
                            imagePath,
                            width: 50,
                            height: 50,
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
          // إضافة المؤقت في الزاوية العلوية اليمنى
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // دائرة خارجية
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.pinkAccent, Colors.orangeAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                  // دائرة داخلية لتمثيل الوقت المتبقي
                  Positioned(
                    child: Text(
                      '$timeLeft',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // أيقونة الساعة
                  Positioned(
                    bottom: 8,
                    child: Icon(
                      Icons.alarm,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // عرض نافذة برنامج مكافحة الفيروسات إذا تم فتحها
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
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  children: [
                    // شريط العنوان مع زر الإغلاق
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.purpleAccent,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: Row(
                        children: [
                          Icon(Icons.shield, color: Colors.yellowAccent),
                          SizedBox(width: 10),
                          Text(
                            'برنامج مكافحة الفيروسات',
                            style: TextStyle(color: Colors.white, fontSize: 18),
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
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.greenAccent,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  message,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black87),
                                ),
                              ),
                            SizedBox(height: 10),
                            // اختيار نوع المسح
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.lightBlueAccent,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'اختر نوع المسح:',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                  SizedBox(height: 10),
                                  Wrap(
                                    spacing: 10,
                                    children: scanOptions.map((option) {
                                      bool isSelected =
                                          selectedScanOption == option;
                                      return ChoiceChip(
                                        label: Text(
                                          option,
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                        ),
                                        selected: isSelected,
                                        selectedColor: Colors.pinkAccent,
                                        onSelected: (selected) {
                                          setState(() {
                                            selectedScanOption = option;
                                            if (selectedScanOption != 'مخصص') {
                                              customScanFiles.clear();
                                            }
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            // زر المسح
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 30),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: performScan,
                              icon: Icon(Icons.search),
                              label: Text(
                                'بدء المسح',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            SizedBox(height: 20),
                            // إذا كان المسح مخصصًا، عرض تعليمات واختيار الملفات
                            if (selectedScanOption == 'مخصص')
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.yellowAccent.shade100,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ListView.builder(
                                    itemCount: fileList.length,
                                    itemBuilder: (context, index) {
                                      FileItem file = fileList[index];
                                      bool isSelected =
                                          customScanFiles.contains(file);
                                      return ListTile(
                                        leading: Icon(
                                          Icons.insert_drive_file,
                                          color: isSelected
                                              ? Colors.pinkAccent
                                              : Colors.blueAccent,
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
                                        selectedTileColor: Colors.pink.shade100,
                                      );
                                    },
                                  ),
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

// تأكد من أن فئة FileItem تحتوي على حقل scanned
