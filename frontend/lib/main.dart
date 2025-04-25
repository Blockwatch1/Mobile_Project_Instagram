import 'package:flutter/material.dart';
import 'package:insta/account_page.dart';
import 'package:insta/post_page.dart';
import 'User.dart';
import 'post.dart';
import 'thread.dart';
import 'account_page.dart';

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


User test=User("MeowMan40", "https://static.tvtropes.org/pmwiki/pub/images/b76t_vciaaejpb2.jpg");

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: Expanded(child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("InterLinked",style: TextStyle(fontFamily: "Insta",fontSize: 40),),
          Row(
            spacing: 12,
            children: [
              GestureDetector(child:
              Icon(Icons.search),
                onTap: (){
                 Navigator.of(context).push(
                   MaterialPageRoute(builder: (context) {
                     return SearchPage();
                   },)
                 );
                },
              ),
              GestureDetector(
                  child: CircleAvatar(radius: 20,backgroundImage: NetworkImage(test.profilePicUrl),),
                  //onTap:
              )
            ],
          )
        ],
      ))
      ),
      body:PostPage(),

    );
  }
}
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: TextField(
              controller: _searchText,
              decoration: InputDecoration(
                  hintText: 'Search ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  suffixIcon: GestureDetector(
                    child: Icon(Icons.search),
                  )

              ),
            ) ,
          )
      );
    }

}
