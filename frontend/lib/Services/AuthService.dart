import 'dart:convert';

import 'package:insta/Models/ActionResponse.dart';
import 'package:insta/Models/HTTPConfig.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final _baseUrl = dotenv.env['BASE_URL'];

  Future<ActionResponse> auth(Map<String, dynamic> data, String path) async {
    final String starting = '$_baseUrl/user';

    try {

      final httpConfigObj = HTTPConfig.giveHeaders(Uri.parse('$starting/$path'),
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