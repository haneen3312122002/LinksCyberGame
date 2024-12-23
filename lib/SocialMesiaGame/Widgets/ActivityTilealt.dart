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

class ActivityTileAlt extends StatelessWidget {
  final String username;
  final bool mention;
  final String profilePicture;
  final String image;

  ActivityTileAlt(
      {this.username = '',
      this.mention = false,
      this.profilePicture = 'assets/18back.png',
      this.image = 'assets/18back.png'});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 13.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 30.0,
                backgroundImage: AssetImage(profilePicture),
              ),
              SizedBox(width: 10.0),
              Container(
                width: MediaQuery.of(context).size.width / 1.8,
                child: Text.rich(
                  TextSpan(
                    text: username,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                      TextSpan(
                        text: mention ? ' قام بذكرك في تعليق' : ' أعجب بمنشورك',
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Container(
            width: 50.0,
            height: 50.0,
            child: Image.asset(image, fit: BoxFit.cover),
          )
        ],
      ),
    );
  }
}
