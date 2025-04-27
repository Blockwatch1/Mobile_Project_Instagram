import 'dart:convert';

import 'package:insta/Models/ActionResponse.dart';
import 'package:insta/Models/HTTPConfig.dart';
import 'package:http/http.dart' as http;

class PostService {
  final String _baseUrl = 'http://192.168.1.109:4001/post';

  Future<ActionResponse> getPosts(String path, String? token) async {
    try {
      final httpConfigObj = HTTPConfig.giveHeaders(Uri.parse('$_baseUrl/$path'), token: token);

      print('TOKENNNN\n\n: $token');
      print('\n\nTHIS IS THE PATH: $path');

      print(httpConfigObj.uri);

      final response = await http.get(httpConfigObj.uri, headers: httpConfigObj.headers);

      if(response.statusCode != 200) {
        print('HEY THER HAS BEEN SOMETHING WRONG IN THE FETCHING REQUEST\n\n: ${response.statusCode}');
      }

      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final ActionResponse actionResponse = ActionResponse.fromJson(responseBody);

      return actionResponse;

    } catch(e){
      print('API call failed: $e');
      throw Exception('Failed to fetch posts: $e');
    }
  }
}