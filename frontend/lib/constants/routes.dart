import 'package:flutter/material.dart';
import 'package:insta/loginPage.dart';

import '../Pages/searchPage.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => SafeArea(child: Loginpage()),
  '/search': (context) => const SearchPage(),
};