import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cybergame/connection.dart'; // For analyzeComment()

// ----------------------------
// MODEL
// ----------------------------
class Comment {
  final String? username;
  final String profilePicture;
  final String content;

  // Tracks if the user (child) has liked THIS comment
  bool isCommentLiked;

  // How many points we last changed when the user liked/unliked this comment
  int commentLikePointsChange;

  // List of replies (which are also Comments)
  final List<Comment> replies;

  Comment({
    required this.username,
    required this.profilePicture,
    required this.content,
    this.isCommentLiked = false,
    this.commentLikePointsChange = 0,
    this.replies = const [],
  });
}

// ----------------------------
// FEED POST
// ----------------------------
class FeedPost extends StatefulWidget {
  final String username;
  final int likes;
  final String time;
  final String profilePicture;
  final String image;
  final String text;
  final List<Comment> comments; // default = const []
  final Map<String, String> personalInfo;
  final Function(int) onPointsChanged;

  const FeedPost({
    Key? key,
    this.username = '',
    required this.personalInfo,
    this.likes = 0,
    this.time = '',
    this.profilePicture = 'assets/18back.png',
    this.image = 'assets/18back.png',
    this.text = '',
    this.comments = const [], // might be immutable
    required this.onPointsChanged,
  }) : super(key: key);

  @override
  _FeedPostState createState() => _FeedPostState();
}

class _FeedPostState extends State<FeedPost> {
  /// Tracks whether this user has liked the POST itself.
  bool isLiked = false;
  bool displayHeart = false;
  int _likePointsChange = 0;

  // ----------------------------------------------------------------
  // A local mutable copy of widget.comments to avoid const []
  // ----------------------------------------------------------------
  late List<Comment> _localComments;

  @override
  void initState() {
    super.initState();
    // We can't remove or alter widget.comments = const [],
    // so we'll copy them into a mutable list here.
    _localComments = _deepCopyComments(widget.comments);
  }

  // ----------------------------------------------------------------
  // A helper method to do a "deep copy"
  // so each comment.replies is also mutable
  // ----------------------------------------------------------------
  List<Comment> _deepCopyComments(List<Comment> source) {
    return source.map((orig) {
      return Comment(
        username: orig.username,
        profilePicture: orig.profilePicture,
        content: orig.content,
        isCommentLiked: orig.isCommentLiked,
        commentLikePointsChange: orig.commentLikePointsChange,
        replies: _deepCopyComments(orig.replies),
      );
    }).toList();
  }

  // ----------------------------
  // HELPER METHODS
  // ----------------------------
  bool _isTextNegative(String text) {
    // ----------------------------------------------------------------
    // ADDED MORE KEYWORDS for negative detection
    // ----------------------------------------------------------------
    // Convert text to lowercase just in case
    final lowerText = text.toLowerCase();

    if (lowerText.contains('غبي') ||
            lowerText.contains('معاق') ||
            lowerText.contains('سلبي') ||
            lowerText.contains('كريه') || // ADDED
            lowerText.contains('سيء') || // ADDED
            lowerText.contains('مزعج') || // ADDED
            lowerText.contains('كره') // ADDED
        ) {
      return true;
    }
    return false;
  }

  bool _isTextPositive(String text) {
    // ----------------------------------------------------------------
    // ADDED MORE KEYWORDS for positive detection
    // ----------------------------------------------------------------
    final lowerText = text.toLowerCase();

    if (lowerText.contains('💚') ||
            lowerText.contains('إيجابي') ||
            lowerText.contains('❤️') ||
            lowerText.contains('رائع') || // ADDED
            lowerText.contains('جميل') || // ADDED
            lowerText.contains('احب') || // ADDED
            lowerText.contains('احبك') || // ADDED
            lowerText.contains('ممتاز') // ADDED
        ) {
      return true;
    }
    return false;
  }

  int _pointsForText(String text) {
    if (_isTextPositive(text)) {
      return 3;
    } else if (_isTextNegative(text)) {
      return -3;
    }
    return 0; // neutral
  }

