import 'dart:convert';

import 'package:insta/Models/ActionResponse.dart';
import 'package:insta/Models/HTTPConfig.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String _baseUrl = 'http://192.168.1.109:4001/user';

  Future<ActionResponse> auth(Map<String, dynamic> data, String path) async {
    try {

      final httpConfigObj = HTTPConfig.giveHeaders(Uri.parse('$_baseUrl/$path'),
      body: jsonEncode(data));


      final response = await http.post(httpConfigObj.uri, body: httpConfigObj.body, headers: httpConfigObj.headers);

      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final ActionResponse actionResponse = ActionResponse.fromJson(responseBody);

      return actionResponse;

    } catch(e){
      print('API call failed: $e');
      throw Exception('Failed to sign up: $e');
    }
  }
}