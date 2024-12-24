import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cybergame/connection.dart';

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
                            subtitle: Text(comment.content),
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
                          onPressed: () async {
                            if (_commentController.text.isNotEmpty) {
                              final userComment = _commentController.text;
                              _commentController.clear();

                              // إرسال التعليق إلى خادم Python لتحليله
                              try {
                                final result =
                                    await analyzeComment(userComment);

                                if (result == "إيجابي") {
                                  // إذا كان التعليق إيجابيًا، أضفه إلى القائمة
                                  setState(() {
                                    widget.comments.add(
                                      Comment(
                                        username: widget.personalInfo[
                                            'name'], // اسم المستخدم
                                        profilePicture:
                                            'assets/your_profile.png', // صورة المستخدم
                                        content: userComment,
                                      ),
                                    );
                                  });

                                  // عرض رسالة نجاح
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('تمت الإضافة'),
                                        content: const Text(
                                            'تم إضافة تعليقك بنجاح.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('حسنًا'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else if (result == "سلبي") {
                                  // إذا كان التعليق سلبيًا، عرض رسالة تحذيرية
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('تعليق سلبي'),
                                        content: const Text(
                                            'تعليقك سلبي، يرجى تعديله ليكون أكثر إيجابية.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('حسنًا'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  // إذا كانت النتيجة محايدة، يمكن اختيار الإجراء المناسب
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('تعليق محايد'),
                                        content: const Text(
                                            'تعليقك محايد، يمكنك تحسينه ليكون أكثر وضوحًا.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('حسنًا'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              } catch (e) {
                                // عرض خطأ إذا فشل التحليل
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('خطأ'),
                                      content: Text(
                                          'فشل في تحليل التعليق. الخطأ: $e'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('حسنًا'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
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
