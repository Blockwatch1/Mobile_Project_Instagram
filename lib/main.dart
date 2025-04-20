import 'package:flutter/material.dart';
import 'post.dart';
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

class _HomePageState extends State<HomePage> {
  int currBottomBarIndex = 0;
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Expanded(child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Cornflex",style: TextStyle(fontFamily: "Insta",fontSize: 40),),
            CircleAvatar(radius: 20,backgroundImage: NetworkImage("https://static.tvtropes.org/pmwiki/pub/images/b76t_vciaaejpb2.jpg"),)
          ],
        ))),
        body: Post(user: "MeowMan40", image: "", comments: {"me":"yes"}, likeAmount: 50),
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


