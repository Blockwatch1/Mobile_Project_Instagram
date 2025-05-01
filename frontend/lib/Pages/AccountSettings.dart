import 'package:flutter/material.dart';
import 'package:insta/Pages/Auth/loginPage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountSettings extends StatefulWidget {
  final String _email;
  final String _password;
  final String _name;
  final dynamic _userId;
  final String _lastLogin;
  final String? _lastUsernameChange;
  const AccountSettings({
    super.key,
    required email,
    required password,
    required userId,
    required lastLogin,
    lastUsernameChange,
    required name
  }) : _email = email,
        _password = password,
        _userId = userId,
        _lastLogin = lastLogin,
        _lastUsernameChange = lastUsernameChange,
        _name = name;

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
    String formattedLastUsernameChange = _formatDate(widget._lastUsernameChange);

    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF9C27B0),
                Color(0xFFE040FB),
              ],
            ),
          ),
        ),
        title: Text(
          "Account Settings",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: "Insta",
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            // Profile Header
            Container(
              width: MediaQuery.of(context).size.width, // Ensure full width
              padding: EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFE040FB).withOpacity(0.8),
                    Color(0xFF121212),
                  ],
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.purpleAccent.withOpacity(0.5),
                    child: Text(
                      widget._name.isNotEmpty ? widget._name[0].toUpperCase() : "?",
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget._name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget._email,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
                    child: Text(
                      "ACCOUNT INFORMATION",
                      style: TextStyle(
                        color: Colors.purpleAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  _buildInfoCard(
                    title: "Display Name",
                    value: widget._name,
                    icon: Icons.person,
                  ),

                  _buildInfoCard(
                    title: "Email Address",
                    value: widget._email,
                    icon: Icons.email,
                  ),

                  _buildInfoCard(
                    title: "User ID",
                    value: "${widget._userId}",
                    icon: Icons.fingerprint,
                    isMonospace: true,
                  ),

                  _buildInfoCard(
                    title: "Last Login",
                    value: formattedLastLogin,
                    icon: Icons.login,
                  ),

                  _buildInfoCard(
                    title: "Last Username Change",
                    value: formattedLastUsernameChange,
                    icon: Icons.edit,
                  ),

                  SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 16.0, top: 8.0),
                    child: Text(
                      "ACCOUNT ACTIONS",
                      style: TextStyle(
                        color: Colors.purpleAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  _buildActionButton(
                    title: "Edit Profile",
                    icon: Icons.edit,
                    onTap: () {
                      // Add your edit profile logic here
                    },
                  ),

                  _buildActionButton(
                    title: "Change Password",
                    icon: Icons.lock,
                    onTap: () {
                      // Add your change password logic here
                    },
                  ),

                  _buildActionButton(
                    title: "Log out",
                    icon: Icons.logout,
                    onTap: () async{
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.remove('user');
                      await prefs.remove('token');
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Loginpage()),
                          (Route<dynamic> route) => false
                      );
                    },
                  ),

                  SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    bool isMonospace = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          splashColor: Colors.purpleAccent.withOpacity(0.1),
          highlightColor: Colors.purpleAccent.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.purpleAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.purpleAccent,
                    size: 22,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        value,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: isMonospace ? 'monospace' : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF9C27B0).withOpacity(0.8),
            Color(0xFFE040FB).withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.purpleAccent.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          splashColor: Colors.white.withOpacity(0.1),
          highlightColor: Colors.white.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 22,
                ),
                SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white70,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}