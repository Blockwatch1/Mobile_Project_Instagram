import 'dart:convert';

import 'package:insta/Models/ActionResponse.dart';
import 'package:insta/Models/HTTPConfig.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../Models/User.dart';


class PostService {
  final _baseUrl = dotenv.env['BASE_URL'];

  Future<ActionResponse> GET(String path, String? token) async {
    print("5od he url : $_baseUrl");
    final String starting = '$_baseUrl/post';

    try {
      final httpConfigObj = HTTPConfig.giveHeaders(Uri.parse('$starting/$path'), token: token);

      final response = await http.get(httpConfigObj.uri, headers: httpConfigObj.headers);

      if(response.statusCode != 200) {
        print('HEY THER HAS BEEN SOMETHING WRONG IN THE FETCHING REQUEST\n\n: ${response.statusCode}');
      }

      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      print(responseBody);
      final ActionResponse actionResponse = ActionResponse.fromJson(responseBody);

      return actionResponse;

    } catch(e){
      print('API call failed: $e');
      throw Exception('Failed to fetch posts: $e');
    }
  }
  Future<ActionResponse> addPostOrThread(String path, String? token,String description, String imageUrl,bool isThread)async{
    final String starting = '$_baseUrl/post';
    try {
      final httpConfigObj = HTTPConfig.giveHeaders(Uri.parse('$starting/$path'), token: token);
      //const { description, imageUrl, isThread } = req.body;
      final response = await http.post(httpConfigObj.uri, headers: httpConfigObj.headers, body:
        jsonEncode(
        {
          "description": description,
          "imageUrl": imageUrl,
          "isThread": isThread
        }
        )

      );
      if(response.statusCode != 200) {
        print('HEY THER HAS BEEN SOMETHING WRONG IN THE FETCHING REQUEST\n\n: ${response.statusCode}');
      }

      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      print(responseBody);
      final ActionResponse actionResponse = ActionResponse.fromJson(responseBody);

      return actionResponse;

    } catch(e){
      print('API call failed: $e');
      throw Exception('Failed to fetch posts: $e');
    }

  }

}