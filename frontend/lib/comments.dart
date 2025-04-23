import 'package:flutter/material.dart';
import 'User.dart';
class CommentsPage extends StatefulWidget {
  CommentsPage({super.key,required this.comments});
  Map<User,String> comments;
  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  List<CommentWidget> currentComments =[];
  TextEditingController _commentController = TextEditingController();
  void initState() {
    super.initState();
    widget.comments.forEach((user, comment) {
      currentComments.add(CommentWidget(user: user, comment: comment));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(57, 62, 70, 1),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: Text("Comments"),),
          body: ListView(
            children:currentComments,
          ),
            bottomNavigationBar:  BottomCommentTextField(commentController: _commentController),
        ),
      ),
    );
  }
}

class BottomCommentTextField extends StatelessWidget {
  BottomCommentTextField({
    super.key,
    required TextEditingController commentController,
  }) : _commentController = commentController;

  final TextEditingController _commentController;
  FocusNode _commentFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return  Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 8.0,
          bottom: 8.0 + MediaQuery.of(context).padding.bottom // Add padding to account for system intrusions like the home bar on iOS
      ),
      child: TextField(
          focusNode: _commentFocusNode,
          autofocus:true,
          keyboardType: TextInputType.text,
          controller: _commentController,
          decoration: InputDecoration(
            hintText: 'Add a comment...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            suffixIcon: IconButton(
              icon: Icon(Icons.send, color: Colors.blueAccent),
              onPressed: () {
                String commentText = _commentController.text;
                if (commentText.isNotEmpty) {
                  print('Sending comment: $commentText');
                  _commentController.clear();
                  FocusScope.of(context).unfocus();
                }
              },
            ),
          ),
      ),
    );
  }
}
class CommentWidget extends StatefulWidget {
  User user;
  String comment;
  CommentWidget({super.key,required this.user,required this.comment});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      width: double.infinity,
      color: Color.fromRGBO(82, 5, 123, 1),
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
          Text("Reply",style: TextStyle(fontWeight: FontWeight.bold,),),
        ],
      ) ,
    );
  }
}
class CommentText extends StatefulWidget {
  String text;
  CommentText({super.key,required this.text});
  @override
  State<CommentText> createState() => _CommentTextState();
}
class _CommentTextState extends State<CommentText> {
  bool showAll=false;
  @override
  Widget build(BuildContext context) {
    if(widget.text.length<200){
      return Container(width: double.infinity,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color.fromRGBO(57,62,70,1)
        ),
        child: Text(widget.text),
      );
    }
    if(showAll) {
      return Container(width: double.infinity,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color.fromRGBO(57,62,70,1)
        ),
        child: Column(
          children: [
            Text(widget.text),
            GestureDetector(
              onTap: (){
                setState(() {
                  showAll=!showAll;
                });
              },
              child: Text("Show less", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold ),),
            )
          ],
        ),
      );
    }else{
      return Container(width: double.infinity,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(bottom: 3),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color.fromRGBO(57,62,70,1)
          ),
          child: Column(
            children: [
              Text(widget.text.substring(0,200)),
              GestureDetector(
                onTap: (){
                  setState(() {
                    showAll=!showAll;
                  });
                },
                child: Text("Show more", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold ),),
              )
            ],
          )
      );
    }
  }
}


