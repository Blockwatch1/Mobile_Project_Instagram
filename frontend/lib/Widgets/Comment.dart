import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:insta/Models/ActionResponse.dart';
import 'package:insta/Models/CommentModel.dart';
import 'package:insta/Services/CommentService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/User.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentWidget extends StatefulWidget {
  final User user;
  final CommentModel comment;
  final Function deleteComment;

  const CommentWidget({
    super.key,
    required this.user,
    required this.comment,
    required this.deleteComment
  });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  dynamic _myUserId;
  bool _isLiked = false;
  CommentService _commentService = CommentService();
  String? _token;
  bool _loading = false;

  Future<void> _getMyUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');

    String? token = prefs.getString('token');
    if(token != null) {
      setState(() {
        _token = prefs.getString('token');
      });
    }

    if(user != null){
      Map<String, dynamic> userDecoded = jsonDecode(user);
      setState(() {
        _myUserId = userDecoded['userId'];
      });
    }
  }

  void _isLikedByUser() {

  }

  Future<void> _likeComment() async {

  }

  Future<void> _deleteComment() async {
    setState(() {
      _loading = true;
    });
    try {
        if(widget.comment.commentId != null) {
          ActionResponse delete = await _commentService.DELETE_NO_BODY('${widget.comment.commentId}', _token);

          if(delete.success) {
            setState(() {
              _loading = false;
            });
            widget.deleteComment(widget.comment.commentId);
          }
        } else {
          setState(() {
            _loading = false;
          });
          print("Comment Id needed!\n");
        }
    } catch(e) {
      setState(() {
        _loading = false;
      });
      throw e;
    }
  }

  @override
  void initState(){
    super.initState();
    _getMyUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Avatar
          Container(
            margin: EdgeInsets.only(right: 12, top: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.purpleAccent.withOpacity(0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.purpleAccent.withOpacity(0.1),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                // Navigate to user profile
                Map<String, dynamic> args = {'userId': widget.user.userId};
                Navigator.of(context).pushNamed('/profilePage', arguments: args);
              },
              child: CircleAvatar(
                backgroundImage: (widget.user.pfpPath != null && widget.user.pfpPath!.isNotEmpty)
                    ? NetworkImage(widget.user.pfpPath!)
                    : null,
                child: (widget.user.pfpPath == null || widget.user.pfpPath!.isEmpty)
                    ? Text(
                  widget.user.name!.isNotEmpty ? widget.user.name![0].toUpperCase() : '?',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
                    : null,
                radius: 20,
                backgroundColor: Colors.purpleAccent.withOpacity(0.3),
              ),
            ),
          ),

          // Comment Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username and timestamp
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate to user profile
                        Map<String, dynamic> args = {'userId': widget.user.userId};
                        Navigator.of(context).pushNamed('/profilePage', arguments: args);
                      },
                      child: Text(
                        widget.user.username ?? widget.user.name ?? "User",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (widget.comment.isEdited!)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "• edited",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    Spacer(),
                    // Options menu
                    IconButton(
                      icon: Icon(
                        Icons.more_horiz,
                        color: Colors.grey[400],
                        size: 18,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Color(0xFF1E1E1E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          builder: (context) => _buildCommentOptions(),
                        );
                      },
                      constraints: BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),

                SizedBox(height: 4),

                // Comment Text
                CommentText(text: widget.comment.content),

                SizedBox(height: 8),

                // Comment Actions
                Row(
                  children: [
                    // Like button
                    GestureDetector(
                      onTap: () {
                        _likeComment();
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 16,
                            color: Colors.grey[400],
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Like",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 16),

                    // Reply button
                    GestureDetector(
                      onTap: () {
                        // Navigate to replies
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(builder: (context) {
                        //     return RepliesPage(commentId: 0, user: widget.user, comment: widget.comment);
                        //   })
                        // );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.reply,
                            size: 16,
                            color: Colors.grey[400],
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Reply${widget.comment.replyAmount !> 0 ? ' (${widget.comment.replyAmount})' : ''}",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Spacer(),

                    // Timestamp using timeago
                    Text(
                      timeago.format(DateTime.parse(widget.comment.createdAt!)),
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentOptions() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.reply, color: Colors.white),
            title: Text(
              'Reply to comment',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              // Reply functionality
            },
          ),
          if (widget.user.userId == _myUserId)
            ListTile(
              leading: Icon(Icons.edit, color: Colors.white),
              title: Text(
                'Edit comment',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                // Edit functionality
              },
            ),
          if (widget.user.userId == _myUserId)
            ListTile(
              leading: _loading ? const CircularProgressIndicator() : Icon(Icons.delete, color: Colors.red),
              title: Text(
                'Delete comment',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _deleteComment();
              },
            ),
          ListTile(
            leading: Icon(Icons.flag, color: Colors.white),
            title: Text(
              'Report comment',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              // Report functionality
            },
          ),
        ],
      ),
    );
  }
}

class CommentText extends StatefulWidget {
  final String text;

  const CommentText({super.key, required this.text});

  @override
  State<CommentText> createState() => _CommentTextState();
}

class _CommentTextState extends State<CommentText> {
  bool showAll = false;
  final int maxLength = 200;

  @override
  Widget build(BuildContext context) {
    if (widget.text.length < maxLength) {
      return _buildCommentBubble(widget.text, false);
    }

    if (showAll) {
      return _buildCommentBubble(
        widget.text,
        true,
        showLessButton: true,
      );
    } else {
      return _buildCommentBubble(
        widget.text.substring(0, maxLength) + '...',
        true,
        showMoreButton: true,
      );
    }
  }

  Widget _buildCommentBubble(
      String text,
      bool hasAction, {
        bool showMoreButton = false,
        bool showLessButton = false,
      }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Color(0xFF2A2A2A),
        border: Border.all(
          color: Colors.purpleAccent.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          if (hasAction)
            GestureDetector(
              onTap: () {
                setState(() {
                  showAll = !showAll;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  showMoreButton ? "Show more" : "Show less",
                  style: TextStyle(
                    color: Colors.purpleAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
