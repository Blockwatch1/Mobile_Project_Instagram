import 'User.dart';

class CommentModel {
  final dynamic commentId;
  final String content;
  final bool isReply;
  final String? createdAt;
  final String? updatedAt;
  final bool? isEdited;

  final CommentModel? parentComment;
  final List<CommentModel>? replies;
  final int? replyAmount;
  final dynamic postId;
  final User user;

  CommentModel({
    required this.commentId,
    required this.content,
    required this.isReply,
    this.createdAt,
    this.updatedAt,
    this.isEdited,
    this.parentComment,
    this.replies,
    required this.postId,
    required this.user,
    this.replyAmount
  });

  factory CommentModel.fromJson(Map<String, dynamic> json){
    return CommentModel (
        commentId: json['commentId'],
        content: json['content'],
        isReply: json['isReply'],
        updatedAt: json['updatedAt'] ?? null,
        isEdited: json['isEdited'] ?? false,
        createdAt: json['createdAt'] ?? null,
        parentComment: json['parentComment'] ?? null,
        replies: json['replies'] ?? null,
        replyAmount: json['replyAmount'] ?? null,
        postId: json['postId'] ?? null,
        user: json['user'],
    );
  }


}
