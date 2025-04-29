import 'package:flutter/material.dart';
import 'package:insta/Models/PostModel.dart';
import 'package:insta/Models/User.dart';
import 'package:insta/Widgets/post.dart';

class PostSection extends StatelessWidget {
  final List<dynamic> _posts;
  final User _user;
  const PostSection({super.key, required posts, required user})
      : _posts = posts,
        _user = user;

  @override
  Widget build(BuildContext context) {
    if (_posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 60,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              "No posts yet",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: _posts.length,
      itemBuilder: (BuildContext context, int index) {
        Map<String, dynamic> counts = {
          'likes': _posts[index]['_count']['likedUsers'],
          'saves': _posts[index]['_count']['savedUsers'],
          'comments': _posts[index]['_count']['comments'],
        };

        dynamic postId = _posts[index]['postId'];
        String? description = _posts[index]['description'];
        String? imageUrl = _posts[index]['imageUrl'];

        PostModel post = PostModel(
          postId: postId,
          likeAmount: counts['likes'],
          saveAmount: counts['saves'], // Fixed this from 'likes' to 'saves'
          commentAmount: counts['comments'],
          user: _user,
          imageUrl: imageUrl,
          description: description,
        );

        return Container(
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Post(post: post, inProfilePage: true),
          ),
        );
      },
    );
  }
}