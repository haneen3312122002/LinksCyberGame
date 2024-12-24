import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FeedPost extends StatefulWidget {
  final String username;
  final int likes;
  final String time;
  final String profilePicture;
  final String image;
  final String text;
  final List<Comment> comments; // New field for comments
  Map<String, String> personalInfo;
  FeedPost({
    this.username = '',
    required this.personalInfo,
    this.likes = 0,
    this.time = '',
    this.profilePicture = 'assets/18back.png',
    this.image = 'assets/18back.png',
    this.text = '',
    this.comments = const [],
  });

  @override
  _FeedPostState createState() => _FeedPostState();
}

class Comment {
  final String? username;
  final String profilePicture;
  final String content;
  bool isLiked;

  Comment({
    required this.username,
    required this.profilePicture,
    required this.content,
    this.isLiked = false,
  });
}

class _FeedPostState extends State<FeedPost> {
  bool isLiked = false;
  bool displayHeart = false;

  void _showCommentsPopup(BuildContext context) {
    final TextEditingController _commentController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text(
                'التعليقات',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Container(
                width: double.maxFinite,
                height: 400, // Fixed height to avoid size issues
                child: Column(
                  children: [
                    // List of comments
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.comments.length,
                        itemBuilder: (context, index) {
                          final comment = widget.comments[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  AssetImage(comment.profilePicture),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  comment.username!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    // Handle reporting of a comment
                                    debugPrint(
                                      "Reported comment: ${comment.content}",
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.flag,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(comment.content),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          comment.isLiked = !comment.isLiked;
                                        });
                                      },
                                      icon: Icon(
                                        comment.isLiked
                                            ? FontAwesomeIcons.solidHeart
                                            : FontAwesomeIcons.heart,
                                        size: 15,
                                        color: comment.isLiked
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    GestureDetector(
                                      onTap: () {
                                        // Handle reply functionality
                                        debugPrint(
                                          "Reply to ${comment.username}",
                                        );
                                      },
                                      child: const Text(
                                        'رد',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(),
                    // Add comment input field
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            decoration: const InputDecoration(
                              hintText: 'أضف تعليقًا...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.send,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            if (_commentController.text.isNotEmpty) {
                              setState(() {
                                widget.comments.add(
                                  Comment(
                                    username: widget.personalInfo[
                                        'name'], // Replace with actual username
                                    profilePicture:
                                        'assets/your_profile.png', // Replace with actual profile picture
                                    content: _commentController.text,
                                  ),
                                );
                              });
                              _commentController.clear();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('إغلاق'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // User Info
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: AssetImage(widget.profilePicture),
                  ),
                  const SizedBox(width: 10.0),
                  Text(widget.username,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15.0)),
                ],
              ),
              const Icon(Icons.more_vert),
            ],
          ),
        ),

        // Post Image
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
          child: Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                child: Image.asset(widget.image, fit: BoxFit.cover),
              ),
              if (displayHeart)
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  child: const Center(
                    child: Icon(
                      FontAwesomeIcons.solidHeart,
                      color: Colors.white,
                      size: 80.0,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Interactions (Like, Comment)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isLiked = !isLiked;
                      });
                    },
                    child: Icon(
                      isLiked
                          ? FontAwesomeIcons.solidHeart
                          : FontAwesomeIcons.heart,
                      color: isLiked ? Colors.red : null,
                      size: 25.0,
                    ),
                  ),
                  const SizedBox(width: 15.0),
                  GestureDetector(
                    onTap: () {
                      _showCommentsPopup(context);
                    },
                    child: const Icon(FontAwesomeIcons.comment, size: 25.0),
                  ),
                  const SizedBox(width: 15.0),
                  const Icon(FontAwesomeIcons.paperPlane, size: 25.0),
                ],
              ),
              const Icon(FontAwesomeIcons.bookmark, size: 25.0),
            ],
          ),
        ),

        // Likes Count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text('${widget.likes} إعجابات',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
        ),

        // Post Text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Text(
            widget.text,
            style: const TextStyle(fontSize: 14.0),
          ),
        ),

        // Post Time
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Text('منذ ${widget.time}',
              style: const TextStyle(fontSize: 12.0, color: Colors.grey)),
        ),
      ],
    );
  }
}
