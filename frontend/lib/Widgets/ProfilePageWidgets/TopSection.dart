import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/User.dart';

class TopSection extends StatelessWidget {
  final User? _user;
  final bool isSameUser;
  const TopSection({super.key, required user, required this.isSameUser}) : _user = user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.purpleAccent,
                width: 2,
              ),
            ),
            child: CircleAvatar(
              backgroundImage: (_user?.pfpPath != null) ? NetworkImage(_user!.pfpPath!) : null,
              child: (_user?.pfpPath == null)
                  ? Text(
                _user!.name.isNotEmpty ? _user!.name[0].toUpperCase() : '',
                style: const TextStyle(color: Colors.white),
              )
                  : null,
              radius: 50,
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 10.0,),
          Text("@${_user?.username}"),
          SizedBox(height: 20.0,),
          Padding(
           padding: EdgeInsets.only(left: 20.0, right: 20.0),
           child:  Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               GestureDetector(
                 onTap: () {
                   Map<String, dynamic> args = {
                     'followings': _user?.following,
                     'name': _user?.name
                   };

                   Navigator.of(context).pushNamed('/followingsList', arguments: args);
                 },
                 child: Column(
                   children: [
                     Text("${_user?.following?.length}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                     SizedBox(height: 5,),
                     Text("following")
                   ],
                 ),
               ),
               GestureDetector(
                 onTap: () {
                   Map<String, dynamic> args = {
                     'followers': _user?.followedBy,
                     'name': _user?.name
                   };

                   Navigator.of(context).pushNamed('/followersList', arguments: args);
                 },
                 child: Column(
                   children: [
                     Text("${_user?.followedBy?.length}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                     SizedBox(height: 5,),
                     Text("followers")
                   ],
                 ),
               ),
               GestureDetector(
                 child: Column(
                   children: [
                     Text("${_user?.following?.length}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                     SizedBox(height: 5,),
                     Text("following")
                   ],
                 ),
               ),
             ],
           ),
         ),
          SizedBox(height: 20.0,),
          GestureDetector(
            child: Center(
              child: Container(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.purpleAccent,
                ),
                child: (isSameUser != true ?
                Center(
                  child: GestureDetector(
                    child: Text("Follow", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                  )
                )
                : Center(
                    child: GestureDetector(
                      child: Text("Edit Profile", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                    ),
                  )
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0,),
          Text("${_user?.bio}", style: TextStyle(fontSize: 12, color: Colors.white),)
        ],
      ),
    );
  }
}
