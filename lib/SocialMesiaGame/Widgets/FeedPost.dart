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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FeedPost extends StatefulWidget {
  final String username;
  final int likes;
  final String time;
  final String profilePicture;
  final String image;

  FeedPost(
      {this.username = '',
      this.likes = 0,
      this.time = '',
      this.profilePicture = 'assets/18back.png',
      this.image = 'assets/18back.png'});

  @override
  _FeedPostState createState() => _FeedPostState();
}

class _FeedPostState extends State<FeedPost> {
  bool isLiked = false;
  bool displayHeart = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: AssetImage(widget.profilePicture),
                  ),
                  SizedBox(width: 10.0),
                  Text(widget.username,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15.0)),
                ],
              ),
              Icon(Icons.more_vert)
            ],
          ),
        ),
        GestureDetector(
          onDoubleTap: () {
            setState(() {
              isLiked = !isLiked;
              displayHeart = true;
            });
            Future.delayed(const Duration(milliseconds: 750), () {
              setState(() {
                displayHeart = false;
              });
            });
          },
          child: displayHeart == true
              ? Stack(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      child: Image.asset(widget.image, fit: BoxFit.cover),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        child: Center(
                            child: Icon(FontAwesomeIcons.solidHeart,
                                color: Colors.white, size: 80.0))),
                  ],
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  child: Image.asset(widget.image, fit: BoxFit.cover),
                ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  isLiked == true
                      ? Icon(FontAwesomeIcons.solidHeart,
                          color: Colors.red, size: 25.0)
                      : Icon(FontAwesomeIcons.heart, size: 25.0),
                  SizedBox(width: 15.0),
                  Icon(FontAwesomeIcons.comment, size: 25.0),
                  SizedBox(width: 15.0),
                  Icon(FontAwesomeIcons.paperPlane, size: 25.0),
                ],
              ),
              Icon(FontAwesomeIcons.bookmark, size: 25.0)
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Text('${widget.likes} likes',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Text('${widget.time} ago',
              style: TextStyle(fontSize: 12.0, color: Colors.grey)),
        )
      ],
    );
  }
}
