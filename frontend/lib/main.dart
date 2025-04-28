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

User test = User(
    userId: 1,
    name: "MeowMan40",
    pfpPath:
        "https://static.tvtropes.org/pmwiki/pub/images/b76t_vciaaejpb2.jpg",
    username: "marwanmoub");

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
                  backgroundImage: NetworkImage(test.pfpPath??"https://static.vecteezy.com/system/resources/previews/008/442/086/large_2x/illustration-of-human-icon-user-symbol-icon-modern-design-on-blank-background-free-vector.jpg"),
                ),
              ),
            ],
          )
        ],
      )),
      body: PostList(),
      floatingActionButton: FloatingActionButton(onPressed:(){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context){
            return addPostPage();
          })
        );
      } ,child: Icon(Icons.add),backgroundColor: Colors.purple,),

    );
  }
}
class addPostPage extends StatefulWidget {
  const addPostPage({super.key});

  @override
  State<addPostPage> createState() => _addPostPageState();
}

class _addPostPageState extends State<addPostPage> {
  PostService service = PostService();
  Widget UrlField = const SizedBox(width: 0,height: 0,);
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _imageUrlController = TextEditingController();
  bool isThread=false;
  Future<void> sendPost()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    service.addPostOrThread('create-post', prefs.getString('token'),_descriptionController.text , _imageUrlController.text, isThread);
    Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {
    UrlField = !isThread?  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(controller: _imageUrlController,keyboardType: TextInputType.url,
        decoration: InputDecoration(

          hintText: "Image Url",
          contentPadding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20)
          ),

        ),
      ),
    ): const SizedBox(width: 0,height: 0,);
    return Scaffold(
      appBar: AppBar(title: Text("Make a new Post"),),
      body: Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 30,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(controller: _descriptionController,keyboardType: TextInputType.multiline,
              minLines: 6,
              maxLines: 16,
              decoration: InputDecoration(
                hintText:  "What's on your mind?",
                contentPadding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  )
              ),
            ),
          ),
          UrlField,
          Row(children: [const SizedBox(width: 20,),Text("Thread?",style: TextStyle(fontSize: 20),textAlign: TextAlign.start,),],),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              Radio(value: false, groupValue: isThread,activeColor: Colors.blue, onChanged:(value) {
                setState(() {
                  isThread=value!;
                });
              }, ),
              Text("No"),
              Radio(value: true, groupValue: isThread,activeColor:Colors.blue, onChanged:(value) {
                setState(() {
                  isThread=value!;
                  print("is thread? $isThread");
                });
              }, ),
              Text("Yes")
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  sendPost();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 60),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.purple,
                  ),
                  alignment: Alignment.center,
                  child: Text("Post",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                ),
              )
            ],
          )
        ],
      )),
    );
  }
}
