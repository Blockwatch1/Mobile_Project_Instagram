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
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Search",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: "Insta",
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.purpleAccent.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchText,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search for users...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: Icon(Icons.search, color: Colors.purpleAccent),
                  suffixIcon: _searchText.text.isNotEmpty
                      ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey[400]),
                    onPressed: () {
                      _searchText.clear();
                    },
                  )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.purpleAccent,
            ),
            SizedBox(height: 16),
            Text(
              "Searching...",
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (_searchText.text.isEmpty) {
      return _buildEmptySearchState();
    }

    if (noUsers) {
      return _buildNoResultsState();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Text(
                "Results",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.purpleAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${_users.length}",
                  style: TextStyle(
                    color: Colors.purpleAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: UserList(users: _users),
        ),
      ],
    );
  }

  Widget _buildEmptySearchState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 70,
            color: Colors.grey[700],
          ),
          SizedBox(height: 16),
          Text(
            "Search for users",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: "Insta",
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Find people by name or username",
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_off,
            size: 70,
            color: Colors.grey[700],
          ),
          SizedBox(height: 16),
          Text(
            "No users found",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: "Insta",
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Try a different search term",
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}