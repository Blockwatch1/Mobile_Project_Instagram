import 'package:flutter/material.dart';
import 'package:insta/Models/CommentModel.dart';
import 'Widgets/Comment.dart';
import 'replies.dart';
import 'Models/User.dart';
class CommentList extends StatefulWidget {
  List<dynamic>? comments;
  CommentList({super.key,required this.comments});

  @override
  State<CommentList> createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentList> {
  List<dynamic>? _comments;

  void _setComments() {
    setState(() {
      _comments = widget.comments;
    });
  }

  void _deleteComment(dynamic commentId) {
    if(_comments != null){
      Iterable<dynamic> filteredNumbers = _comments!.where((comment) => comment['commentId'] != commentId);
      List<dynamic> newList = filteredNumbers.toList();
      setState(() {
        _comments = newList;
      });
    }

    return;
  }

  void initState() {
    super.initState();
    _setComments();
  }

  @override
  Widget build(BuildContext context) {
    if(_comments == null || _comments!.isEmpty) {
      return _noCommentsBuilder();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _comments!.length,
      itemBuilder: (context, index) {
        final Map<String, dynamic> commentData = _comments![index];
        Map<String, dynamic> counts = {
          'replies': commentData['replies']
        };

        final Map<String, dynamic> userInfo = commentData['user'];
        final user = User.fromJson(userInfo);

        CommentModel comment = CommentModel(
          postId: commentData['postId'],
          content: commentData['content'] ?? "Could not load comment content",
          isReply: commentData['isReply'] ?? false,
          commentId: commentData['commentId'] ?? 0,
          user: user,
          replyAmount: counts['replies'] ?? 0,
          isEdited: commentData['isEdited'] ?? false,
          createdAt: commentData['createdAt'] ?? '',
          updatedAt: commentData['updatedAt'] ?? '',
        );


        return CommentWidget(user: user, comment: comment, deleteComment: _deleteComment,);
      },
    );
  }

  Widget _noCommentsBuilder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.comment,
            size: 70,
            color: Colors.grey[700],
          ),
          SizedBox(height: 16),
          Text(
            "Post a comment",
            style: TextStyle(
              color: Colors.purpleAccent,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: "Insta",
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Start socializing with others!",
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

