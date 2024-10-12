import 'package:cybergame/LinksGame/LinkTest.dart';
import 'package:cybergame/LinksGame/gameScree.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil
import 'LinksGame/LinksVideoScreen.dart';
import 'DoorsGame/DoorsScreen.dart';
import 'DoorsGame/DoorsMainVideo.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Add localization for RTL
import 'PasswordGame/CryptoGameScreen.dart';
import 'HomePage/HomePage.dart';
import 'package:cybergame/MarioGame/MarioScreen.dart';

void main() {
  // Ensure widget binding is initialized
  // Helloooooooooooooohh
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
          locale:
              const Locale('ar', 'AE'), // Set Arabic locale for RTL direction
          supportedLocales: const [
            Locale('ar', 'AE'), // Arabic
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            // Check if the current locale is supported
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          home: Scaffold(
            backgroundColor: const Color.fromARGB(255, 52, 126, 253),
            body: HomePage(),
          ),
          builder: (context, widget) {
            // Force RTL layout direction
            return Directionality(
              textDirection: TextDirection.rtl,
              child: widget!,
            );
          },
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
          locale:
              const Locale('ar', 'AE'), // Set Arabic locale for RTL direction
          supportedLocales: const [
            Locale('ar', 'AE'), // Arabic
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            // Check if the current locale is supported
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: Scaffold(
            backgroundColor: const Color.fromARGB(255, 88, 147, 249),
            body: GameScreen(),
          ),
          builder: (context, widget) {
            // Force RTL layout direction
            return Directionality(
              textDirection: TextDirection.rtl,
              child: widget!,
            );
          },
        );
      },
    );
  }
}
