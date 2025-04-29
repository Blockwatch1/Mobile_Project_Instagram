import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:insta/Routes/RouteGenerator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'postList.dart';
import 'Models/User.dart';
import 'Services/PostService.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Error loading .env file: $e");
  }
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

User? test =null;

class _HomePageState extends State<HomePage> {
  PostService service = PostService();
  Map<String, dynamic>? _userData;

  Future<void> _checkForSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');

    if (prefs.getString('token') == null || userJson == null) {
      Navigator.of(context).pushNamed('/login');
      return;
    }

    Map<String, dynamic> userMap = jsonDecode(userJson);
    User? testUser = User.fromJson(userMap);
    setState(() {
      _userData = userMap;
      test = testUser;
    });

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
              GestureDetector(
                  onTap: () {
                    Map<String, dynamic> args = {'userId': _userData?['userId']};
                    Navigator.of(context).pushNamed('/profilePage', arguments: args);
                  },
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(test!.pfpPath??"https://static.vecteezy.com/system/resources/previews/008/442/086/large_2x/illustration-of-human-icon-user-symbol-icon-modern-design-on-blank-background-free-vector.jpg"),
                ),
              ),
            ],
          )
        ],
      )),
      body: PostList(),
      floatingActionButton: FloatingActionButton(onPressed:(){
        Navigator.of(context).pushReplacementNamed('/createPost');
      } ,
        child: Icon(Icons.add, color: Colors.white, size: 25,),backgroundColor: Colors.purpleAccent,
      ),

    );
  }
}
