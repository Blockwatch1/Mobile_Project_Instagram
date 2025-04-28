import 'package:flutter/material.dart';
import 'package:insta/Models/ActionResponse.dart';
import 'package:insta/Models/CommentModel.dart';
import 'package:insta/Models/PostModel.dart';
import 'package:insta/Services/CommentService.dart';
import 'package:insta/Widgets/post.dart';
import 'package:insta/comments.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostPage extends StatefulWidget {
  final PostModel _post;

  const PostPage({super.key, required post}) : _post = post;

  @override
  State<PostPage> createState() => _PostPageState();
}


class _PostPageState extends State<PostPage> {

  CommentService _commentService = CommentService();
  bool _loading = false;
  List<dynamic>? _comments;

  Future<void> _fetchPostComments () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    setState(() {
      _loading = true;
    });

    try {
      ActionResponse commentResponse = await _commentService.GET('get-comments/${widget._post.postId}', token);
      print(commentResponse.success);
      print(commentResponse.data);
      if (commentResponse.success) {
        setState(() {
          _comments = commentResponse.data;
        });
      }

      setState(() {
        _loading = false;
      });
    } catch(e) {
      setState(() {
        _loading = false;
      });
      print('Cannot fetch post comments: $e');
      throw e;
    }
  }

  @override
  void initState(){
    super.initState();
    _fetchPostComments();
  }

  @override
  Widget build(BuildContext context) {
    var testComments = [
      CommentModel(commentId: 1, isReply: false, content: 'Hellooo', user: widget._post.user!, isEdited: false, replyAmount: 0, postId: widget._post.postId)
    ];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => {Navigator.of(context).pop()}, icon: Icon(Icons.arrow_back)),
        title: Text("Post"),
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Post(post: widget._post),
            SizedBox(height: 10,),
            Text("Comments", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
            SizedBox(height: 10,),
            CommentList(comments: testComments)
          ],
        ),
      )
    );
  }
}
