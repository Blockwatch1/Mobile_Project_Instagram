import 'package:flutter/material.dart';
import '../Models/User.dart';

class Post extends StatefulWidget {
  User user;
  String image;
  String? description;
  int commentCount;
  int likeAmount;
  int saveAmount;
  Post({
    super.key,
    required this.user,
    required this.image,
    required this.commentCount,
    required this.likeAmount,
    required this.saveAmount,
    this.description
  });

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  void handleCommentClick() {
    Navigator.of(context).pushNamed('/postPage');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.0),
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
                  CircleAvatar(
                    backgroundImage: (widget.user.pfpPath != null && widget.user.pfpPath!.isNotEmpty) ? NetworkImage(widget.user.pfpPath!) : null,
                    child: (widget.user.pfpPath == null || widget.user.pfpPath!.isEmpty) ? Text(widget.user.name.isNotEmpty ? widget.user.name[0].toUpperCase() : '', style: TextStyle(color: Colors.white)) : null,
                    radius: 20,
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.name,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        '@${widget.user.username}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13.0),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              child: (widget?.description != null) ? PostText(text: widget.description!) : null,
            ),

            Image.network(
              widget.image,
              fit: BoxFit.fitWidth,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: Icon(Icons.error),
                );
              },
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
                      Text(widget.likeAmount.toString()),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: handleCommentClick,
                        child: Icon(Icons.comment_rounded),
                      ),
                      SizedBox(width: 4),
                      Text(widget.commentCount.toString()),
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