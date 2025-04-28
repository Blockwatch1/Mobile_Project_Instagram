import 'package:flutter/material.dart';
import 'package:insta/Models/ActionResponse.dart';
import 'package:insta/Models/PostModel.dart';
import 'package:insta/Services/PostService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Widgets/post.dart';
import 'Models/User.dart';

class PostList extends StatefulWidget {
  const PostList({super.key});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  List<dynamic>? _posts;
  bool loading = false;

  PostService _postService = PostService();

  Future<void> _fetchPosts() async {
    setState(() {
      loading = true;
      _posts = null;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      ActionResponse postResponse =
          await _postService.GET('get-posts', prefs.getString('token'));

      if (postResponse.success && postResponse.data != null) {
        setState(() {
          _posts = postResponse.data;
        });
      }

      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      print('Error fetching posts: $e');
      throw e;
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    if (loading && (_posts == null || _posts!.isEmpty)) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (_posts == null || _posts!.isEmpty) {

      return Center(
        child: Text(
          "No posts available.",
          style: TextStyle(color: Colors.white70, fontSize: 18),
        ),
      );
    } else {

      return RefreshIndicator(
        onRefresh: _fetchPosts,
        child: ListView.builder(
          itemCount: _posts!.length,
          itemBuilder: (context, index) {
            final Map<String, dynamic> postData = _posts![index];
            Map<String, dynamic> counts = {
              'comments': postData['_count']['comments'],
              'likes': postData['_count']['likedUsers'],
              'saves': postData['_count']['likedUsers']
            };

            final Map<String, dynamic> userInfo = postData['user'];
            final user = User.fromJson(userInfo);

            PostModel post = PostModel(
                postId: postData['postId'],
                description: postData['description'],
                imageUrl: postData['imageUrl'],
                isThread: postData['isThread'],
                commentAmount: counts['comments'],
                likeAmount: counts['likes'],
                saveAmount: counts['saves'],
                user: user);

            return Post(post: post);
          },
        ),
      );
    }
  }
}

