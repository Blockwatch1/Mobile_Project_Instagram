import 'dart:async';

import 'package:flutter/material.dart';
import 'package:insta/Models/ActionResponse.dart';
import 'package:insta/Models/User.dart';
import 'package:insta/Services/UserService.dart';
import 'package:insta/Widgets/UserCard.dart';
import 'package:insta/Widgets/UserList.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchText = TextEditingController();
  bool _loading = false;
  List<dynamic> _users = [];
  bool noUsers = true;
  final UserService _searchService = UserService();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchText.addListener(_onSearch);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchText.removeListener(_onSearch);
    _searchText.dispose();
    super.dispose();
  }

  Future<void> _onSearch() async {
    if(_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      String query = _searchText.text;

      if (query.isEmpty) {
        setState(() {
          _users = [];
          noUsers = true;
          _loading = false;
        });
        return;
      }

      setState(() {
        _loading = true;
        noUsers = false;
        _users = [];
      });

      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? token = prefs.getString('token');

        ActionResponse getUsers = await _searchService.getNoBody('search/$query', token);

        if (getUsers.success) {
          if (getUsers.data is List && getUsers.data.isNotEmpty) {
            setState(() {
              _users = getUsers.data;
              noUsers = false;
            });
          } else {
            setState(() {
              _users = [];
              noUsers = true;
            });
          }
        } else {
          print('API Error: ${getUsers.message}');
          setState(() {
            _users = [];
            noUsers = true;
          });
        }

      } catch (e) {
        print('API call failed: $e');
        setState(() {
          _users = [];
          noUsers = true;
        });
      } finally {
        setState(() {
          _loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _searchText,
            decoration: InputDecoration(
              hintText: 'Search a User...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              suffixIcon: const Icon(Icons.search),
            ),
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : noUsers
            ? const Center(
          child: Text(
            "No users found!",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 60.0,
              fontWeight: FontWeight.bold,
              fontFamily: "Insta"
            ),
          ),
        )
            : Column(
          children: [
            const SizedBox(height: 30,),
            Expanded(
              child: UserList(users: _users)
            ),
          ],
        )
    );
  }
}
