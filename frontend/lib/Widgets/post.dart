import 'package:flutter/material.dart';
import 'package:insta/Models/PostModel.dart';
import 'package:timeago/timeago.dart' as timeago;

class Post extends StatefulWidget {
  final PostModel _post;
  final bool? inProfilePage;

  const Post({
    super.key,
    required PostModel post,
    this.inProfilePage = false,
  }) : _post = post;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  bool isLiked = false;
  bool isSaved = false;

  void handleCommentClick() {
    Navigator.of(context).pushNamed('/postPage', arguments: widget._post);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(widget.inProfilePage == true ? 0 : 12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header with User Info
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if(widget.inProfilePage != true){
                      Map<String, dynamic> args = {'userId': widget._post.user?.userId};
                      Navigator.of(context).pushNamed('/profilePage', arguments: args);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.purpleAccent,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purpleAccent.withOpacity(0.2),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundImage: (widget._post.user?.pfpPath != null)
                          ? NetworkImage(widget._post.user!.pfpPath!)
                          : null,
                      radius: 20,
                      backgroundColor: Colors.purpleAccent.withOpacity(0.5),
                      child: (widget._post.user?.pfpPath == null)
                          ? Text(
                        widget._post.user!.name!.isNotEmpty
                            ? widget._post.user!.name![0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                          : null,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget._post.user!.name!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '@${widget._post.user?.username}',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 13.0,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert, color: Colors.grey[400]),
                  onPressed: () {
                    // Show options menu
                  },
                ),
              ],
            ),
          ),

          // Post Description
          if (widget._post.description != null)
            PostText(text: widget._post.description!),

          // Post Image
          if (widget._post.imageUrl != null)
            Container(
              constraints: BoxConstraints(
                maxHeight: 400,
              ),
              width: double.infinity,
              child: ClipRRect(
                borderRadius: widget._post.description == null
                    ? BorderRadius.vertical(top: Radius.circular(widget.inProfilePage == true ? 0 : 12))
                    : BorderRadius.zero,
                child: Image.network(
                  widget._post.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[800],
                      child: Center(
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.grey[400],
                          size: 40,
                        ),
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 200,
                      color: Colors.grey[800],
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.purpleAccent,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          // Post Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Like Button
                    IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.purpleAccent : Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          isLiked = !isLiked;
                        });
                      },
                    ),
                    Text(
                      widget._post.likeAmount.toString(),
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(width: 16),

                    // Comment Button
                    IconButton(
                      icon: Icon(Icons.chat_bubble_outline),
                      onPressed: handleCommentClick,
                    ),
                    Text(
                      widget._post.commentAmount.toString(),
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                // Save Button
                IconButton(
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: isSaved ? Colors.purpleAccent : Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      isSaved = !isSaved;
                    });
                  },
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
  final String text;
  const PostText({super.key, required this.text});

  @override
  State<PostText> createState() => _PostTextState();
}

class _PostTextState extends State<PostText> {
  bool showAll = false;
  final int maxLength = 150;

  @override
  Widget build(BuildContext context) {
    if (widget.text.length <= maxLength) {
      return _buildTextContainer(widget.text, false);
    }

    if (showAll) {
      return _buildTextContainer(
        widget.text,
        true,
        actionText: "Show less",
      );
    } else {
      return _buildTextContainer(
        widget.text.substring(0, maxLength) + '...',
        true,
        actionText: "Show more",
      );
    }
  }

  Widget _buildTextContainer(String text, bool hasAction, {String? actionText}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1.4,
            ),
          ),
          if (hasAction && actionText != null)
            GestureDetector(
              onTap: () {
                setState(() {
                  showAll = !showAll;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  actionText,
                  style: TextStyle(
                    color: Colors.purpleAccent,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}