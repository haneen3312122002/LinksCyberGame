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

class ProfileTab extends StatelessWidget {
  Map<String, String> personalInfo;

  ProfileTab({required this.personalInfo});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(personalInfo['name'] ?? 'Unknown User',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 19.0)),
          elevation: 0.0,
          backgroundColor: Colors.white,
          actions: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(Icons.menu, color: Colors.black, size: 30.0),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(22.0, 35.0, 22.0, 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 45.0,
                          backgroundImage: AssetImage('assets/Mike Tyler.jpg'),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text('21',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 18.0)),
                            SizedBox(height: 5.0),
                            Text('Posts', style: TextStyle(fontSize: 15.0))
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text('358',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 18.0)),
                            SizedBox(height: 5.0),
                            Text('Followers', style: TextStyle(fontSize: 15.0))
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text('293',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 18.0)),
                            SizedBox(height: 5.0),
                            Text('Following', style: TextStyle(fontSize: 15.0))
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 10.0),
                      child: Text(personalInfo['name'] ?? 'Unknown User',
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      height: 30.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(width: 0.1, color: Colors.black)),
                      child: Center(
                          child: Text('Edit Profile',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.0))),
                    ),
                  ],
                ),
              ),
              Divider(),
              Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 3 - 2,
                          height: MediaQuery.of(context).size.width / 3 - 2,
                          child: Image.asset('assets/story1.jpg',
                              fit: BoxFit.cover),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3 - 2,
                          height: MediaQuery.of(context).size.width / 3 - 2,
                          child: Image.asset('assets/story8.jpg',
                              fit: BoxFit.cover),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3 - 2,
                          height: MediaQuery.of(context).size.width / 3 - 2,
                          child: Image.asset('assets/story2.jpg',
                              fit: BoxFit.cover),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 2.0),
              Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 3 - 2,
                          height: MediaQuery.of(context).size.width / 3 - 2,
                          child: Image.asset('assets/story4.jpg',
                              fit: BoxFit.cover),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3 - 2,
                          height: MediaQuery.of(context).size.width / 3 - 2,
                          child: Image.asset('assets/story5.jpg',
                              fit: BoxFit.cover),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3 - 2,
                          height: MediaQuery.of(context).size.width / 3 - 2,
                          child: Image.asset('assets/story3.jpg',
                              fit: BoxFit.cover),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 2.0),
              Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 3 - 2,
                          height: MediaQuery.of(context).size.width / 3 - 2,
                          child: Image.asset('assets/story6.jpg',
                              fit: BoxFit.cover),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3 - 2,
                          height: MediaQuery.of(context).size.width / 3 - 2,
                          child: Image.asset('assets/story9.jpg',
                              fit: BoxFit.cover),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3 - 2,
                          height: MediaQuery.of(context).size.width / 3 - 2,
                          child: Image.asset('assets/story10.jpg',
                              fit: BoxFit.cover),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 2.0),
              Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 3 - 2,
                          height: MediaQuery.of(context).size.width / 3 - 2,
                          child: Image.asset('assets/story11.jpg',
                              fit: BoxFit.cover),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3 - 2,
                          height: MediaQuery.of(context).size.width / 3 - 2,
                          child: Image.asset('assets/story12.jpg',
                              fit: BoxFit.cover),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3 - 2,
                          height: MediaQuery.of(context).size.width / 3 - 2,
                          child: Image.asset('assets/story13.jpg',
                              fit: BoxFit.cover),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 2.0),
              Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 3 - 2,
                          height: MediaQuery.of(context).size.width / 3 - 2,
                          child: Image.asset('assets/story14.jpg',
                              fit: BoxFit.cover),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3 - 2,
                          height: MediaQuery.of(context).size.width / 3 - 2,
                          child: Image.asset('assets/story15.jpg',
                              fit: BoxFit.cover),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3 - 2,
                          height: MediaQuery.of(context).size.width / 3 - 2,
                          child: Image.asset('assets/story16.jpg',
                              fit: BoxFit.cover),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 2.0),
              Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 3 - 2,
                          height: MediaQuery.of(context).size.width / 3 - 2,
                          child: Image.asset('assets/story17.jpg',
                              fit: BoxFit.cover),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3 - 2,
                          height: MediaQuery.of(context).size.width / 3 - 2,
                          child: Image.asset('assets/story18.jpg',
                              fit: BoxFit.cover),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3 - 2,
                          height: MediaQuery.of(context).size.width / 3 - 2,
                          child: Image.asset('assets/story19.jpg',
                              fit: BoxFit.cover),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 2.0),
              Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 3 - 2,
                          height: MediaQuery.of(context).size.width / 3 - 2,
                          child: Image.asset('assets/story20.jpg',
                              fit: BoxFit.cover),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3 - 2,
                          height: MediaQuery.of(context).size.width / 3 - 2,
                          child: Image.asset('assets/story21.jpg',
                              fit: BoxFit.cover),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3 - 2,
                          height: MediaQuery.of(context).size.width / 3 - 2,
                          child: Image.asset('assets/story4.jpg',
                              fit: BoxFit.cover),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 40.0),
            ],
          ),
        ));
  }
}
