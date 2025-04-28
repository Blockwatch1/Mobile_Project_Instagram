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
  ProfilePage({super.key, required userId}): _userId = userId;

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

    if(jsonUser != null) {
      widget._myUser = jsonDecode(jsonUser);
      print('MY USER: ${widget._myUser}');
      print(_user?.userId);
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
      
      if(widget._userId != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token');
        ActionResponse userResponse = await _fetchUserService.getNoBody('${widget._userId}', token);

        if(userResponse.success && userResponse.data is Map<String, dynamic>) {
          User newUser = User.fromJson(userResponse.data);
          setState(() {
            _user = newUser;
          });
        }
      }
      
      setState(() {
        _loading = false;
      });
    } catch(e) {
      setState(() {
        _loading = false;
      });
      throw e;
    }
  }

  @override
  void initState(){
    super.initState();
    _fetchUser();
    _checkIfSameUser();
  }

  @override
  Widget build(BuildContext context) {

    if(_loading) {
      return Center(
        child: const CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton( 
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Center(child: Text("${_user?.name}", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),),
        actions: [
          IconButton(
            onPressed: () {
              //add settings page later
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          TopSection(user: _user, isSameUser: _isSameUser,),
          Expanded(
            child: PostSection(posts: _user?.posts, user: _user,),
          )
        ],
      ),
    );
  }
}
