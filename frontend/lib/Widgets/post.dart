import 'package:flutter/material.dart';
import 'package:insta/Models/PostModel.dart';

class Post extends StatefulWidget {
  PostModel _post;
  bool? inProfilePage = false;
  Post({
    super.key,
    required post,
    this.inProfilePage
  }) : _post = post;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  void handleCommentClick() {

    Navigator.of(context).pushNamed('/postPage', arguments: widget._post);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.purpleAccent.withOpacity(0.3),
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if(widget.inProfilePage != true){
                      Map<String, dynamic> args = {'userId': widget._post.user?.userId};
                      Navigator.of(context).pushNamed('/profilePage', arguments: args);
                    } else {
                      return; //you cannot navigate to the profile from the profile
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.purpleAccent,
                        width: 1,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundImage: (widget._post.user?.pfpPath != null) ? NetworkImage(widget._post.user!.pfpPath!) : null,
                      radius: 20,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: (widget._post.user?.pfpPath == null) ? Text(widget._post.user!.name![0], style: TextStyle(color: Colors.white)) : null,
                    ),
                  )
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget._post.user!.name!,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      '@${widget._post.user?.username}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13.0),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            child: (widget._post.description != null) ? PostText(text: widget._post.description!) : null,
          ),

          Container(
            child: (widget._post.imageUrl != null) ? Image.network(
              widget._post.imageUrl!,
              fit: BoxFit.fitWidth,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: Icon(Icons.error),
                );
              },
            ) : null,
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Icon(Icons.favorite_border),
                    SizedBox(width: 4),
                    Text(widget._post.likeAmount.toString()),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: handleCommentClick,
                      child: Icon(Icons.comment_rounded),
                    ),
                    SizedBox(width: 4),
                    Text(widget._post.commentAmount.toString()),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 4),
                    Text("share"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PostText extends StatefulWidget {
  String text;
  PostText({super.key, required this.text});

  @override
  State<PostText> createState() => _PostTextState();
}

class _PostTextState extends State<PostText> {
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    if (widget.text.length < 200) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
        child: Text(widget.text),
      );
    }
    if (showAll) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.text),
            GestureDetector(
              onTap: () {
                setState(() {
                  showAll = !showAll;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  "Show less",
                  style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text.substring(0, 200) + '...',
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  showAll = !showAll;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  "Show more",
                  style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}