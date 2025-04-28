import 'package:flutter/material.dart';
import 'package:insta/Widgets/UserList.dart';

class Followerslist extends StatelessWidget {
  final List<dynamic> _followers;
  final dynamic name;
  const Followerslist({super.key, required followers, required this.name}) : _followers = followers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$name's followers", textAlign: TextAlign.center, style: TextStyle(
            fontFamily: "Insta", fontWeight: FontWeight.bold, fontSize: 30
        ),),
      ),
      body: Center(
        child: UserList(users: _followers),
      ),
    );
  }
}