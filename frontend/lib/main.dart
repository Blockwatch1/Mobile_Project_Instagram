import 'package:flutter/material.dart';
import 'package:insta/User.dart';
import 'post.dart';
import 'thread.dart';
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    themeMode: ThemeMode.dark,
    darkTheme: ThemeData.dark(),
    home: HomePage(),
  ));
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
User test=User("MeowMan40", "https://static.tvtropes.org/pmwiki/pub/images/b76t_vciaaejpb2.jpg");
class _HomePageState extends State<HomePage> {
  int currBottomBarIndex = 0;
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Expanded(child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Cornflex",style: TextStyle(fontFamily: "Insta",fontSize: 40),),
            CircleAvatar(radius: 20,backgroundImage: NetworkImage(test.profilePicUrl),)
          ],
        ))),
        body:Expanded(child: ListView(
          children: [
             Post(user: test, comments: {test:"yes"}, likeAmount: 50, image: '',),
          ],
        )),
        bottomNavigationBar: GestureDetector(

          child: BottomNavigationBar(
            currentIndex: currBottomBarIndex,
            onTap: (newIndex){
              setState(() {
                currBottomBarIndex=newIndex;
              });
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
              BottomNavigationBarItem(icon: Icon(Icons.mail_outline), label: 'Inbox'),
            ],
          ),
        ),

      );
  }
}


