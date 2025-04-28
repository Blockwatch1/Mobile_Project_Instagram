import 'package:insta/Models/User.dart';

class PostModel {
  final dynamic postId;
  final String? description;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  bool? isThread = false;
  User? user;
  List<dynamic>? savedUsers;
  List<dynamic>? likedUsers;
  List<dynamic>? comments;
  int? saveAmount;
  int? likeAmount;
  int? commentAmount;

  PostModel({
    required this.postId,
    this.description,
    this.imageUrl,
    this.isThread,
    this.updatedAt,
    this.createdAt,
    this.user,
    this.savedUsers,
    this.likedUsers,
    this.comments,
    this.saveAmount,
    this.likeAmount,
    this.commentAmount
  });

  factory PostModel.fromJson(Map<String, dynamic> json){
    return PostModel (
        postId: json['postId'],
        description: json['description'] ?? '',
        imageUrl: json['imageUrl'] ?? null,
        updatedAt: json['updatedAt'] ?? null,
        isThread: json['isThread'] ?? false,
        createdAt: json['createdAt'] ?? ''
    );
  }


}
