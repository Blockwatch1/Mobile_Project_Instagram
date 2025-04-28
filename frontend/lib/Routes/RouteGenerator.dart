import 'package:flutter/material.dart';
import 'package:insta/Models/PostModel.dart';
import 'package:insta/Pages/FollowersList.dart';
import 'package:insta/Pages/Post/PostPage.dart';
import 'package:insta/Pages/ProfilePage.dart';
import 'package:insta/main.dart';

import '../Pages/Auth/loginPage.dart';
import '../Pages/Auth/signUpPage.dart';
import '../Pages/searchPage.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch(settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => SafeArea(child: HomePage()));
      case '/login':
        return MaterialPageRoute(builder: (_) => SafeArea(child: Loginpage()));
      case '/signup':
        return MaterialPageRoute(builder: (_) => SafeArea(child: SignUpPage()));
      case '/search':
        return MaterialPageRoute(builder: (_) => const SearchPage());
      case '/postPage':
        if(args is PostModel){
          return MaterialPageRoute(builder: (_) => PostPage(post: args));
        }
        
        return _errorRoute();
      case '/profilePage':
        if(args is Map<String, dynamic> && args.containsKey('userId')){
          return MaterialPageRoute(builder: (_) => ProfilePage(userId: args['userId'],));
        }

        return _errorRoute();

      case '/followersList':
        if(args is Map<String, dynamic>){
          return MaterialPageRoute(builder: (_) => SafeArea(child: Followerslist(followers: args['followers'], name: args['name'])));
        }

        return _errorRoute();

      case '/followingsList':
        if(args is Map<String, dynamic>){
          return MaterialPageRoute(builder: (_) => SafeArea(child: Followerslist(followers: args['followings'], name: args['name'])));
        }

        return _errorRoute();

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error', style: TextStyle(color: Colors.red),),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("This route does not exist!", style: TextStyle(fontSize: 50, fontFamily: "Insta"),),
                ElevatedButton(onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(2.5),
                      backgroundColor:  MaterialStateProperty.all(Colors.purpleAccent)
                  ),
                  child: Center(
                    child: Text("Go Back to Home Screen", style: TextStyle(color: Colors.white, fontSize: 20),),
                  ),)
              ],
            ),
          ),
        ),
      );
    });
  }
}