class GameLevels {
  int currentStep = 0;
  String answer = '';
  List<String> selectedLetters = [];

  final List<GameLevelData> levels = [
    GameLevelData(
      question: "ما الكلمة المشتركة بين الصور التي ترتبط بفيروسات التروجان؟",
      answer: "حصان",
      images: ["HourseL1.png", "Box.png", "Danger.png", "Lock.png"],
    ),
    GameLevelData(
      question: "ما الكلمة المشتركة التي ترتبط بطريقة انتشار الفيروسات؟",
      answer: "انتشار",
      images: [
        "network_cable.png",
        "wifi_spread.png",
        "MobileSecurityPart.png",
        "transfer_arrow.png"
      ],
    ),
    GameLevelData(
      question: "ما الكلمة التي تصف هجومًا خداعيًا؟",
      answer: "تصيد",
      images: [
        "phishing_email.png",
        "malicious_link.png",
        "fake_login.png",
        "anonymous_message.png"
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
