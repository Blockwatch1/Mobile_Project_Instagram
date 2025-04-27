import 'package:flutter/material.dart';
import '../Models/User.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
          title: Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
            Text(
              "Account",
              style: TextStyle(fontFamily: "Insta", fontSize: 40),
            ),
            Icon(Icons.settings),
          ]))),
      body: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                    "https://static.tvtropes.org/pmwiki/pub/images/b76t_vciaaejpb2.jpg"),
              ),
              Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [Text("Followers"), Text("791")],
                      ),
                      Column(
                        children: [Text("Following"), Text("654")],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
