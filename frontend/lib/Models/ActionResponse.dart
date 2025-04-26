import 'package:insta/Models/ErrorDetails.dart';

class ActionResponse {
  final bool success;
  final dynamic? data;
  final String? message;
  final ErrorDetails? error;

  ActionResponse({
    required this.success,
    this.data,
    this.message,
    this.error
  });

  factory ActionResponse.fromJson(Map<String, dynamic> actionResponse) {
    return ActionResponse(
      success: actionResponse['success'] as bool,
      data: actionResponse['data'] ?? null,
      message: actionResponse['message'] as String?,
      error: actionResponse['error'] != null ? ErrorDetails.fromJson(actionResponse['error'] as Map<String, dynamic>): null,
    );
  }
}