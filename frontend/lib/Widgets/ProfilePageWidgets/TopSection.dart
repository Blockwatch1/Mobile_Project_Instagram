import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/User.dart';

class TopSection extends StatelessWidget {
  final User? _user;
  final bool isSameUser;
  const TopSection({super.key, required user, required this.isSameUser})
      : _user = user;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.purpleAccent.withOpacity(0.2),
            Color(0xFF121212),
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Profile Image
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
                backgroundImage: (_user?.pfpPath != null)
                    ? NetworkImage(_user!.pfpPath!)
                    : null,
                child: (_user?.pfpPath == null)
                    ? Text(
                  _user!.name!.isNotEmpty
                      ? _user!.name![0].toUpperCase()
                      : '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                )
                    : null,
                radius: 50,
                backgroundColor: Colors.purpleAccent.withOpacity(0.5),
              ),
            ),

            SizedBox(height: 16.0),

            // Username
            Text(
              "@${_user?.username}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Bio
            if (_user?.bio != null && _user!.bio!.isNotEmpty)
              Container(
                margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Colors.purpleAccent.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  "${_user?.bio}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),

            SizedBox(height: 20.0),

            // Stats Row
            Container(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Posts count
                  _buildStatColumn(
                    context,
                    "${_user?.posts?.length ?? 0}",
                    "posts",
                    onTap: () {},
                  ),

                  _buildDivider(),

                  // Followers count
                  _buildStatColumn(
                    context,
                    "${_user?.followedBy?.length ?? 0}",
                    "followers",
                    onTap: () {
                      Map<String, dynamic> args = {
                        'followers': _user?.followedBy,
                        'name': _user?.name
                      };
                      Navigator.of(context).pushNamed('/followersList', arguments: args);
                    },
                  ),

                  _buildDivider(),

                  // Following count
                  _buildStatColumn(
                    context,
                    "${_user?.following?.length ?? 0}",
                    "following",
                    onTap: () {
                      Map<String, dynamic> args = {
                        'followings': _user?.following,
                        'name': _user?.name
                      };
                      Navigator.of(context).pushNamed('/followingsList', arguments: args);
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.0),

            // Follow/Edit Button
            GestureDetector(
              onTap: () {
                // Add your follow/edit logic here
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFE040FB),
                      Color(0xFF9C27B0),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purpleAccent.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  isSameUser ? "Edit Profile" : "Follow",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(
      BuildContext context,
      String count,
      String label, {
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }
}