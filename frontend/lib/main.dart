import 'package:flutter/material.dart';
import 'package:insta/User.dart';
import 'post.dart';
import 'thread.dart';
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    themeMode: ThemeMode.dark,
    darkTheme: ThemeData.dark(),
    home: SafeArea(child: HomePage()),
  ));
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
// for testing , remove later
User test1 = User("MeowMan40", "https://static.tvtropes.org/pmwiki/pub/images/b76t_vciaaejpb2.jpg");
User test2 = User("MeowMan40", "https://static.tvtropes.org/pmwiki/pub/images/b76t_vciaaejpb2.jpg");
User test3 = User("MeowMan40", "https://static.tvtropes.org/pmwiki/pub/images/b76t_vciaaejpb2.jpg");
User test4 = User("MeowMan40", "https://static.tvtropes.org/pmwiki/pub/images/b76t_vciaaejpb2.jpg");
User test5 = User("MeowMan40", "https://static.tvtropes.org/pmwiki/pub/images/b76t_vciaaejpb2.jpg");
User test6 = User("MeowMan40", "https://static.tvtropes.org/pmwiki/pub/images/b76t_vciaaejpb2.jpg");
User test7 = User("MeowMan40", "https://static.tvtropes.org/pmwiki/pub/images/b76t_vciaaejpb2.jpg");
User test8 = User("MeowMan40", "https://static.tvtropes.org/pmwiki/pub/images/b76t_vciaaejpb2.jpg");
User test9 = User("MeowMan40", "https://static.tvtropes.org/pmwiki/pub/images/b76t_vciaaejpb2.jpg");
User test10 = User("MeowMan40", "https://static.tvtropes.org/pmwiki/pub/images/b76t_vciaaejpb2.jpg");

// Create a map with these 10 users as keys and comments as values
Map<User, String> testComments = {
  test1: "This cat picture made my day! 😸",
  test2: "Purrfect shot! Love the composition.",
  test3: "Is this your cat? So adorable!",
  test4: "Meow-nificent! Can't stop looking at this.",
  test5: "This reminds me of my childhood cat. Thanks for sharing!",
  test6: "The whiskers on this cat are amazing! What breed is it?",
  test7: "I want to pet this cat through the screen! So fluffy!",
  test8: "This should be framed and put in an art gallery.",
  test9: "Those eyes! They're staring into my soul...",
  test10: "Best cat photo I've seen all day. And I've seen a lot!"
};
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
             Post(user: test, comments: testComments, likeAmount: 50, image: '',),
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


