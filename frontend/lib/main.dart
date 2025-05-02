import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:insta/Models/ActionResponse.dart';
import 'package:insta/Routes/RouteGenerator.dart';
import 'package:insta/Services/UserService.dart';
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
      initialRoute: '/signup',
      onGenerateRoute: RouteGenerator.generateRoute
    ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PostService service = PostService();
  Map<String, dynamic>? _userData;
  bool _loading = false;

  Future<void> _checkForSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');



    // setState(() {
    //   _loading = true;
    // });
    if(userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      print('HELLOOOOOO $userMap');
      UserService service = UserService();
      ActionResponse? response = await service.getNoBody("get-info/shared-preferences", prefs.getString('token'));
      if(response.success){
        userMap['name'] = response.data['name'];
        userMap['username'] = response.data['username'];
        userMap['pfpPath'] = response.data['pfpPath'];
        userMap['bio'] = response.data['bio'];
        userMap['userId'] = response.data['userId'];

        setState(() {
          _userData = userMap;
          _loading = false;
        });
      }
    }

  }

  @override
  void initState() {
    super.initState();
    _checkForSession();
  }

  @override
  Widget build(BuildContext context) {

    if(_loading) {
      return Center(
        child: const CircularProgressIndicator(),
      );
    }

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
                child: !_loading ? CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(_userData?['pfpPath'] ?? "https://static.vecteezy.com/system/resources/previews/008/442/086/large_2x/illustration-of-human-icon-user-symbol-icon-modern-design-on-blank-background-free-vector.jpg"),
                ) : null,
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
