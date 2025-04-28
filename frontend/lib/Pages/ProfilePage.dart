import 'package:flutter/material.dart';
import 'package:insta/Models/ActionResponse.dart';
import 'package:insta/Services/UserService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/User.dart';

class ProfilePage extends StatefulWidget {
  final dynamic userId;
  const ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _loading = false;
  User? _user;
  UserService _fetchUserService = UserService();

  Future<void> _fetchUser() async {
    try {
      setState(() {
        _loading = true;
      });
      
      if(widget.userId != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token');
        ActionResponse userResponse = await _fetchUserService.getNoBody('${widget.userId}', token);

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton( 
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Center(child: Text("${_user?.username}", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),),
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

        ],
      ),
    );
  }
}
