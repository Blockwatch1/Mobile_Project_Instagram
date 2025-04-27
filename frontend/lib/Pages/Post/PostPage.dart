import 'package:flutter/material.dart';
import 'package:insta/Models/PostModel.dart';

class PostPage extends StatefulWidget {
  final PostModel _post;

  const PostPage({super.key, required post}) : _post = post;

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
