import 'package:flutter/material.dart';
import 'package:cybergame/SocialMesiaGame/Pages/Msgs.dart';
import 'package:cybergame/SocialMesiaGame/Tabs/ActivityTab.dart';
import 'package:cybergame/SocialMesiaGame/Tabs/ProfileTab.dart';
import 'package:cybergame/SocialMesiaGame/Tabs/SearchTab.dart';
import 'package:cybergame/SocialMesiaGame/Tabs/UploadTab.dart';
import 'package:cybergame/SocialMesiaGame/Widgets/ActivityTile.dart';
import 'package:cybergame/SocialMesiaGame/Widgets/FeedPost.dart';
import 'package:cybergame/SocialMesiaGame/Widgets/Stories.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeTab extends StatelessWidget {
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.0,
        title: Container(
          width: MediaQuery.of(context).size.width / 2.3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: _pickImage, // Replaced _launchCamera with _pickImage
                child: Icon(
                  FontAwesomeIcons.camera,
                  color: Colors.black,
                  size: 30.0,
                ),
              ),
              SizedBox(width: 30.0),
              Text(
                'Instagram',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Billabong',
                  fontSize: 30.0,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MessagesPage()),
                );
              },
              child: Icon(
                FontAwesomeIcons.paperPlane,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StoriesWidget(),
            FeedPost(
              username: 'samwilson',
              likes: 102,
              time: '2 hours',
              profilePicture: 'assets/Sam Wilson.jpg',
              image: 'assets/story1.jpg',
            ),
            FeedPost(
              username: 'eddisonalfred',
              likes: 156,
              time: '6 hours',
              profilePicture: 'assets/eddison.jpg',
              image: 'assets/story2.jpg',
            ),
            FeedPost(
              username: 'adelle_klarke',
              likes: 56,
              time: '2 days',
              profilePicture: 'assets/adelle.jpg',
              image: 'assets/story3.jpg',
            ),
            FeedPost(
              username: 'matthewsimpson',
              likes: 224,
              time: '1 week',
              profilePicture: 'assets/mathew.jpg',
              image: 'assets/story4.jpg',
            ),
            FeedPost(
              username: 'ryanconnor',
              likes: 112,
              time: '2 weeks',
              profilePicture: 'assets/ryan.jpg',
              image: 'assets/story8.jpg',
            ),
          ],
        ),
      ),
    );
  }
}
