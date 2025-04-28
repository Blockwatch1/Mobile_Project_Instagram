import 'package:flutter/material.dart';
import 'package:insta/Models/CommentModel.dart';
import 'Widgets/Comment.dart';
import 'replies.dart';
import 'Models/User.dart';
class CommentList extends StatefulWidget {
  CommentList({super.key,required this.comments});
  List<dynamic>comments;
  @override
  State<CommentList> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentList> {
  TextEditingController _commentController = TextEditingController();
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(title: Text("Comments"),),
          body: ListView.builder(
            itemCount: widget.comments?.length,
            itemBuilder: (context, index) {
              final Map<String, dynamic> commentData = widget.comments![index];
              Map<String, dynamic> counts = {
                'replies': commentData['replies']
              };

              final Map<String, dynamic> userInfo = commentData['user'];
              final user = User.fromJson(userInfo);

              CommentModel comment = CommentModel(
                postId: commentData['postId'],
                content: commentData['content'],
                isReply: commentData['isReply'],
                commentId: commentData['commentId'],
                user: user,
                replyAmount: counts['replies'],
                isEdited: commentData['isEdited'],
              );


              return CommentWidget(user: user, comment: comment);
            },
          ),
          bottomNavigationBar:  BottomCommentTextField(commentController: _commentController),
        ),
      ),
    );
  }
}

class BottomCommentTextField extends StatefulWidget {
  BottomCommentTextField({
    super.key,
    required TextEditingController commentController,
  }) : _commentController = commentController;

  final TextEditingController _commentController;
  FocusNode _commentFocusNode = FocusNode();
  @override
  State<BottomCommentTextField> createState() {
    return _CommentTextFieldState();
  }

}
class _CommentTextFieldState extends State<BottomCommentTextField>{
  double bottomMargin= 0;
  Widget build(BuildContext context) {
    bottomMargin=  8.0 + MediaQuery.of(context).viewInsets.bottom;
    return  Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 12.0,
          bottom: bottomMargin
      ),
      child: GestureDetector(
        child: TextField(
          onTap: (){
            setState(() {
              bottomMargin=  8.0 + MediaQuery.of(context).viewInsets.bottom;
            });
          },
          focusNode: widget._commentFocusNode,
          autofocus:true,
          keyboardType: TextInputType.text,
          controller: widget._commentController,
          decoration: InputDecoration(
            hintText: 'Add a comment...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            suffixIcon: IconButton(
              icon: Icon(Icons.send, color: Colors.blueAccent),
              onPressed: () {
                String commentText = widget._commentController.text;
                if (commentText.isNotEmpty) {
                  widget._commentController.clear();
                  FocusScope.of(context).unfocus();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}