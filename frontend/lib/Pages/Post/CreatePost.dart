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
  Widget UrlField = const SizedBox(width: 0,height: 0,);
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _imageUrlController = TextEditingController();

  bool isThread=false;
  Future<void> sendPost()async{
    setState(() {
      _loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ActionResponse response = await service.addPostOrThread('create-post', prefs.getString('token'),_descriptionController.text , _imageUrlController.text, isThread);

    if(response.success) {
      setState(() {
        _loading = false;
      });
      Navigator.of(context).pushReplacementNamed('/home');
      return;
    }
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
                    color: Colors.white,
                  ),
                  alignment: Alignment.center,
                  child: _loading == true ? const CircularProgressIndicator() : Text("Post",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.black),),
                ),
              )
            ],
          )
        ],
      )),
    );
  }
}
