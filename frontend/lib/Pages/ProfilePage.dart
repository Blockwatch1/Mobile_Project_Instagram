import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insta/Models/ActionResponse.dart';
import 'package:insta/Services/UserService.dart';
import 'package:insta/Widgets/ProfilePageWidgets/PostSection.dart';
import 'package:insta/Widgets/ProfilePageWidgets/TopSection.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/User.dart';

class ProfilePage extends StatefulWidget {
  final dynamic _userId;
  Map<String, dynamic>? _myUser = {};
  ProfilePage({super.key, required userId}) : _userId = userId;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _loading = false;
  User? _user;
  UserService _fetchUserService = UserService();
  bool _isSameUser = false;

  Future<void> _checkIfSameUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic jsonUser = prefs.getString('user');

    if (jsonUser != null) {
      widget._myUser = jsonDecode(jsonUser);
      if (widget._myUser?['userId'] == widget._userId) {
        setState(() {
          _isSameUser = true;
        });
      }
    }
  }

  Future<void> _fetchUser() async {
    try {
      setState(() {
        _loading = true;
      });

      if (widget._userId != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token');
        ActionResponse userResponse =
        await _fetchUserService.getNoBody('${widget._userId}', token);

        if (userResponse.success &&
            userResponse.data is Map<String, dynamic>) {
          User newUser = User.fromJson(userResponse.data);
          setState(() {
            _user = newUser;
          });
        }
      }

      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      throw e;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUser();
    _checkIfSameUser();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: Color(0xFF121212),
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.purpleAccent,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          "${_user?.name}",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_isSameUser)
            IconButton(
              onPressed: () {
                Map<String, dynamic> emailAndPass = {
                  'email': _user?.email,
                  'password': _user?.password,
                  'userId': _user?.userId,
                  'lastLogin': _user?.lastLogin,
                  'lastUsernameChange': _user?.lastUsernameChange,
                  'name': _user?.name
                };
                Navigator.of(context).pushNamed('/accountSettings', arguments: emailAndPass);
              },
              icon: Icon(Icons.settings, color: Colors.white),
            )
        ],
      ),
      body: Column(
        children: [
          Topsection(user: _user, isSameUser: _isSameUser),
          Divider(
            color: Colors.grey.withOpacity(0.3),
            thickness: 0.5,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                Icon(
                  Icons.grid_on,
                  color: Colors.purpleAccent,
                ),
                SizedBox(width: 8),
                Text(
                  "Posts",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PostSection(posts: _user?.posts, user: _user),
          )
        ],
      ),
    );
  }
}