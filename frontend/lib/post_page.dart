import 'package:flutter/material.dart';
import 'post.dart';
import 'User.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  // User instances
  final User user1 = User("User 1", "https://example.com/user1.jpg");
  final User user2 = User("User 2", "https://example.com/user2.jpg");
  final User user3 = User("User 3", "https://example.com/user3.jpg");
  final User user4 = User("User 4", "https://example.com/user4.jpg");
  final User user5 = User("User 5", "https://example.com/user5.jpg");
  final User user6 = User("User 6", "https://example.com/user6.jpg");
  final User user7 = User("User 7", "https://example.com/user7.jpg");
  final User user8 = User("User 8", "https://example.com/user8.jpg");

  // Comments map
 late final Map<User, String> userComments = {
   user1: "cool pic 🔥",
   user2: "nice 👍",
   user3: "❤️❤️",
  };

  // List of posts
  late final List<Post> list1 = [
    Post(user: user1, image: "https://example.com/post1.jpg", comments: userComments, likeAmount: 359),
    Post(user: user2, image: "https://example.com/post2.jpg", comments: userComments, likeAmount: 100),
    Post(user: user3, image: "https://example.com/post3.jpg", comments: userComments, likeAmount: 87),
    Post(user: user4, image: "https://example.com/post4.jpg", comments: userComments, likeAmount: 43),
    Post(user: user5, image: "https://example.com/post5.jpg", comments: userComments, likeAmount: 328),
    Post(user: user6, image: "https://example.com/post6.jpg", comments: userComments, likeAmount: 56),
    Post(user: user7, image: "https://example.com/post7.jpg", comments: userComments, likeAmount: 108),
    Post(user: user8, image: "https://example.com/post8.jpg", comments: userComments, likeAmount: 99),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list1.length,
        itemBuilder: (context, index) {
          return list1 [index];
        },
      );
  }
}