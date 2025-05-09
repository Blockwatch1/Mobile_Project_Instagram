import 'dart:convert';

import '../Models/ActionResponse.dart';
import '../Models/HTTPConfig.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';



class CommentService {
  final _baseUrl = dotenv.env['BASE_URL'];

  Future<ActionResponse> GET(String path, String? token) async {
    final String starting = '$_baseUrl/comment';

    try {
      final httpConfigObj = HTTPConfig.giveHeaders(Uri.parse('$starting/$path'), token: token);

      final response = await http.get(httpConfigObj.uri, headers: httpConfigObj.headers);

      if(response.statusCode != 200) {
        print('THERE HAS BEEN SOMETHING WRONG IN THE FETCHING REQUEST\n\n: ${response.statusCode}');
      }

      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final ActionResponse actionResponse = ActionResponse.fromJson(responseBody);

      return actionResponse;

    } catch(e){
      print('API call failed: $e');
      throw Exception('Failed to fetch comments: $e');
    }

  }
  Future<ActionResponse> sendComment(int postId,String text,String? token) async{
    final String starting = '$_baseUrl/comment/create/$postId';

    try {
      final httpConfigObj = HTTPConfig.giveHeaders(Uri.parse(starting), token: token);

      final response = await http.post(httpConfigObj.uri, headers: httpConfigObj.headers,
          body:
          jsonEncode(
              {
                "content" : text
              }
          )
      );
      print("lek hl response : ${response.body}");

      if(response.statusCode != 200) {
        print('THERE HAS BEEN SOMETHING WRONG IN POSTING YOUR COMMENT\n\n: ${response.statusCode}');
      }

      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final ActionResponse actionResponse = ActionResponse.fromJson(responseBody);

      return actionResponse;

    } catch(e){
      print('API call failed: $e');
      throw Exception('Failed to fetch comments: $e');
    }


  }
  Future<ActionResponse> DELETE_NO_BODY(String path, String? token) async {
    final String starting = '$_baseUrl/comment';

    try {
      final httpConfigObj = HTTPConfig.giveHeaders(Uri.parse('$starting/$path'), token: token);

      final response = await http.delete(httpConfigObj.uri, headers: httpConfigObj.headers);

      if(response.statusCode != 200) {
        print('THERE HAS BEEN SOMETHING WRONG IN THE FETCHING REQUEST\n\n: ${response.statusCode}');
      }

      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final ActionResponse actionResponse = ActionResponse.fromJson(responseBody);

      return actionResponse;
    } catch(e){
      print('API call failed: $e');
      throw Exception('Failed to fetch comments: $e');
    }

  }
}