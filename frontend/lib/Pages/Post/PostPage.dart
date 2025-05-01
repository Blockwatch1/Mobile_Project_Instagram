import 'package:flutter/material.dart';
import 'package:insta/Models/ActionResponse.dart';
import 'package:insta/Models/CommentModel.dart';
import 'package:insta/Models/PostModel.dart';
import 'package:insta/Services/CommentService.dart';
import 'package:insta/Widgets/post.dart';
import 'package:insta/comments.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostPage extends StatefulWidget {
  final PostModel? _post;

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
      ActionResponse commentResponse = await _commentService.GET('get-comments/${widget._post?.postId}', token);

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
    if(_loading) {
      return Center(
        child: const CircularProgressIndicator(),
      );
    }

    if(widget._post == null) {
      return Center(
        child: const Text('Error finding post', style: TextStyle(fontFamily: "Insta", fontSize: 50),),
      );
    }

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
                Post(post: widget._post!),
                SizedBox(height: 10,),
                CommentList(comments: _comments),
              ],
            ),
          ),
        ),
        bottomNavigationBar:  BottomCommentTextField(post: widget._post! ,commentController: _commentController)
    );
  }
}

class BottomCommentTextField extends StatefulWidget {
  PostModel _post;
  BottomCommentTextField({
    super.key,
    required TextEditingController commentController,
    required PostModel post,
  })  : _commentController = commentController,
        _post = post;

  TextEditingController _commentController;
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
              onPressed: () async{
                String commentText = widget._commentController.text;
                if (commentText.isNotEmpty) {
                  CommentService service = CommentService();
                  SharedPreferences prefs =  await SharedPreferences.getInstance();
                  service.sendComment(widget._post.postId,widget._commentController.text, prefs.getString('token'));
                  print("lek hl token ma a7leha : ${prefs.getString('token')}");
                  print("lek hl comment ma a7le : ${widget._commentController.text}");
                  widget._commentController.clear();
                  Navigator.of(context).pushReplacementNamed('/postPage', arguments: widget._post);
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