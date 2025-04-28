import 'package:flutter/material.dart';
import 'package:insta/Models/CommentModel.dart';

import '../Models/User.dart';

class CommentWidget extends StatefulWidget {
  User user;
  CommentModel comment;
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
      color: Colors.black,
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 15,
            children: [
              CircleAvatar(backgroundImage: NetworkImage(widget.user.pfpPath!),radius: 20,),
              Text(widget.user.username)
            ],
          ),
          CommentText(text: widget.comment.content),
          // GestureDetector(
          //   child: Text("Replies",style: TextStyle(fontWeight: FontWeight.bold,),),
          //   onTap:(){
          //     Navigator.of(context).push(
          //         MaterialPageRoute(builder: (context) {
          //           return RepliesPage(commentId: 0, user: widget.user, comment: widget.comment);
          //         },)
          //     );
          //   },
          // ),
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