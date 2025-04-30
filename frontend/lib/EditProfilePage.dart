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
  EditProfilePage({super.key, required this.user});

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
  void initState() {
    super.initState();
    // Initialize controllers with current user data
    _pfpController.text = widget.user.pfpPath ?? '';
    _bioController.text = widget.user.bio ?? '';
    _nameController.text = widget.user.name ?? '';
    _usernameController.text = widget.user.username ?? '';
  }

  @override
  void dispose() {
    _pfpController.dispose();
    _bioController.dispose();
    _nameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: "Insta",
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Image Preview
              Container(
                margin: EdgeInsets.only(bottom: 24),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.purpleAccent,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purpleAccent.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.purpleAccent.withOpacity(0.3),
                        backgroundImage: (_pfpController.text.isNotEmpty)
                            ? NetworkImage(_pfpController.text)
                            : null,
                        child: (_pfpController.text.isEmpty)
                            ? Text(
                          widget.user.name!.isNotEmpty
                              ? widget.user.name![0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                            : null,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Profile Picture",
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Bio Field
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                      child: Text(
                        "Bio",
                        style: TextStyle(
                          color: Colors.purpleAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.purpleAccent.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: TextField(
                        controller: _bioController,
                        keyboardType: TextInputType.multiline,
                        minLines: 6,
                        maxLines: 16,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Enter your Bio",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                            child: Icon(Icons.info_outline, color: Colors.purpleAccent),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Name Field
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                      child: Text(
                        "Display Name",
                        style: TextStyle(
                          color: Colors.purpleAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.purpleAccent.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: TextField(
                        controller: _nameController,
                        keyboardType: TextInputType.text,
                        maxLength: 40,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Change your Name",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: Icon(Icons.person, color: Colors.purpleAccent),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          counterText: "",
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Username Field
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                      child: Text(
                        "Username",
                        style: TextStyle(
                          color: Colors.purpleAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.purpleAccent.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: TextField(
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                        maxLength: 40,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Change your Username (leave empty for no change)",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: Icon(Icons.alternate_email, color: Colors.purpleAccent),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          counterText: "",
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Profile Picture URL Field
              Container(
                margin: EdgeInsets.only(bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                      child: Text(
                        "Profile Picture URL",
                        style: TextStyle(
                          color: Colors.purpleAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.purpleAccent.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: TextField(
                        controller: _pfpController,
                        keyboardType: TextInputType.url,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Enter your New Profile Picture URL",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: Icon(Icons.image, color: Colors.purpleAccent),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                        onChanged: (value) {
                          // Update UI to show new profile image
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),

              //update
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      // Keeping the exact same functionality
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
                        } else {
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
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 80),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFE040FB),
                            Color(0xFF9C27B0),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purpleAccent.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: _loading
                          ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        "Update",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Add some bottom padding
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}