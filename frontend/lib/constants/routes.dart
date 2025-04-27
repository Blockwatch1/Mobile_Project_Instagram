import 'package:flutter/material.dart';
import 'package:insta/Pages/Auth/loginPage.dart';
import 'package:insta/Pages/Auth/signUpPage.dart';
import 'package:insta/main.dart';
import 'package:insta/postList.dart';

import '../Pages/searchPage.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/login': (context) => SafeArea(child: Loginpage()),
  '/signup': (context) => SafeArea(child: SignUpPage()),
  '/search': (context) => const SearchPage(),
  '/home': (context) => HomePage(),
};
