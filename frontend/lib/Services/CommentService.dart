import 'dart:convert';

import '../Models/ActionResponse.dart';
import '../Models/HTTPConfig.dart';
import 'package:http/http.dart' as http;


class CommentService {
  final String _baseUrl = 'http://192.168.177.200:4001/comment';

  Future<ActionResponse> GET(String path, String? token) async {
    try {
      final httpConfigObj = HTTPConfig.giveHeaders(Uri.parse('$_baseUrl/$path'), token: token);

      final response = await http.get(httpConfigObj.uri, headers: httpConfigObj.headers);

      if(response.statusCode != 200) {
        print('HEY THER HAS BEEN SOMETHING WRONG IN THE FETCHING REQUEST\n\n: ${response.statusCode}');
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