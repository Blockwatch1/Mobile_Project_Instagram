import 'package:flutter/material.dart';
import 'package:insta/Models/ActionResponse.dart';
import 'package:insta/Services/PostService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Widgets/post.dart';
import 'Models/User.dart';

class PostPage extends StatefulWidget {

  final Map<String, dynamic>? _userData;
  const PostPage({super.key, Map<String, dynamic>? userData}) : _userData = userData;

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {

  List<dynamic>? _posts;
  bool loading = false;

  PostService _postService = PostService();


  Future<void> _fetchPosts() async {
    setState(() {
      loading = true;
      _posts = null;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    try{
      ActionResponse postResponse = await _postService.getPosts('get-posts', prefs.getString('token'));

      if(postResponse.success && postResponse.data != null) {
        setState(() {
          _posts = postResponse.data;
        });
      }

      setState(() {
        loading = false;
      });

    } catch(e) {
      setState(() {
        loading = false;
      });
      print('Error fetching posts: $e');
      throw e;
    }
  }

  @override
  void initState(){
    super.initState();


    _fetchPosts();
  }


  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        body: ListView.builder(
          itemCount: _posts?.length,
          itemBuilder: (context, index) {
            final Map<String, dynamic> postData = _posts![index];
            Map<String, dynamic> counts = {
              'comments': postData['_count']['comments'],
              'likes': postData['_count']['likedUsers'],
              'saves': postData['_count']['likedUsers']
            };
            print(postData['user']);

            final Map<String, dynamic> userInfo = postData['user'];
            final user = User.fromJson(userInfo);


            return Post(description: postData['description'], user: User(userId: user.userId, name: user.name, username: user.username), image: postData['imageUrl'], commentCount: counts['comments'], likeAmount: counts['likes'], saveAmount: counts['saves'],);
          },
        ),
      );
    }
  }
}