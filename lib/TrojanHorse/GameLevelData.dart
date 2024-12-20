class GameLevels {
  int currentStep = 0;
  String answer = '';
  List<String> selectedLetters = [];

  final List<GameLevelData> levels = [
    GameLevelData(
      question: "ما الكلمة المشتركة بين الصور التي ترتبط بفيروسات التروجان؟",
      answer: "حصان",
      images: [
        //كاملين
        "assets/HourseL1.png",
        "assets/Box.png",
        "assets/Danger.png",
        "assets/Lock.png"
      ],
    ),
    GameLevelData(
      question: "ما الكلمة المشتركة التي ترتبط بنوع الفيروسات؟",
      answer: "دودة",
      images: [
        "assets/network_cable.png",
        "assets/wifi_spread.png",
        "assets/MobileSecurityPart.png",
        "assets/transfer_arrow.png"
      ],
    ),
    GameLevelData(
      question: "ما الكلمة التي تصف هجومًا خداعيًا؟",
      answer: "تنصت",
      images: [
        "assets/phishing_email.png",
        "assets/malicious_link.png",
        "assets/mesage.png",
        "assets/phone.png"
      ],
    ),
  ];

  bool checkAnswer() {
    if (answer == levels[currentStep].answer) {
      currentStep++;
      resetLevel();
      return true;
    } else {
      resetLevel(); // Clear answer if incorrect
      return false;
    }
  }

  void resetLevel() {
    answer = '';
    selectedLetters = [];
  }

  bool isGameCompleted() {
    return currentStep >= levels.length;
  }

  GameLevelData getCurrentLevel() {
    return levels[currentStep];
  }

  void addLetter(String letter) {
    if (answer.length < levels[currentStep].answer.length) {
      answer += letter;
      selectedLetters.add(letter);
    }
  }

  void removeLastLetter() {
    if (answer.isNotEmpty) {
      answer = answer.substring(0, answer.length - 1);
      selectedLetters.removeLast();
    }
  }
}

class GameLevelData {
  final String question;
  final String answer;
  final List<String> images;

  GameLevelData({
    required this.question,
    required this.answer,
    required this.images,
  });
}
