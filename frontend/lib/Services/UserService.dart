import 'dart:convert';
import 'dart:io';

import 'package:insta/Models/ActionResponse.dart';
import 'package:insta/Models/HTTPConfig.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart';

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
  Future<ActionResponse> updateProfile(Map<String,dynamic>? data, String? token) async{
    final String starting = '$_baseUrl/user/update-profile';

    try {

      final httpConfigObj = HTTPConfig.giveHeaders(Uri.parse(starting), token: token);


      var request = http.MultipartRequest('PUT', httpConfigObj.uri);
      request.headers['Authorization'] = httpConfigObj.headers['Authorization']!;

      if(data?['name'] != null) {
        request.fields['name'] = data?['name']!;
      }

      if(data?['username'] != null) {
        request.fields['username'] = data?['username']!;
      }

      if(data?['bio'] != null) {
        request.fields['bio'] = data?['bio']!;
      }

      if (data?['image'] != null) {
        final file = File(data?['image']!);

        if (await file.exists()) {
          final fileBytes = await file.readAsBytes();
          final fileName = data?['image']!.split('/').last;

          final fileExtension = fileName.split('.').last.toLowerCase();
          String mimeType;

          switch (fileExtension) {
            case 'jpg':
            case 'jpeg':
              mimeType = 'image/jpeg';
              break;
            case 'png':
              mimeType = 'image/png';
              break;
            case 'gif':
              mimeType = 'image/gif';
              break;
            default:
              mimeType = 'image/jpeg';
          }

          request.files.add(
              http.MultipartFile.fromBytes(
                  'image',
                  fileBytes,
                  filename: fileName,
                  contentType: MediaType.parse(mimeType)
              )
          );

          print('Added file: $fileName with mime type: $mimeType');
        } else {
          print('File does not exist: ${data?['image']!}');
          return ActionResponse(success: false, message: "Image file not found");
        }
      }
      final streamResponse = await request.send();
      final response = await http.Response.fromStream(streamResponse);

      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final ActionResponse actionResponse = ActionResponse.fromJson(responseBody);

      return actionResponse;

    } catch(e){
      print('API call failed: $e');
      throw Exception('Failed to sign up: $e');
    }
  }

}