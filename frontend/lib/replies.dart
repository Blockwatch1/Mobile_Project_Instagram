import 'package:flutter/material.dart';
import 'Models/User.dart';
import 'comments.dart';
class RepliesPage extends StatefulWidget {
  int commentId;
  String comment;
  User user;
  RepliesPage({super.key,required this.commentId,required this.user,required this.comment});

  @override
  State<RepliesPage> createState() => _RepliesPageState();
}

class _RepliesPageState extends State<RepliesPage> {
  List<CommentWidget> currentReplies =[];
  TextEditingController _replyController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(57, 62, 70, 1),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(title: Text("Replies"),),
          body: Column(
            children: [
              CommentWidgetAtReplyPage(user: widget.user, comment: widget.comment),
            ],
          ),
          bottomNavigationBar:  BottomCommentTextField(commentController: _replyController),
        ),
      ),
    );
  }
}
class CommentWidgetAtReplyPage extends StatefulWidget {
  User user;
  String comment;
  CommentWidgetAtReplyPage({super.key,required this.user,required this.comment});

  @override
  State<CommentWidgetAtReplyPage> createState() => _CommentWidgetStateAtReply();
}

class _CommentWidgetStateAtReply extends State<CommentWidgetAtReplyPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      width: double.infinity,
      color: Color.fromRGBO(61,54, 92, 1),
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 15,
            children: [
              CircleAvatar(backgroundImage: NetworkImage(widget.user.profilePicUrl),radius: 20,),
              Text(widget.user.username)
            ],
          ),
          CommentText(text: widget.comment),
        ],
      ) ,
    );
  }
}
