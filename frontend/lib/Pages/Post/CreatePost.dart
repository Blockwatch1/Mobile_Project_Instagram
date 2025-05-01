import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:insta/Models/ActionResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Services/PostService.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _addPostPageState();
}

class _addPostPageState extends State<CreatePostPage> {
  bool _loading = false;
  PostService service = PostService();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _imageUrlController = TextEditingController();
  bool isThread = false;

  File? _selectedFile;
  String? selectedText;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false
    );

    if(result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    } else {
      setState(() {
        _selectedFile = null;
      });
    }
  }

  Future<void> sendPost() async {
    setState(() {
      _loading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    ActionResponse response = await service.addPostOrThread(
        path: 'create-post',
        token: prefs.getString('token'),
        description: _descriptionController.text,
        isThread: isThread,
        selectedFilePath: _selectedFile?.path
    );

    if (response.success) {
      setState(() {
        _loading = false;
      });
      Navigator.of(context).pushReplacementNamed('/home');
      return;
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
          "Create Post",
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Description Field
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.purpleAccent.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                margin: EdgeInsets.only(bottom: 24),
                child: TextField(
                  onChanged: (value){
                    setState(() {
                      selectedText = value;
                    });
                  },
                  controller: _descriptionController,
                  keyboardType: TextInputType.multiline,
                  minLines: 6,
                  maxLines: 16,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "What's on your mind?",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    contentPadding: EdgeInsets.all(16),
                    border: InputBorder.none,
                  ),
                ),
              ),

              // (only shown if not a thread)
              if (!isThread)
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.purpleAccent.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  margin: EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: ListTile(
                          leading: Text("Pick an image", style: TextStyle(color: Colors.grey[400], fontSize: 17),),
                          trailing: GestureDetector(
                            onTap: () => _pickFile(),
                            child: Icon(
                              Icons.image,
                              color: Colors.purpleAccent,
                            ),
                          )

                        )
                      ),

                      // Image Preview
                      if (_selectedFile != null)
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _selectedFile!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: Colors.grey[400],
                                        size: 40,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Invalid image URL",
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

              // Thread Option
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.purpleAccent.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: EdgeInsets.only(bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Post Type",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isThread = false;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: !isThread
                                    ? Colors.purpleAccent.withOpacity(0.2)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: !isThread
                                      ? Colors.purpleAccent
                                      : Colors.grey.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.photo,
                                    color: !isThread
                                        ? Colors.purpleAccent
                                        : Colors.grey,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Regular Post",
                                    style: TextStyle(
                                      color: !isThread
                                          ? Colors.purpleAccent
                                          : Colors.grey,
                                      fontWeight: !isThread
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isThread = true;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isThread
                                    ? Colors.purpleAccent.withOpacity(0.2)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isThread
                                      ? Colors.purpleAccent
                                      : Colors.grey.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.chat_bubble_outline,
                                    color: isThread
                                        ? Colors.purpleAccent
                                        : Colors.grey,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Thread",
                                    style: TextStyle(
                                      color: isThread
                                          ? Colors.purpleAccent
                                          : Colors.grey,
                                      fontWeight: isThread
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Post Button
              if((isThread && selectedText != null && !selectedText!.isEmpty) || (!isThread && _selectedFile != null))
                GestureDetector(
                  onTap: _loading ? null : sendPost,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFE040FB),
                          Color(0xFF9C27B0),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purpleAccent.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
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
                        "Post",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ,
            ],
          ),
        ),
      ),
    );
  }
}