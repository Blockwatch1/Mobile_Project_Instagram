import 'dart:convert';

import 'package:insta/Models/ActionResponse.dart';
import 'package:insta/Models/HTTPConfig.dart';
import 'package:http/http.dart' as http;

class Postservice {
  final String _baseUrl = 'http://192.168.1.19:3000/post';

  Future<ActionResponse> getPosts(String path, String? token) async {
    try {
      final httpConfigObj = HTTPConfig.giveHeaders(Uri.parse('$_baseUrl/$path'), token: token);


      final response = await http.post(httpConfigObj.uri, headers: httpConfigObj.headers);

      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final ActionResponse actionResponse = ActionResponse.fromJson(responseBody);

      return actionResponse;

    } catch(e){
      print('API call failed: $e');
      throw Exception('Failed to sign up: $e');
    }
  }
}