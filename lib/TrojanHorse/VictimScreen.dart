import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class VictimScreen extends StatefulWidget {
  final ValueNotifier<String> virusTypeNotifier;
  final ValueNotifier<bool> showFakeGoogleIconNotifier;
  final ValueNotifier<Color> backgroundColorNotifier;

  VictimScreen({
    required this.virusTypeNotifier,
    required this.showFakeGoogleIconNotifier,
    required this.backgroundColorNotifier,
  });

  @override
  _VictimScreenState createState() => _VictimScreenState();
}

class _VictimScreenState extends State<VictimScreen> {
  bool showMessage = false;
  final AudioPlayer audioPlayer = AudioPlayer();
  String? openFolderName;
  List<String>? openFolderFiles;
  bool isSlow = false;

  @override
  void initState() {
    super.initState();
    widget.virusTypeNotifier.addListener(_handleVirusType);
  }

  @override
  void dispose() {
    widget.virusTypeNotifier.removeListener(_handleVirusType);
    audioPlayer.dispose();
    super.dispose();
  }

  void _handleVirusType() {
    final virusType = widget.virusTypeNotifier.value;
    switch (virusType) {
      case 'حذف الملفات':
        _deleteFiles();
        break;
      case 'إتلاف الملفات':
        _destroyFiles();
        break;
      case 'إبطاء النظام':
        _simulateSlowSystem();
        break;
      case 'رسائل منبثقة':
        _showInlineMessage();
        break;
    }
  }

  void _deleteFiles() {
    if (openFolderFiles != null && openFolderFiles!.isNotEmpty) {
      setState(() {
        openFolderFiles!.clear();
      });
    }
  }

  void _destroyFiles() {
    if (openFolderFiles != null && openFolderFiles!.isNotEmpty) {
      setState(() {
        openFolderFiles!.clear();
      });
    }
  }

  void _simulateSlowSystem() {
    setState(() {
      isSlow = true;
    });
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        isSlow = false;
      });
    });
  }

  void _showInlineMessage() async {
    await audioPlayer.play(AssetSource('Evil.mp3')); // تشغيل الصوت
    setState(() {
      showMessage = true; // عرض الرسالة التحذيرية
    });

    // إخفاء الرسالة بعد 5 ثوانٍ
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        showMessage = false;
      });
    });
  }

  void _openFolderWindow(String folderName, List<String> files) {
    setState(() {
      openFolderName = folderName;
      openFolderFiles = List.from(files);
    });
  }

  void _closeFolderWindow() {
    setState(() {
      openFolderName = null;
      openFolderFiles = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: ValueListenableBuilder<Color>(
          valueListenable: widget.backgroundColorNotifier,
          builder: (context, backgroundColor, child) {
            return Container(
              width: screenSize.width,
              height: screenSize.height,
              decoration: BoxDecoration(
                color: backgroundColor, // تطبيق اللون المحدد للخلفية
                border: Border.all(
                  color: const Color.fromARGB(255, 111, 89, 255),
                  width: 10,
                ),
                image: DecorationImage(
                  image: AssetImage('assets/desktop1.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: screenSize.height * 0.02),
                      _buildDesktopIcon(
                          'My Homework', Icons.insert_drive_file, [
                        "Math Homework.pdf",
                        "Science Notes.docx",
                        "History Essay.docx"
                      ]),
                      SizedBox(height: screenSize.height * 0.02),
                      _buildDesktopIcon('Images', Icons.image,
                          ["Vacation.jpg", "Birthday.png", "Event Photo.jpeg"]),
                      SizedBox(height: screenSize.height * 0.02),
                      _buildDesktopIcon('Documents', Icons.folder, [
                        "Resume.pdf",
                        "Project Proposal.docx",
                        "Meeting Notes.txt"
                      ]),
                    ],
                  ),
                  Positioned(
                    bottom: screenSize.height * 0.05,
                    right: screenSize.width * 0.05,
                    child: _buildDesktopIcon('Recycle Bin', Icons.delete, []),
                  ),
                  if (openFolderName != null && openFolderFiles != null)
                    _buildFolderWindow(screenSize),
                  if (isSlow)
                    Center(child: CircularProgressIndicator()), // تأثير البطء
                  if (showMessage)
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        color: Colors.red,
                        child: Text(
                          'تم اختراق جهازك!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ValueListenableBuilder<bool>(
                    valueListenable: widget.showFakeGoogleIconNotifier,
                    builder: (context, showFakeIcon, child) {
                      return showFakeIcon
                          ? Positioned(
                              bottom: screenSize.height * 0.15,
                              right: screenSize.width * 0.15,
                              child: Image.asset(
                                'assets/instalogo.png',
                                width: 100,
                                height: 100,
                              ),
                            )
                          : SizedBox.shrink();
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDesktopIcon(String label, IconData icon, List<String> files) {
    return Column(
      children: [
        IconButton(
          icon: Icon(
            icon,
            size: 70,
            color: const Color.fromARGB(255, 136, 120, 120),
          ),
          onPressed: () {
            if (files.isNotEmpty) {
              _openFolderWindow(label, files);
            }
          },
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ],
    );
  }

  Widget _buildFolderWindow(Size screenSize) {
    return Positioned(
      right: screenSize.width * 0.05,
      top: screenSize.height * 0.1,
      child: Container(
        width: screenSize.width * 0.4,
        height: screenSize.height * 0.6,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Container(
              color: Colors.blueGrey,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    openFolderName ?? '',
                    style: TextStyle(color: Colors.white),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: _closeFolderWindow,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: openFolderFiles!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Icon(Icons.insert_drive_file,
                            size: 50, color: Colors.blueGrey),
                        SizedBox(height: 5),
                        Text(
                          openFolderFiles![index],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
