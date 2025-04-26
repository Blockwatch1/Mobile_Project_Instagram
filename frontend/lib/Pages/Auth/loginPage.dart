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

  TextEditingController _emailController= TextEditingController();
  TextEditingController _passwordController= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              Text("Interlinked Log In",style: TextStyle(fontSize: 50, fontFamily: "Insta",color: Colors.purpleAccent),textAlign: TextAlign.center,),
              InputFieldLogin(controller: _emailController,hintText: "Email",),
              InputFieldLogin(controller: _passwordController,hintText: "Password",isPass: true, ),
              ElevatedButton(onPressed:()async{
                var url =
                Uri.parse('http://localhost:4001/user/login');
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
                  Navigator.pushNamed(context, '/signup');
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
  final TextEditingController _controller;

  InputFieldLogin({
    super.key,
    required TextEditingController controller,
    required this.hintText,
    this.isPass
  }) : _controller = controller;


  @override
  Widget build(BuildContext context) {
    isPass= isPass?? false;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        obscureText: isPass == true ? true : false,
        controller: _controller,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a username';
          }
          return null;
        },
      ),
    );
  }
}
