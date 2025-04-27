import 'package:insta/Models/ErrorDetails.dart';

class ActionResponse {
  final bool success;
  final dynamic? data;
  final String? message;
  final ErrorDetails? error;
  final String? token;
  final dynamic? user;

  ActionResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
    this.token,
    this.user
  });

  factory ActionResponse.fromJson(Map<String, dynamic> actionResponse) {
    return ActionResponse(
      success: actionResponse['success'] ?? null,
      data: actionResponse['data'] ?? null,
      message: actionResponse['message'] ?? null,
      token: actionResponse['token'] ?? null,
      user: actionResponse['user'] ?? null, //the map here must contain "userId", "username", "email" and "bio" just like the backend
      error: actionResponse['error'] != null ? ErrorDetails.fromJson(actionResponse['error'] as Map<String, dynamic>): null,

    );
  }
}