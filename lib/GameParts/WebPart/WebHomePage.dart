import 'package:flutter/material.dart';
import 'dart:ui' as ui; // Import for the ImageFilter
import 'WebPart.dart';

class WebHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            itemCount:
                10, // Number of pages (assuming each part has its own page)
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  // Display different background image for each section
                  index == 1
                      ? SectionTwoBackground() // Background for section 2 (index 1)
                      : index == 2
                          ? SectionThreeBackground() // Background for section 3 (index 2)
                          : index == 3
                              ? SectionFourBackground() // Background for section 4 (index 3)
                              : BackgroundImage(), // Default background
                  WebGameSection(index: index),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// Default background image for most sections
class BackgroundImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image:
              AssetImage('assets/Street1.png'), // Default background image path
          fit: BoxFit.cover, // Ensure the image covers the whole screen
        ),
      ),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
            sigmaX: 13.0, sigmaY: 13.0), // Applying blur filter
        child: Container(
          color: Colors.black.withOpacity(
              0.1), // Optional: Add a black overlay with some opacity if needed
        ),
      ),
    );
  }
}

// New background image for section 2 (index 1)
class SectionTwoBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'assets/trojenHorse.png'), // New image for section 2 (index 1)
          fit: BoxFit.cover, // Ensure the image covers the whole screen
        ),
      ),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
            sigmaX: 13.0, sigmaY: 13.0), // Applying blur filter
        child: Container(
          color: Colors.black.withOpacity(
              0.1), // Optional: Add a black overlay with some opacity if needed
        ),
      ),
    );
  }
}

// New background image for section 3 (index 2)
class SectionThreeBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'assets/doorback.png'), // New image for section 3 (index 2)
          fit: BoxFit.cover, // Ensure the image covers the whole screen
        ),
      ),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
            sigmaX: 13.0, sigmaY: 13.0), // Applying blur filter
        child: Container(
          color: Colors.black.withOpacity(
              0.1), // Optional: Add a black overlay with some opacity if needed
        ),
      ),
    );
  }
}

// New background image for section 4 (index 3)
class SectionFourBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'assets/linkback.png'), // New image for section 4 (index 3)
          fit: BoxFit.cover, // Ensure the image covers the whole screen
        ),
      ),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
            sigmaX: 13.0, sigmaY: 13.0), // Applying blur filter
        child: Container(
          color: Colors.black.withOpacity(
              0.1), // Optional: Add a black overlay with some opacity if needed
        ),
      ),
    );
  }
}
