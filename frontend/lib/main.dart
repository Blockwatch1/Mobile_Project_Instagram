import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insta/Routes/RouteGenerator.dart';
import 'package:insta/constants/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages/Auth/loginPage.dart';
import 'postList.dart';
import 'Models/User.dart';
import 'Widgets/post.dart';
import 'Widgets/thread.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      initialRoute: '/home',
      onGenerateRoute: RouteGenerator.generateRoute
    ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

User test = User(
    userId: 1,
    name: "MeowMan40",
    pfpPath:
        "https://static.tvtropes.org/pmwiki/pub/images/b76t_vciaaejpb2.jpg",
    username: "marwanmoub");

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? _userData;

  Future<void> _checkForSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString('token') == null) {
      Navigator.of(context).pushNamed('/login');
      return;
    }

    String? userJson = prefs.getString('user');

    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      _userData = userMap;
      print(_userData);
    }

    return;
  }

  @override
  void initState() {
    super.initState();
    _checkForSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "InterLinked",
            style: TextStyle(fontFamily: "Insta", fontSize: 40),
          ),
          Row(
            children: [
              GestureDetector(
                child: Icon(Icons.search),
                onTap: () {
                  Navigator.pushNamed(context, '/search');
                },
              ),
              SizedBox(width: 12),
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(test.pfpPath!),
              )
            ],
          )
        ],
      )),
      body: PostList(
        userData: _userData,
      ),
    );
  }
}
