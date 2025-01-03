import 'package:flutter/material.dart';
import 'package:cybergame/SocialMesiaGame/Pages/Msgs.dart';
import 'package:cybergame/SocialMesiaGame/Tabs/ActivityTab.dart';
import 'package:cybergame/SocialMesiaGame/Tabs/HomeTab.dart';
import 'package:cybergame/SocialMesiaGame/Tabs/ProfileTab.dart';
import 'package:cybergame/SocialMesiaGame/Tabs/SearchTab.dart';
import 'package:cybergame/SocialMesiaGame/Tabs/UploadTab.dart';
import 'package:cybergame/SocialMesiaGame/Widgets/ActivityTile.dart';
import 'package:cybergame/SocialMesiaGame/Widgets/ActivityTilealt.dart';
import 'package:cybergame/SocialMesiaGame/Widgets/FeedPost.dart';
import 'package:cybergame/SocialMesiaGame/Widgets/SearchCat.dart';
import 'package:cybergame/SocialMesiaGame/Widgets/Stories.dart';
import 'package:cybergame/SocialMesiaGame/Widgets/Suggestion.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InstaHomePage extends StatefulWidget {
  Map<String, String> personalInfo;
  InstaHomePage({required this.personalInfo});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<InstaHomePage> {
  int _currentTab = 0;
  dynamic _tabs = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      _tabs = [
        HomeTab(personalInfo: widget.personalInfo),
        // SearchTab(),
        UploadTab(),
        ActivityTab(),
        ProfileTab(personalInfo: widget.personalInfo),
      ];
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // You can use the image file (e.g., display it or upload it)
      print('Picked image path: ${image.path}');
    } else {
      // Handle the case where the user cancels the picker
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs.length == 0
          ? Center(
              child: CircularProgressIndicator(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  strokeWidth: 1.0))
          : _tabs[_currentTab],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentTab,
          onTap: (int value) {
            setState(() {
              _currentTab = value;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home,
                    color: const Color.fromARGB(255, 124, 0, 181), size: 30.0),
                label: '',
                activeIcon: Icon(Icons.home, color: Colors.blue)),
            BottomNavigationBarItem(
                icon: GestureDetector(
                    onTap: _pickImage,
                    child: Icon(Icons.add_circle_outline,
                        color: Color.fromARGB(255, 124, 0, 181), size: 30.0)),
                label: '',
                activeIcon: Icon(Icons.add_circle_outline,
                    color: Colors.blue, size: 30.0)),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.heart,
                    color: Color.fromARGB(255, 124, 0, 181), size: 30.0),
                label: '',
                activeIcon: Icon(
                  FontAwesomeIcons.solidHeart,
                  color: Colors.red,
                  size: 30,
                )),
            BottomNavigationBarItem(
                icon: CircleAvatar(
                    backgroundImage: AssetImage('assets/MyPro.png'),
                    radius: 15.0),
                label: '')
          ]),
    );
  }
}
