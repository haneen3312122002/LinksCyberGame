import 'package:cybergame/LinksGame/LinkTest.dart';
import 'package:cybergame/LinksGame/gameScree.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil
import 'package:flutter_localizations/flutter_localizations.dart'; // Add localization for RTL
import 'HomePage/HomePage.dart';
import 'package:cybergame/MarioGame/MarioScreen.dart';
import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flame/game.dart';
import 'GalaxyGame/GalaxyGameScreen.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'SocialMesiaGame/Login.dart';
import 'DoorsGame/afterdoor4.dart';

// Define a GlobalKey for the Navigator State
// This key will allow us to access the Navigator from anywhere in the app
// without needing a direct BuildContext descendant of the Navigator.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
  LoginPage log = LoginPage();
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(812, 375), // Set your design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          // Assign the global key to the navigatorKey property
          navigatorKey: navigatorKey, // IMPORTANT: This is the key change!
          // --- Localization and RTL setup (unchanged) ---
          locale: const Locale('ar', 'AE'),
          supportedLocales: const [
            Locale('ar', 'AE'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },

          // --- Initial route ---
          home: Scaffold(
            backgroundColor: const Color.fromARGB(255, 52, 126, 253),
            body: LoginPage(),
          ),

          // --- MODIFICATION START: Add a global Home Icon ---
          builder: (context, widget) {
            // 'widget' here is the current page being displayed by the Navigator.
            final page = widget!;

            // We wrap the entire page in a Directionality and Stack.
            return Directionality(
                textDirection: TextDirection.rtl, // Keep your RTL setting
                child: Stack(
                  children: [
                    // Layer 1: The current page (e.g., a game screen, login page).
                    page,

                    // Layer 2: The Home and Login Icons, positioned on top.
                    // We only show the icons if the current page is NOT the HomePage
                    // and NOT the initial Scaffold (which contains the LoginPage).
                    if (page is! HomePage && page is! Scaffold)
                      // Use a Stack to position multiple buttons
                      Stack(
                        children: [
                          // --- Home Button (existing) ---
                          Positioned(
                            bottom: 200.0, // Padding from the bottom
                            left: 16.0, // Padding from the right (start in RTL)
                            child: Material(
                              color: Colors.transparent,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.home,
                                  color: Colors.white,
                                  size: 35.0,
                                ),
                                onPressed: () {
                                  navigatorKey.currentState?.pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HomePage(personalInfo: {'': ''})),
                                    (route) => false,
                                  );
                                },
                              ),
                            ),
                          ),

                          // --- Login Button (New Addition) ---
                          Positioned(
                            bottom: 150.0, // Positioned under the Home button
                            left:
                                16.0, // Aligned horizontally with the Home button
                            child: Material(
                              color: Colors.transparent,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.logout, // Icon to return to login page
                                  color: Colors.white,
                                  size: 35.0,
                                ),
                                onPressed: () {
                                  // Navigate back to LoginPage and clear all routes
                                  navigatorKey.currentState?.pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                    (route) => false,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ));
          },
          // --- MODIFICATION END ---
        );
      },
    );
  }
}

// This `MyApp` widget is defined in your original code but is not being used,
// as `runApp` calls `LinkClassificationGame()`. You can safely ignore or remove it.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(812, 375),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          locale: const Locale('ar', 'AE'),
          supportedLocales: const [
            Locale('ar', 'AE'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
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
            body: GalaxyAttackGame(),
          ),
          builder: (context, widget) {
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
