import 'package:flutter/material.dart';

import '../Models/User.dart';
import 'UserCard.dart';

class UserList extends StatelessWidget {
  final List<dynamic> _users;
  const UserList({super.key, required users}) : _users = users;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _users.length,
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey.withOpacity(0.1),
        height: 1,
        indent: 70,
        endIndent: 16,
      ),
      itemBuilder: (BuildContext context, int index) {
        final userData = _users[index];
        final dynamic userId = userData['userId'];
        final String? bio = userData['bio'];
        final String? pfpPath = userData['pfpPath'];
        final String name = userData['name'];
        final String username = userData['username'];

        User user = User(
            userId: userId,
            name: name,
            username: username,
            bio: bio,
            pfpPath: pfpPath
        );

        return UserCard(user: user);
      },
    );
  }
}