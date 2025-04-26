import 'package:flutter/material.dart';
import 'package:insta/Models/ActionResponse.dart';
import 'package:insta/Services/AuthService.dart';
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
  bool _loading = false;

  AuthService _authService = AuthService();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void addUserToLocalStorage(String? token) async {
    if (token != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
    }
  }

  Future<void> _login() async {
    try {
      setState(() {
        _loading = true;
      });

      final email = _emailController.text;
      final password = _passwordController.text;

      final Map<String, dynamic> loginData = {
        'email': email,
        'password': password
      };

      ActionResponse response = await _authService.auth(loginData, 'login');

      print(response.success);
      print(response.data);

      if (response.success) {
        if (!mounted) return;

        addUserToLocalStorage(response.token);
        
        Navigator.pushNamed(context, '/home');

        setState(() {
          _loading = false;
        });
      } else {
        if (!mounted) return;
        Alert(
          context: context,
          type: AlertType.error,
          title: "Login Failed",
          desc: response.message ?? "An unknown error occurred.",
          buttons: [
            DialogButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();

        setState(() {
          _loading = false;
        });
      }

    } catch (e) {
      setState(() {
        _loading = false;
      });
      print('Could not log in: $e');
      if (!mounted) return;
      Alert(
        context: context,
        type: AlertType.error,
        title: "Login Error",
        desc: "An error occurred during login. Please try again.",
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Interlinked Log In",
                style: TextStyle(
                    fontSize: 50,
                    fontFamily: "Insta",
                    color: Colors.purpleAccent),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              InputFieldLogin(
                controller: _emailController,
                hintText: "Email",
              ),
              const SizedBox(height: 20),
              InputFieldLogin(
                controller: _passwordController,
                hintText: "Password",
                isPass: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _login,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Submit"),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                child: Text(
                  "Sign Up?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/signup');
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class InputFieldLogin extends StatelessWidget {
  final bool? isPass;
  final String hintText;
  final TextEditingController _controller;

  InputFieldLogin({
    super.key,
    required TextEditingController controller,
    required this.hintText,
    this.isPass,
  }) : _controller = controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        obscureText: isPass ?? false,
        controller: _controller,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        ),
      ),
    );
  }
}