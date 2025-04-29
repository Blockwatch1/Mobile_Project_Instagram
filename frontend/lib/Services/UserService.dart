import 'dart:convert';

import 'package:insta/Models/ActionResponse.dart';
import 'package:insta/Models/HTTPConfig.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserService {
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

  Future<ActionResponse> getNoBody(String path, String? token) async {
    final String starting = '$_baseUrl/user';

    try {

      final httpConfigObj = HTTPConfig.giveHeaders(Uri.parse('$starting/$path'), token: token);


      final response = await http.get(httpConfigObj.uri, headers: httpConfigObj.headers);
      print("rou777777 ${response.body}");

      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final ActionResponse actionResponse = ActionResponse.fromJson(responseBody);

      return actionResponse;

    } catch(e){
      print('API call failed: $e');
      throw Exception('Failed to sign up: $e');
    }
  }

  Future<ActionResponse> putNoBody(String path, String? token) async {
    final String starting = '$_baseUrl/user';

    try {

      final httpConfigObj = HTTPConfig.giveHeaders(Uri.parse('$starting/$path'), token: token);


      final response = await http.put(httpConfigObj.uri, headers: httpConfigObj.headers);

      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final ActionResponse actionResponse = ActionResponse.fromJson(responseBody);

      return actionResponse;

    } catch(e){
      print('API call failed: $e');
      throw Exception('Failed to sign up: $e');
    }
  }
  Future<ActionResponse> updateProfile(int userId,Map<String,String?>data,String? token) async{
    final String starting = '$_baseUrl/user/update-profile';

    try {

      final httpConfigObj = HTTPConfig.giveHeaders(Uri.parse(starting), token: token);


      final response = await http.put(httpConfigObj.uri, headers: httpConfigObj.headers, body: 
          jsonEncode(data)
      );

      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final ActionResponse actionResponse = ActionResponse.fromJson(responseBody);

      return actionResponse;

    } catch(e){
      print('API call failed: $e');
      throw Exception('Failed to sign up: $e');
    }
  }

}