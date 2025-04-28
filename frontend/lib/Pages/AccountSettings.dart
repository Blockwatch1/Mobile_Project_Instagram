import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountSettings extends StatefulWidget {
  final String _email;
  final String _password;
  final String _name;
  final dynamic _userId;
  final String _lastLogin;
  final String? _lastUsernameChange;
  const AccountSettings({super.key, required email, required password, required userId, required lastLogin, lastUsernameChange, required name}) : _email = email, _password = password,
        _userId = userId, _lastLogin = lastLogin, _lastUsernameChange = lastUsernameChange, _name = name;

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {

  String _formatDate(String? dateString) {
    if(dateString == null){
      return "Never Changed";
    }

    try {
      DateTime dateTime = DateTime.parse(dateString);
      DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');

      return formatter.format(dateTime);
    } catch (e) {
      print("Error formatting date: $e");
      return "Invalid Date";
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedLastLogin = _formatDate(widget._lastLogin);
    String formattedLastUsernameChange = _formatDate(widget?._lastUsernameChange);

    return Scaffold(
        appBar: AppBar(
            title: Center(child: Text("Settings", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 30, fontFamily: "Insta"),),)
        ),
        body: SingleChildScrollView( // Added SingleChildScrollView here
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 25.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      "User Information",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 40.0, fontFamily: "Insta", fontWeight: FontWeight.bold),
                    ),
                  ),

                  Card(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Display Name",
                            style: TextStyle(color: Colors.purple, fontSize: 14.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8.0,),
                          Text(
                            widget._name,
                            style: TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Card(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email",
                            style: TextStyle(color: Colors.purple, fontSize: 14.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8.0,),
                          Text(
                            widget._email,
                            style: TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Card(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "User Id",
                            style: TextStyle(color: Colors.purple, fontSize: 14.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8.0,),
                          Text(
                            "${widget._userId}",
                            style: TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Card(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Last Login Date",
                            style: TextStyle(color: Colors.purple, fontSize: 14.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8.0,),
                          Text(
                            formattedLastLogin,
                            style: TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Card(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Last Username Change",
                            style: TextStyle(color: Colors.purple, fontSize: 14.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8.0,),
                          Text(
                            formattedLastUsernameChange,
                            style: TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20.0,),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      "Update Profile Info",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 40.0, fontFamily: "Insta", fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
