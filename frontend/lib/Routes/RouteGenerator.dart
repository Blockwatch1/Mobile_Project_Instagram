import 'package:flutter/material.dart';

import '../Pages/Auth/loginPage.dart';
import '../Pages/Auth/signUpPage.dart';
import '../Pages/searchPage.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch(settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => SafeArea(child: Loginpage()));
      case '/signup':
        return MaterialPageRoute(builder: (_) => SafeArea(child: SignUpPage()));
      case '/search':
        return MaterialPageRoute(builder: (_) => const SearchPage());

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
          child: Column(
            children: [
              Text("This route does not exist!"),
              ElevatedButton(onPressed: () => Navigator.of(context).pushNamed('/home'),
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(2.5),
                backgroundColor:  MaterialStateProperty.all(Colors.purpleAccent)
              ),
              child: Center(
                child: Text("Go Back to Home Screen", style: TextStyle(color: Colors.white),),
              ),)
            ],
          ),
        ),
      );
    });
  }
}