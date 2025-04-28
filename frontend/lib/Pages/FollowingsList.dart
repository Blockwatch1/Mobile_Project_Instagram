import 'package:flutter/material.dart';
import 'package:insta/Widgets/UserList.dart';

class FollowingsList extends StatelessWidget {
  final List<dynamic> _followings;
  final dynamic name;
  const FollowingsList({super.key, required followings, required this.name}) : _followings = followings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$name's followings", textAlign: TextAlign.center, style: TextStyle(
          fontFamily: "Insta", fontWeight: FontWeight.bold, fontSize: 30
        ),),
      ),
      body: Center(
        child: UserList(users: _followings),
      ),
    );
  }
}
