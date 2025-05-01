import 'package:flutter/material.dart';
import 'package:insta/Models/PostModel.dart';
import 'package:insta/Pages/AccountSettings.dart';
import 'package:insta/Pages/FollowersList.dart';
import 'package:insta/Pages/Post/CreatePost.dart';
import 'package:insta/Pages/Post/PostPage.dart';
import 'package:insta/Pages/ProfilePage.dart';
import 'package:insta/main.dart';

import '../Pages/Auth/loginPage.dart';
import '../Pages/Auth/signUpPage.dart';
import '../Pages/FollowingsList.dart';
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
          return MaterialPageRoute(builder: (_) => SafeArea(child: FollowingsList(followings: args['followings'], name: args['name'])));
        }

        return _errorRoute();

      case '/accountSettings':
        if(args is Map<String, dynamic>) {
          return MaterialPageRoute(builder: (_) => SafeArea(child: AccountSettings(email: args['email'], password: args['password'],
          userId: args['userId'], lastLogin: args['lastLogin'], lastUsernameChange: args['lastUsernameChange'], name: args['name'])));
        }

        return _errorRoute();

      case '/createPost':
        return MaterialPageRoute(builder: (_) => const CreatePostPage());


      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        backgroundColor: Color(0xFF121212),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1E1E1E),
                Color(0xFF121212),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Custom AppBar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: Text(
                          "Error",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 48), // Balance the layout
                    ],
                  ),
                ),

                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Error Icon with Glow
                          Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.purpleAccent.withOpacity(0.1),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purpleAccent.withOpacity(0.2),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.error_outline,
                                size: 70,
                                color: Colors.purpleAccent,
                              ),
                            ),
                          ),

                          SizedBox(height: 40),

                          // Error Message
                          Text(
                            "Oops!",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.purpleAccent,
                              fontFamily: "Insta",
                            ),
                          ),

                          SizedBox(height: 16),

                          Text(
                            "This route does not exist!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontFamily: "Insta",
                            ),
                          ),

                          SizedBox(height: 8),

                          Text(
                            "The page you're looking for isn't available.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[400],
                            ),
                          ),

                          SizedBox(height: 40),

                          // Home Button
                          GestureDetector(
                            onTap: () => Navigator.of(context).pushReplacementNamed('/home'),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFE040FB),
                                    Color(0xFF9C27B0),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.purpleAccent.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.home,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Return to Home",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 16),

                          // Back Button
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              "Go Back",
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}