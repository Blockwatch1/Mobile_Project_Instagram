import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:insta/Models/ActionResponse.dart';
import 'package:insta/Models/PostModel.dart';
import 'package:insta/Services/PostService.dart';
import 'package:insta/Services/UserService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

class Post extends StatefulWidget {
  final PostModel _post;
  final bool? inProfilePage;

  const Post({
    super.key,
    required PostModel post,
    this.inProfilePage = false,
  }) : _post = post;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  bool isLiked = false;
  bool isSaved = false;
  UserService _service = UserService();
  PostService _postService = PostService();

  dynamic _myUserId;
  String? _token;

  int? _likeAmount = 0;
  int? _saveAmount = 0;

  bool _loading = false;

  void handleCommentClick() {
    Navigator.of(context).pushNamed('/postPage', arguments: widget._post);
  }

  Future<void> _setMyUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userJson = prefs.getString('user');

    String? token = prefs.getString('token');
    if(token != null) {
      setState(() {
        _token = token;
      });
    }

    if(userJson != null) {
      Map<String, dynamic> userData = jsonDecode(userJson);
      setState(() {
        _myUserId = userData['userId'];
      });
    }

  }

  Future<void> _likedSavedPost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonUserInfo = prefs.getString('user');
    dynamic myUserId;

    if(jsonUserInfo != null) {
      Map<String, dynamic> userInfoDecoded = jsonDecode(jsonUserInfo);
      myUserId = userInfoDecoded['userId'];
    } else {
      return;
    }

    try {
      //check for likes
      print('POST NUMBER ${widget._post.postId}');
      if(widget._post.likedUsers != null) {
      print('${widget._post.postId} has liked users');
        if(widget._post.likedUsers!.length >= 1) {
          print('${widget._post.postId} has length');
          for(Map<String, dynamic> user in widget._post.likedUsers!){
            if(user['userId'] == myUserId){
              setState(() {
                isLiked = true;
              });

              break;
            }
          }
        }

      }

      if(widget._post.savedUsers != null) {

        if(widget._post.savedUsers!.length >= 1) {
          for(Map<String, dynamic> user in widget._post.savedUsers!){
            if(user['userId'] == myUserId){
              setState(() {
                isSaved = true;
              });

              break;
            }
          }
        }

      }

    } catch(e) {
      throw e;
    }
  }

  Future<void> _likeUnlikePost(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    
    if(type == 'Like') {
      ActionResponse like = await _service.putNoBody('like-post/${widget._post.postId}', token);

      if(like.success) {
        print('Liked!');
      }
    } else {
      ActionResponse unlike = await _service.putNoBody('unlike-post/${widget._post.postId}', token);

      if(unlike.success) {
        print('Liked!');
      }
    }
  }

  Future<void> _deletePost() async {
    setState(() {
      _loading = true;
    });
    try {
      ActionResponse delete_post = await _postService.deleteNoBody('delete-post/${widget._post.postId}', _token);

      if(delete_post.success) {
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${delete_post.message}')),
        );
      }
    } catch(e) {
      setState(() {
        _loading = false;
      });
      throw e;
    }
  }

  void _handleDeletePost() {
    _deletePost();
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  void initState() {
    super.initState();
    _setMyUserId();
    setState(() {
      _likeAmount = widget._post.likeAmount;
      _saveAmount = widget._post.saveAmount;
    });
    _likedSavedPost();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(widget.inProfilePage == true ? 0 : 12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header with User Info
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if(widget.inProfilePage != true){
                      Map<String, dynamic> args = {'userId': widget._post.user?.userId};
                      Navigator.of(context).pushNamed('/profilePage', arguments: args);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.purpleAccent,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purpleAccent.withOpacity(0.2),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundImage: (widget._post.user?.pfpPath != null)
                          ? NetworkImage(widget._post.user!.pfpPath!)
                          : null,
                      radius: 20,
                      backgroundColor: Colors.purpleAccent.withOpacity(0.5),
                      child: (widget._post.user?.pfpPath == null)
                          ? Text(
                        widget._post.user!.name!.isNotEmpty
                            ? widget._post.user!.name![0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                          : null,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget._post.user!.name!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '@${widget._post.user?.username}',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 13.0,
                        ),
                      ),
                    ],
                  ),
                ),
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
                      builder: (context) => Container(
                         padding: EdgeInsets.symmetric(vertical: 16),
                         child: Column(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             ListTile(
                               leading: Icon(Icons.share),
                               title: Text("Share"),
                             ),

                             if(widget._post.user!.userId == _myUserId)
                               _loading ? const CircularProgressIndicator() : ListTile(leading: IconButton(onPressed: () => _handleDeletePost(), icon: Icon(Icons.delete, color: Colors.red,)), title: Text("Delete"),),
                           ],
                         ),
                       ),
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
          ),

          // Post Description
          if (widget._post.description != null)
            PostText(text: widget._post.description!),

          // Post Image
          if (widget._post.imageUrl != null)
            Container(
              constraints: BoxConstraints(
                maxHeight: 400,
              ),
              width: double.infinity,
              child: ClipRRect(
                borderRadius: widget._post.description == null
                    ? BorderRadius.vertical(top: Radius.circular(widget.inProfilePage == true ? 0 : 12))
                    : BorderRadius.zero,
                child: Image.network(
                  widget._post.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[800],
                      child: Center(
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.grey[400],
                          size: 40,
                        ),
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 200,
                      color: Colors.grey[800],
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.purpleAccent,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          // Post Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Like Button
                    IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.purpleAccent : Colors.white,
                      ),
                      onPressed: () {
                        if(isLiked) {
                          setState(() {
                            isLiked = false;
                            _likeAmount = _likeAmount !- 1;
                          });
                          _likeUnlikePost('Unlike');
                        } else {
                          setState(() {
                            isLiked = true;
                            _likeAmount = _likeAmount !+ 1;
                          });
                          _likeUnlikePost('Like');
                        }
                      },
                    ),
                    Text(
                      _likeAmount.toString(),
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(width: 16),

                    // Comment Button
                    IconButton(
                      icon: Icon(Icons.chat_bubble_outline),
                      onPressed: handleCommentClick,
                    ),
                    Text(
                      widget._post.commentAmount.toString(),
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                // Save Button
                IconButton(
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: isSaved ? Colors.purpleAccent : Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      isSaved = !isSaved;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildCommentOptions(Function deletePost, bool loading) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(vertical: 16),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         ListTile(
  //           leading: Icon(Icons.share),
  //           title: Text("Share"),
  //         ),
  //
  //         if(widget._post.user!.userId == _myUserId)
  //           loading ? const CircularProgressIndicator() : ListTile(leading: IconButton(onPressed: () => deletePost, icon: Icon(Icons.delete, color: Colors.red,)), title: Text("Delete"),),
  //       ],
  //     ),
  //   );
  // }
}

class PostText extends StatefulWidget {
  final String text;
  const PostText({super.key, required this.text});

  @override
  State<PostText> createState() => _PostTextState();
}

class _PostTextState extends State<PostText> {
  bool showAll = false;
  final int maxLength = 150;

  @override
  Widget build(BuildContext context) {
    if (widget.text.length <= maxLength) {
      return _buildTextContainer(widget.text, false);
    }

    if (showAll) {
      return _buildTextContainer(
        widget.text,
        true,
        actionText: "Show less",
      );
    } else {
      return _buildTextContainer(
        widget.text.substring(0, maxLength) + '...',
        true,
        actionText: "Show more",
      );
    }
  }

  Widget _buildTextContainer(String text, bool hasAction, {String? actionText}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1.4,
            ),
          ),
          if (hasAction && actionText != null)
            GestureDetector(
              onTap: () {
                setState(() {
                  showAll = !showAll;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  actionText,
                  style: TextStyle(
                    color: Colors.purpleAccent,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

