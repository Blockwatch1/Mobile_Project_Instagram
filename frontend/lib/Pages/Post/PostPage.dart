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

  TextEditingController _commentController = TextEditingController();
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
      body: RefreshIndicator(
        onRefresh: () => _fetchPostComments(),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Post(post: widget._post),
              SizedBox(height: 10,),
              CommentList(comments: _comments),
            ],
          ),
        ),
      ),
        bottomNavigationBar:  BottomCommentTextField(commentController: _commentController)
    );
  }
}

class BottomCommentTextField extends StatefulWidget {
  BottomCommentTextField({
    super.key,
    required TextEditingController commentController,
  }) : _commentController = commentController;

  final TextEditingController _commentController;
  FocusNode _commentFocusNode = FocusNode();
  @override
  State<BottomCommentTextField> createState() {
    return _CommentTextFieldState();
  }

}
class _CommentTextFieldState extends State<BottomCommentTextField>{
  double bottomMargin= 0;
  Widget build(BuildContext context) {
    bottomMargin=  8.0 + MediaQuery.of(context).viewInsets.bottom;
    return  Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 12.0,
          bottom: bottomMargin
      ),
      child: GestureDetector(
        child: TextField(
          onTap: (){
            setState(() {
              bottomMargin=  8.0 + MediaQuery.of(context).viewInsets.bottom;
            });
          },
          focusNode: widget._commentFocusNode,
          autofocus:true,
          keyboardType: TextInputType.text,
          controller: widget._commentController,
          decoration: InputDecoration(
            hintText: 'Add a comment...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            suffixIcon: IconButton(
              icon: Icon(Icons.send, color: Colors.blueAccent),
              onPressed: () {
                String commentText = widget._commentController.text;
                if (commentText.isNotEmpty) {
                  widget._commentController.clear();
                  FocusScope.of(context).unfocus();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}