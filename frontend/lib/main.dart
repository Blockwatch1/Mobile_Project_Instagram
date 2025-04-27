import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insta/constants/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages/Auth/loginPage.dart';
import 'post_page.dart';
import 'User.dart';
import 'post.dart';
import 'thread.dart';

void main(){
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      initialRoute: '/home',
      routes: appRoutes
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// for testing , remove later
User test1 = User("MeowMan40", "https://static.tvtropes.org/pmwiki/pub/images/b76t_vciaaejpb2.jpg");
User test2 = User("MeowMan40", "https://static.tvtropes.org/pmwiki/pub/images/b76t_vciaaejpb2.jpg");
User test3 = User("MeowMan40", "https://static.tvtropes.org/pmwiki/pub/images/b76t_vciaaejpb2.jpg");
User test4 = User("MeowMan40", "https://static.tvtropes.org/pmwiki/pub/images/b76t_vciaaejpb2.jpg");
User test5 = User("MeowMan40", "https://static.tvtropes.org/pmwiki/pub/images/b76t_vciaaejpb2.jpg");
User test6 = User("MeowMan40", "https://static.tvtropes.org/pmwiki/pub/images/b76t_vciaaejpb2.jpg");
User test7 = User("MeowMan40", "https://static.tvtropes.org/pmwiki/pub/images/b76t_vciaaejpb2.jpg");
User test8 = User("MeowMan40", "https://static.tvtropes.org/pmwiki/pub/images/b76t_vciaaejpb2.jpg");
User test9 = User("MeowMan40", "https://static.tvtropes.org/pmwiki/pub/images/b76t_vciaaejpb2.jpg");
User test10 = User("MeowMan40", "https://static.tvtropes.org/pmwiki/pub/images/b76t_vciaaejpb2.jpg");

// Create a map with these 10 users as keys and comments as values
Map<User, String> testComments = {
  test1: "This cat picture made my day! 😸",
  test2: "Purrfect shot! Love the composition.",
  test3: "Is this your cat? So adorable!",
  test4: "Meow-nificent! Can't stop looking at this.",
  test5: "This reminds me of my childhood cat. Thanks for sharing!",
  test6: "The whiskers on this cat are amazing! What breed is it?",
  test7: "I want to pet this cat through the screen! So fluffy!",
  test8: "This should be framed and put in an art gallery.",
  test9: "Those eyes! They're staring into my soul...",
  test10: "Best cat photo I've seen all day. And I've seen a lot!"
};

User test=User("MeowMan40", "https://static.tvtropes.org/pmwiki/pub/images/b76t_vciaaejpb2.jpg");

class _HomePageState extends State<HomePage> {

  Map<String, dynamic>? _userData;

  Future<void> _checkForSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();


    if(prefs.getString('token') == null){
      Navigator.pushNamed(context, '/login');
      return;
    }

    String? userJson = prefs.getString('user');

    if(userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      _userData = userMap;
      print(_userData);
    }

    return;
  }

  @override
  void initState(){
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
              Text("InterLinked",style: TextStyle(fontFamily: "Insta",fontSize: 40),),
              Row(
                children: [
                  GestureDetector(child:
                  Icon(Icons.search),
                    onTap: (){
                      Navigator.pushNamed(context, '/search');
                    },
                  ),
                  SizedBox(width: 12), // Added SizedBox for spacing
                  CircleAvatar(radius: 20,backgroundImage: NetworkImage(test.profilePicUrl),)
                ],
              )
            ],
          )
      ),
      body:PostPage(userData: _userData,),
    );
  }
}