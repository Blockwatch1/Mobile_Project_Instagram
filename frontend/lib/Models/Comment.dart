class Comment {
  final String commentId;
  final String content;
  final bool isReply;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isEdited;

  Comment({
    required this.commentId,
    required this.content,
    required this.isReply,
    this.createdAt,
    this.updatedAt,
    this.isEdited
  });

  factory Comment.fromJson(Map<String, dynamic> json){
    return Comment (
        commentId: json['commentId'],
        content: json['content'],
        isReply: json['isReply'],
        updatedAt: json['updatedAt'] ?? null,
        isEdited: json['isEdited'] ?? false,
        createdAt: json['createdAt'] ?? null
    );
  }


}
