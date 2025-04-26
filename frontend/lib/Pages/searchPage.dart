import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _searchText,
            decoration: InputDecoration(
                hintText: 'Search a Post...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                suffixIcon: GestureDetector(
                  child: Icon(Icons.search),
                )

            ),
          ) ,
        )
    );
  }

}