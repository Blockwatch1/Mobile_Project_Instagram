import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class Loginpage extends StatefulWidget {
  Loginpage({super.key});
  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  @override
  void initState(){
    super.initState();
  }
  void addUserToLocalStorage(Map decoded)async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setString('token', decoded['token']);

  }

  bool signUp=false;
  TextEditingController _userNameController= TextEditingController();
  TextEditingController _emailController= TextEditingController();
  TextEditingController _passwordController= TextEditingController();
  TextEditingController _nameController= TextEditingController();
  @override
  Widget build(BuildContext context) {
    if(signUp) {
      return Scaffold(
        body:  Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              Text("Sign Up with Email",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.orangeAccent),textAlign: TextAlign.center,),
              InputFieldLogin(userNameController: _userNameController,hintText: "Username",),
              InputFieldLogin(userNameController: _nameController,hintText: "Name",),
              InputFieldLogin(userNameController: _emailController,hintText: "Email",),
              InputFieldLogin(userNameController: _passwordController,hintText: "Password",isPass: true,),
              ElevatedButton(onPressed: (){}, child: Text("Submit")),
              GestureDetector(
                child: Text("Log in?",style: TextStyle(fontWeight: FontWeight.bold),),
                onTap: (){
                  setState(() {
                    signUp=false;
                  });
                },
              )
            ],
          ),
      );
    }
    return Scaffold(
      body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              Text("Log In with Email",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.orangeAccent),textAlign: TextAlign.center,),
              InputFieldLogin(userNameController: _emailController,hintText: "Email",),
              InputFieldLogin(userNameController: _passwordController,hintText: "Password",isPass: true,),
              ElevatedButton(onPressed:()async{
                var url =
                Uri.parse('http://10.0.2.2:4001/user/login');
                try{
                  var response = await http.post(url,
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: convert.jsonEncode(<String, String>{
                        "email": _emailController.text,
                        "password": _passwordController.text
                      }));
                  if (response.statusCode == 200) {
                    Map<String, dynamic> decoded = convert
                        .jsonDecode(response.body) as Map<String, dynamic>;
                    addUserToLocalStorage(decoded);
                    Alert(
                        context: context,
                        title: "Login Success",
                        desc: "Welcome ${decoded['user']['username']}",
                        buttons: [
                          DialogButton(child: Text("Ok"), onPressed: () {})
                        ]).show();
                  } else {
                    Alert(context: context, title: response.body,desc: response.statusCode.toString(), buttons: [
                      DialogButton(child: Text("Ok"), onPressed: () {})
                    ]).show();
                  }
                }catch(e){
                Alert(context: context, title: e.toString(), buttons: [
                DialogButton(child: Text("Ok"), onPressed: () {})
                ]).show();
                }
              }, child: Text("Submit")),
              GestureDetector(
                child: Text("Sign Up?",style: TextStyle(fontWeight: FontWeight.bold),),
                onTap: (){
                  setState(() {
                    signUp=true;
                  });
                },
              )
            ],
          ),

    );
  }
}

class InputFieldLogin extends StatelessWidget {
  bool? isPass=false;
  String hintText;
  InputFieldLogin({
    super.key,
    required TextEditingController userNameController,
    required this.hintText,
    this.isPass
  }) : _userNameController = userNameController;

  final TextEditingController _userNameController;

  @override
  Widget build(BuildContext context) {
    isPass= isPass?? false;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        keyboardType: isPass! ? TextInputType.visiblePassword : TextInputType.text,
        controller:_userNameController ,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
          )
        ),
      ),
    );
  }
}
