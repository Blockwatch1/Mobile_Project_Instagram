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
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: (widget._user.pfpPath != null && widget._user.pfpPath!.isNotEmpty)
                    ? NetworkImage(widget._user.pfpPath!)
                    : null,
                child: (widget._user.pfpPath == null || widget._user.pfpPath!.isEmpty)
                    ? Text(
                 widget._user.name!.isNotEmpty ? widget._user.name![0].toUpperCase() : '',
                  style: const TextStyle(color: Colors.white),
                )
                    : null,
                radius: 24,
                backgroundColor: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget._user.name!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '@${widget._user.username}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
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
