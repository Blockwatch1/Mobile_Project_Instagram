import 'package:flutter/material.dart';
class Post extends StatefulWidget {
  String user;
  String image;
  Map<String,String>comments;
  int likeAmount;
  Post({super.key,required this.user,required this.image,required this.comments,required this.likeAmount});
  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width : double.infinity,
      child: Expanded(
        child: Column(
          children: [
            Container(
              height: 100,
              child: Expanded(child: Row(
                children: [
                  SizedBox(width:20),
                  CircleAvatar(backgroundImage: NetworkImage("https://static.tvtropes.org/pmwiki/pub/images/b76t_vciaaejpb2.jpg"),radius: 20,),
                  SizedBox(width:40),
                  Text(widget.user)
                ],
              )),
            ),

               Container(
                 width: double.infinity,
                 child: Image.network("https://static.wikia.nocookie.net/frieren/images/6/6c/Frieren%27s_appearance_in_the_past_%28anime%29.png/revision/latest/scale-to-width-down/1000?cb=20240419001431",fit: BoxFit.fitWidth,),
               ),

            Container(
              height: 100,
              child: Expanded(
                child: Row(
                  spacing: 100,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_border),
                        Text(widget.likeAmount.toString())
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.comment_rounded),
                        Text(widget.comments.length.toString())
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.share),
                        Text("share")
                      ],
                    ),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
