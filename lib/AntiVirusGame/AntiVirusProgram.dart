import 'dart:math';

class AntivirusProgram {
  List<File> detectedViruses = [];
  String scanSpeed; // "fast" or "detailed"

  AntivirusProgram({required this.scanSpeed});

  // Method to scan files for viruses
  void scanFiles(List<File> fileList) {
    detectedViruses.clear(); // Reset detected viruses before a new scan
    for (var file in fileList) {
      // Check if the file is infected
      if (file.isInfected) {
        detectedViruses.add(file);
      }
    }
  }

  // Method to remove a virus from a file
  bool removeVirus(File file) {
    // Remove success depends on scan speed: fast has 70% success, detailed has 90%
    double successRate = (scanSpeed == "detailed") ? 0.9 : 0.7;
    bool success = Random().nextDouble() < successRate;

    if (success) {
      file.clean(); // Mark file as clean if successfully removed
      detectedViruses.remove(file); // Remove from detected viruses
    }
    return success;
  }

  // Method to alert player with the virus count
  void alertPlayer(Function(int) onVirusCountUpdate) {
    onVirusCountUpdate(detectedViruses.length);
  }
}

// Sample File class (as used in the previous GameScreen code)
class File {
  String fileName;
  bool isInfected;

  File({required this.fileName, required this.isInfected});

  void clean() {
    isInfected = false;
  }
}
