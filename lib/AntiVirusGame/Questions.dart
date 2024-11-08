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
