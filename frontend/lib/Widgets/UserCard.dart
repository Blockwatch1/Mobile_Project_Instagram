import 'package:flutter/material.dart';

import '../Models/User.dart';

class UserCard extends StatefulWidget {
  final User _user;
  const UserCard({super.key, required User user}) : _user = user;

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Map<String, dynamic> args = {'userId': widget._user.userId};
        Navigator.of(context).pushNamed('/profilePage', arguments: args);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Colors.purpleAccent.withOpacity(0.2),
            width: 1,
          ),
        ),
        color: Color(0xFF1E1E1E),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Profile Image
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.purpleAccent,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purpleAccent.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundImage: (widget._user.pfpPath != null && widget._user.pfpPath!.isNotEmpty)
                      ? NetworkImage(widget._user.pfpPath!)
                      : null,
                  child: (widget._user.pfpPath == null || widget._user.pfpPath!.isEmpty)
                      ? Text(
                    widget._user.name!.isNotEmpty ? widget._user.name![0].toUpperCase() : '?',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  )
                      : null,
                  radius: 28,
                  backgroundColor: Colors.purpleAccent.withOpacity(0.3),
                ),
              ),

              const SizedBox(width: 16),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget._user.name!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      '@${widget._user.username}',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget._user.bio != null && widget._user.bio!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          widget._user.bio!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 13,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}