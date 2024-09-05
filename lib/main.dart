import 'package:cybergame/LinksGame/gameScree.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil
import 'LinksGame/LinksVideoScreen.dart';
import 'DoorsGame/DoorsScreen.dart';

void main() {
  // Ensure widget binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Hide the notification bar and set immersive mode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Lock the orientation to landscape
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(LinkClassificationGame());
  });
}

class LinkClassificationGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // Initialize ScreenUtil
      designSize: const Size(812, 375), // Set your design size (width, height)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          home: Scaffold(
            backgroundColor: const Color.fromARGB(255, 52, 126, 253),
            body: DoorsScreen(),
          ),
        );
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(812, 375), // Set your design size (width, height)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: Scaffold(
            backgroundColor: const Color.fromARGB(255, 88, 147, 249),
            body: GameScreen(),
          ),
        );
      },
    );
  }
}
