import 'package:flutter/material.dart';
import 'package:insta/Models/PostModel.dart';
import 'package:insta/Models/User.dart';
import 'package:insta/Widgets/post.dart';

class PostSection extends StatelessWidget {
  final List<dynamic> _posts;
  final User _user;
  const PostSection({super.key, required posts, required user}) : _posts = posts, _user = user;

  @override
  Widget build(BuildContext context) {

    return ListView.builder(

      itemCount: _posts.length,
      itemBuilder: (BuildContext context, int index) {

        Map<String, dynamic> counts = {
          'likes': _posts[index]['_count']['likedUsers'],
          'saves': _posts[index]['_count']['savedUsers'],
          'comments': _posts[index]['_count']['comments'],
        };

        dynamic postId = _posts[index]['postId'];
        String description = _posts[index]['description'];
        String imageUrl = _posts[index]['imageUrl'];

        PostModel post = PostModel(
          postId: postId,
          likeAmount: counts['likes'],
          saveAmount: counts['likes'],
          commentAmount: counts['comments'],
          user: _user,
          imageUrl: imageUrl,
          description: description,
        );
        return Post(post: post);
      },
    );
  }
}
