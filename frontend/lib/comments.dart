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
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(widget.comments == null || widget.comments!.isEmpty) {
      return _noCommentsBuilder();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.comments!.length,
      itemBuilder: (context, index) {
        final Map<String, dynamic> commentData = widget.comments![index];
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
        );


        return CommentWidget(user: user, comment: comment);
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