  // ----------------------------
  // SHOW COMMENTS / REPLIES
  // ----------------------------
  void _showCommentsPopup(BuildContext context) {
    final TextEditingController _commentController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter localSetState) {
            final TextEditingController _replyController =
                TextEditingController();

            void _handleReply({
              required Comment parentComment,
              required String replyText,
            }) async {
              try {
                final result = await analyzeComment(replyText);
                if (result == "إيجابي") {
                  widget.onPointsChanged(5);
                  localSetState(() {
                    parentComment.replies.add(
                      Comment(
                        username: widget.personalInfo['name'],
                        profilePicture: 'assets/your_profile.png',
                        content: replyText,
                      ),
                    );
                  });
                  _showDialogMessage(
                    dialogContext,
                    title: 'تمت الإضافة',
                    content: 'تم إضافة ردك الإيجابي بنجاح.',
                  );
                } else if (result == "سلبي") {
                  widget.onPointsChanged(-5);
                  _showDialogMessage(
                    dialogContext,
                    title: 'رد سلبي',
                    content: 'ردك سلبي، يرجى تعديله ليكون أكثر إيجابية.',
                  );
                } else {
                  _showDialogMessage(
                    dialogContext,
                    title: 'رد محايد',
                    content: 'ردك محايد، يمكنك تحسينه ليكون أكثر إيجابية.',
                  );
                }
              } catch (e) {
                _showDialogMessage(
                  dialogContext,
                  title: 'خطأ',
                  content: 'فشل في تحليل الرد. الخطأ: $e',
                );
              }
            }

            return AlertDialog(
              title: const Text(
                'التعليقات',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 500,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _localComments.length,
                        itemBuilder: (context, index) {
                          final comment = _localComments[index];
                          return _buildCommentTile(
                            comment: comment,
                            localSetState: localSetState,
                            onReply: (String replyText) {
                              _handleReply(
                                parentComment: comment,
                                replyText: replyText,
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const Divider(),
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
                          icon: const Icon(Icons.send, color: Colors.blue),
                          onPressed: () async {
                            if (_commentController.text.isNotEmpty) {
                              final userComment = _commentController.text;
                              _commentController.clear();

                              try {
                                final result =
                                    await analyzeComment(userComment);

                                if (result == "إيجابي") {
                                  widget.onPointsChanged(5);
                                  localSetState(() {
                                    _localComments.add(
                                      Comment(
                                        username: widget.personalInfo['name'],
                                        profilePicture:
                                            'assets/your_profile.png',
                                        content: userComment,
                                      ),
                                    );
                                  });
                                  _showDialogMessage(
                                    dialogContext,
                                    title: 'تمت الإضافة',
                                    content: 'تم إضافة تعليقك الإيجابي بنجاح.',
                                  );
                                } else if (result == "سلبي") {
                                  widget.onPointsChanged(-5);
                                  _showDialogMessage(
                                    dialogContext,
                                    title: 'تعليق سلبي',
                                    content:
                                        'تعليقك سلبي، يرجى تعديله ليكون أكثر إيجابية.',
                                  );
                                } else {
                                  _showDialogMessage(
                                    dialogContext,
                                    title: 'تعليق محايد',
                                    content:
                                        'تعليقك محايد، يمكنك تحسينه ليكون أكثر إيجابية.',
                                  );
                                }
                              } catch (e) {
                                _showDialogMessage(
                                  dialogContext,
                                  title: 'خطأ',
                                  content: 'فشل في تحليل التعليق. الخطأ: $e',
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
                    Navigator.of(dialogContext).pop();
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

  /// Builds a single comment tile (with like, report, reply)
  Widget _buildCommentTile({
    required Comment comment,
    required StateSetter localSetState,
    required Function(String) onReply,
  }) {
    final TextEditingController _replyToCommentController =
        TextEditingController();

    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(comment.profilePicture),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                comment.username ?? 'Unknown',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  // Like button for this comment
                  IconButton(
                    icon: Icon(
                      comment.isCommentLiked
                          ? FontAwesomeIcons.solidHeart
                          : FontAwesomeIcons.heart,
                      color: comment.isCommentLiked ? Colors.red : Colors.grey,
                      size: 20,
                    ),
                    onPressed: () {
                      localSetState(() {
                        if (!comment.isCommentLiked) {
                          final points = _pointsForText(comment.content);
                          comment.commentLikePointsChange = points;
                          widget.onPointsChanged(points);
                          comment.isCommentLiked = true;
                        } else {
                          widget.onPointsChanged(
                            -comment.commentLikePointsChange,
                          );
                          comment.commentLikePointsChange = 0;
                          comment.isCommentLiked = false;
                        }
                      });
                    },
                  ),
                  // Report comment
                  IconButton(
                    icon: const Icon(
                      Icons.flag,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: () {
                      if (_isTextNegative(comment.content)) {
                        widget.onPointsChanged(10);
                      }
                    },
                  ),
                  // Reply to comment
                  IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.reply,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: const Text('الرد على التعليق'),
                            content: TextField(
                              controller: _replyToCommentController,
                              decoration: const InputDecoration(
                                hintText: 'اكتب ردك هنا...',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: const Text('إغلاق'),
                              ),
                              TextButton(
                                onPressed: () {
                                  final replyText =
                                      _replyToCommentController.text;
                                  _replyToCommentController.clear();
                                  Navigator.of(ctx).pop();

                                  if (replyText.isNotEmpty) {
                                    onReply(replyText);
                                  }
                                },
                                child: const Text('إرسال'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          subtitle: Text(comment.content),
        ),

        // Nested replies
        if (comment.replies.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: Column(
              children: comment.replies.map((subReply) {
                return _buildSubReplyTile(
                  parentComment: comment,
                  reply: subReply,
                  localSetState: localSetState,
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  /// Builds a tile for a sub-reply
  Widget _buildSubReplyTile({
    required Comment parentComment,
    required Comment reply,
    required StateSetter localSetState,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(reply.profilePicture),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            reply.username ?? 'Unknown',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  reply.isCommentLiked
                      ? FontAwesomeIcons.solidHeart
                      : FontAwesomeIcons.heart,
                  color: reply.isCommentLiked ? Colors.red : Colors.grey,
                  size: 18,
                ),
                onPressed: () {
                  localSetState(() {
                    if (!reply.isCommentLiked) {
                      final points = _pointsForText(reply.content);
                      reply.commentLikePointsChange = points;
                      widget.onPointsChanged(points);
                      reply.isCommentLiked = true;
                    } else {
                      widget.onPointsChanged(-reply.commentLikePointsChange);
                      reply.commentLikePointsChange = 0;
                      reply.isCommentLiked = false;
                    }
                  });
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.flag,
                  color: Colors.grey,
                  size: 18,
                ),
                onPressed: () {
                  if (_isTextNegative(reply.content)) {
                    widget.onPointsChanged(10);
                  }
                },
              ),
            ],
          ),
        ],
      ),
      subtitle: Text(reply.content),
    );
  }

  /// Utility method to show a simple dialog
  void _showDialogMessage(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('حسنًا'),
            ),
          ],
        );
      },
    );
  }

  // ----------------------------
  // POST (UI)
  // ----------------------------
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --------------------------
        // POST Header (User info)
        // --------------------------
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: AssetImage(widget.profilePicture),
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    widget.username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.more_vert),
            ],
          ),
        ),

        // --------------------------
        // POST Image (Double-tap to like)
        // --------------------------
        GestureDetector(
          onDoubleTap: () {
            setState(() {
              if (!isLiked) {
                final points = _pointsForText(widget.text);
                _likePointsChange = points;
                widget.onPointsChanged(points);
                isLiked = true;
                displayHeart = true;
              } else {
                // Unlike => revert
                widget.onPointsChanged(-_likePointsChange);
                _likePointsChange = 0;
                isLiked = false;
              }
            });

            if (isLiked) {
              Future.delayed(const Duration(milliseconds: 750), () {
                setState(() {
                  displayHeart = false;
                });
              });
            }
          },
          child: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                child: Image.asset(
                  widget.image,
                  fit: BoxFit.cover,
                ),
              ),
              if (displayHeart)
                SizedBox(
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

        // --------------------------
        // POST Actions
        // --------------------------
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Like button (single tap)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (!isLiked) {
                          final points = _pointsForText(widget.text);
                          _likePointsChange = points;
                          widget.onPointsChanged(points);
                          isLiked = true;
                        } else {
                          widget.onPointsChanged(-_likePointsChange);
                          _likePointsChange = 0;
                          isLiked = false;
                        }
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
                  // Comment button => show the popup with main comments
                  GestureDetector(
                    onTap: () {
                      _showCommentsPopup(context);
                    },
                    child: const Icon(FontAwesomeIcons.comment, size: 25.0),
                  ),
                  const SizedBox(width: 15.0),
                  // Share button (placeholder)
                  const Icon(FontAwesomeIcons.paperPlane, size: 25.0),
                ],
              ),
              // Bookmark button (placeholder)
              const Icon(FontAwesomeIcons.bookmark, size: 25.0),
            ],
          ),
        ),

        // --------------------------
        // POST Likes Count
        // --------------------------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            '${widget.likes} إعجابات',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
        ),

        // --------------------------
        // POST Text
        // --------------------------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Text(
            widget.text,
            style: const TextStyle(fontSize: 14.0),
          ),
        ),

        // --------------------------
        // POST Time
        // --------------------------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Text(
            'منذ ${widget.time}',
            style: const TextStyle(fontSize: 12.0, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
