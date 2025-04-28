import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:insta/Routes/RouteGenerator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'postList.dart';
import 'Models/User.dart';

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

User? test = User(
    userId: 1,
    name: "MeowMan40",
    pfpPath:
        "https://static.tvtropes.org/pmwiki/pub/images/b76t_vciaaejpb2.jpg",
    username: "marwanmoub");

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? _userData={
    "userId": null,
    "username":null,
    "email": null,
    "bio": null,
    "pfpPath":null
  };

  Future<User?> _checkForSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString('token') == null) {
      Navigator.of(context).pushNamed('/login');
      return null;
    }

    String? userJson = prefs.getString('user');

    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      _userData = userMap;
    }
    print("wewewe : $_userData");
    return User(userId: _userData?["userId"],username:_userData?["username"],pfpPath: _userData?["pfpPath"]??"https://static.vecteezy.com/system/resources/previews/008/442/086/large_2x/illustration-of-human-icon-user-symbol-icon-modern-design-on-blank-background-free-vector.jpg");
  }
  Future<void> setUser() async{
    print("sheft ma a2weni?");
    User? storedUser = await _checkForSession();
    print("lek hl user ma a7le : $storedUser");
    if(storedUser==null){
      return;
    }
    setState(() {
      test= storedUser;
    });
  }

  @override
  void initState() {
    super.initState();
    print("hallo");
    setUser();
  }

  @override
  Widget build(BuildContext context) {
    try {
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
                      backgroundImage: NetworkImage(test!.pfpPath!),
                    )
                  ],
                )
              ],
            )),
        body: PostList(),
      );
    }catch(e){
      return Text("sorry for the inconvenience, we are experiencing technical difficulties");
    }
  }
}
