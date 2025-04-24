import 'package:flutter/material.dart';

class picture_widget extends StatefulWidget {
  final String? profile_picture;
  final String? profile_picture_null='';
  final String source;
  final String name;
  final int likes;
  final int comments;

const picture_widget({
  super.key,
  this.profile_picture,
  required this.source,
  required this.name,
  required this.likes,
  required this.comments
 });


  @override
  State<picture_widget> createState() => _picture_widgetState();

}


class _picture_widgetState extends State<picture_widget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network("", height:30, width:30),
            Text(widget.name,style:TextStyle(fontSize: 30)),
          ],
        ),
        Image.network(widget.source, height:300, width:300),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.favorite_border),
            Text(widget.likes.toString(), style: TextStyle(fontSize:20),),
            Icon(Icons.comment),
            Text(widget.comments.toString(), style: TextStyle(fontSize:20),),
            Icon(Icons.send),
            SizedBox(width:30),
            Icon(Icons.save)
          ],
        )
      ],
    );

  }

}
