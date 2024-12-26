import 'package:flutter/material.dart';

class ActivityTab extends StatelessWidget {
  final List<Map<String, dynamic>> usersWithPoints = [
    {
      "username": "samwilson",
      "points": 150,
      "profilePicture": "assets/Sam Wilson.jpg"
    },
    {
      "username": "chris_john",
      "points": 120,
      "profilePicture": "assets/chris.jpg"
    },
    {
      "username": "dan_smith94",
      "points": 100,
      "profilePicture": "assets/dan.jpg"
    },
    {
      "username": "__jeremy__",
      "points": 90,
      "profilePicture": "assets/jeremy.jpg"
    },
    {
      "username": "joey__gabby",
      "points": 80,
      "profilePicture": "assets/joey.jpg"
    },
    {
      "username": "matthewjackson",
      "points": 70,
      "profilePicture": "assets/mathew.jpg"
    },
    {
      "username": "marcus__white",
      "points": 50,
      "profilePicture": "assets/marcus.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ترتيب الحسابات',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 2.0,
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: usersWithPoints.length,
        itemBuilder: (context, index) {
          final user = usersWithPoints[index];
          return UserRankingTile(
            rank: index + 1,
            username: user['username'],
            points: user['points'],
            profilePicture: user['profilePicture'],
          );
        },
      ),
    );
  }
}
//...................

class UserRankingTile extends StatelessWidget {
  final int rank;
  final String username;
  final int points;
  final String profilePicture;

  const UserRankingTile({
    Key? key,
    required this.rank,
    required this.username,
    required this.points,
    required this.profilePicture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Text(
            '$rank',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(width: 15.0),
          CircleAvatar(
            radius: 25.0,
            backgroundImage: AssetImage(profilePicture),
          ),
          SizedBox(width: 15.0),
          Expanded(
            child: Text(
              username,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Text(
            '$points نقطة',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
