import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:insta/Models/ActionResponse.dart';
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
  TextEditingController _bioController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();


  String _newName = '';
  String _newUsername = '';
  String? _newPfpPath;
  String? _newBio;

  File? _selectedFile;

  @override
  void initState() {
    super.initState();
    _bioController.text = widget.user.bio ?? '';
    _nameController.text = widget.user.name ?? '';
    _usernameController.text = widget.user.username ?? '';

    _newName = widget.user.name ?? '';
    _newBio = widget.user.bio;
    _newPfpPath = widget.user.pfpPath;
    _newUsername = widget.user.username ?? '';
  }

  @override
  void dispose() {
    _bioController.dispose();
    _nameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false
    );

    if(result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _newPfpPath = _selectedFile!.path;
      });
    } else {
      setState(() {
        _selectedFile = null;

        _newPfpPath = widget.user.pfpPath;
      });
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      _loading = true;
    });

    UserService service = UserService();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, dynamic> updateData = {};


    if (_nameController.text != widget.user.name) {
      updateData['name'] = _nameController.text;
    }


    if (_usernameController.text != widget.user.username) {
      updateData['username'] = _usernameController.text;
    }


    if ((_bioController.text ?? '') != (widget.user.bio ?? '')) {
      updateData['bio'] = _bioController.text;
    }


    if (_selectedFile != null) {
      updateData['image'] = _selectedFile!.path;
    }


    if (updateData.isNotEmpty && token != null) {
      ActionResponse response = await service.updateProfile(updateData, token);

      if (response.success) {

        if (response.data != null && response.data['user'] != null) {

          prefs.setString('user', jsonEncode(response.data['user']));
        } else {


          if (updateData.containsKey('name')) await prefs.setString('name', updateData['name']);
          if (updateData.containsKey('username')) await prefs.setString('username', updateData['username']);
          if (updateData.containsKey('bio')) await prefs.setString('bio', updateData['bio']);


        }


        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context){
              return ProfilePage(userId: widget.user.userId);
            })
        );

      } else {

        print('Profile update failed: ${response.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: ${response.message}')),
        );
      }
    } else if (updateData.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No changes to save.')),
      );
    } else if (token == null) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication token missing.')),
      );
    }


    setState(() {
      _loading = false;
    });
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
                      child: GestureDetector(
                        onTap: _pickFile,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.purpleAccent.withOpacity(0.3),

                          backgroundImage: _selectedFile != null
                              ? FileImage(_selectedFile!) as ImageProvider
                              : (widget.user.pfpPath != null
                              ? NetworkImage(widget.user.pfpPath!)
                              : null),
                          child: (_selectedFile == null && (widget.user.pfpPath == null || widget.user.pfpPath!.isEmpty))
                              ? Text(
                            _nameController.text.isNotEmpty
                                ? _nameController.text[0].toUpperCase()
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
                          hintText: "Change your Username",
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


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _loading ? null : _updateProfile,
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


              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}