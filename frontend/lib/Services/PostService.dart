import 'dart:convert';
import 'dart:io';

import 'package:insta/Models/ActionResponse.dart';
import 'package:insta/Models/HTTPConfig.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart';

class PostService {
  final _baseUrl = dotenv.env['BASE_URL'];

  Future<ActionResponse> GET(String path, String? token) async {
    final String starting = '$_baseUrl/post';

    try {
      final httpConfigObj = HTTPConfig.giveHeaders(Uri.parse('$starting/$path'), token: token);

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

  Future<ActionResponse> addPostOrThread({
    required String path,
    String? token,
    required String description,
    String? selectedFilePath,
    required bool isThread
  }) async {
    final String starting = '$_baseUrl/post';

    try {
      final httpConfigObj = HTTPConfig.giveHeaders(Uri.parse('$starting/$path'), token: token);

      var request = http.MultipartRequest('POST', httpConfigObj.uri);
      request.headers['Authorization'] = httpConfigObj.headers['Authorization']!;

      request.fields['description'] = description;
      request.fields['isThread'] = isThread.toString();

      // Only add the image file if it's a regular post (not a thread) and a file is selected
      if (!isThread && selectedFilePath != null) {
        final file = File(selectedFilePath);

        if (await file.exists()) {
          final fileBytes = await file.readAsBytes();
          final fileName = selectedFilePath.split('/').last;

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
          print('File does not exist: $selectedFilePath');
          return ActionResponse(success: false, message: "Image file not found");
        }
      }

      // For debugging
      print('Sending request to: ${httpConfigObj.uri}');
      print('isThread: $isThread');
      print('Fields: ${request.fields}');
      print('Files count: ${request.files.length}');

      final streamResponse = await request.send();
      final response = await http.Response.fromStream(streamResponse);

      // For debugging
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ActionResponse(success: true, message: "Post created successfully");
      } else {
        return ActionResponse(success: false, message: "Cannot create post: ${response.body}");
      }
    } catch (e) {
      print('API call failed: $e');
      return ActionResponse(success: false, message: "Error: $e");
    }
  }

  Future<ActionResponse> deleteNoBody(String? path, String? token) async {
    final String starting = '$_baseUrl/post';
    try {
      final httpConfigObj = HTTPConfig.giveHeaders(Uri.parse('$starting/$path'), token: token);

      final response = await http.delete(httpConfigObj.uri, headers: httpConfigObj.headers);

      if(response.statusCode != 200) {
        print('HEY THER HAS BEEN SOMETHING WRONG IN THE FETCHING REQUEST\n\n: ${response.statusCode}');
      }

      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final ActionResponse actionResponse = ActionResponse.fromJson(responseBody);

      return actionResponse;
    } catch(e) {
      return ActionResponse(success: false, message: "Error $e");
    }
  }

}