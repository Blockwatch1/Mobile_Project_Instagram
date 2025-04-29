import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:insta/Pages/ProfilePage.dart';
import 'package:insta/Routes/RouteGenerator.dart';
import 'package:insta/Services/UserService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'postList.dart';
import 'Models/User.dart';
import 'Services/PostService.dart';
class EditProfilePage extends StatefulWidget {
  User user;
  EditProfilePage({super.key,required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
   bool _loading = false;
   TextEditingController _pfpController = TextEditingController();
   TextEditingController _bioController = TextEditingController();
   TextEditingController _nameController = TextEditingController();
   TextEditingController _usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit your profile ${widget.user.name}"),
        centerTitle: true,
      ),
      body: Expanded(
        child: Column(
          spacing: 25,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(controller: _bioController,keyboardType: TextInputType.multiline,
                minLines: 6,
                maxLines: 16,
                decoration: InputDecoration(
                    hintText:  "Enter your Bio",
                    contentPadding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(controller: _nameController,keyboardType: TextInputType.text,
                maxLength: 40,
                decoration: InputDecoration(
                  hintText: "Change your Name",
                  contentPadding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(controller: _usernameController,keyboardType: TextInputType.text,
                maxLength: 40,
                decoration: InputDecoration(
                  hintText: "Change your Username : Leave Empty for no Username Change",
                  contentPadding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(controller: _pfpController,keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  hintText: "Enter your New Profile Picture",
                  contentPadding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async{
                    // const { name, username, pfpPath, bio } = req.body;
                    if(_nameController.text.isNotEmpty){
                          setState(() {
                            _loading=true;
                          });
                          UserService service =  UserService();
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          if(_usernameController.text.isNotEmpty) {
                            service.updateProfile(widget.user.userId, {
                              "name": _nameController.text,
                              "username": _usernameController.text,
                              "pfpPath": _pfpController.text,
                              "bio": _bioController.text
                            }, prefs.getString('token'));
                          }else{
                            service.updateProfile(widget.user.userId, {
                              "name": _nameController.text,
                              "username": null,
                              "pfpPath": _pfpController.text,
                              "bio": _bioController.text
                            }, prefs.getString('token'));
                          }
                          setState(() {
                            _loading=false;
                          });
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context){
                              return ProfilePage(userId: widget.user.userId);
                            })
                          );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 60),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    alignment: Alignment.center,
                    child: _loading ? const CircularProgressIndicator() : Text("Update",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.black),),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
