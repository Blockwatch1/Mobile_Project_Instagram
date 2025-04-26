class Post {
  final String postId;
  final String? description;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  bool? isThread = false;


  Post({
    required this.postId,
    this.description,
    this.imageUrl,
    this.isThread,
    this.updatedAt,
    this.createdAt
  });

  factory Post.fromJson(Map<String, dynamic> json){
    return Post (
        postId: json['postId'],
        description: json['description'] ?? '',
        imageUrl: json['imageUrl'] ?? null,
        updatedAt: json['updatedAt'] ?? null,
        isThread: json['isThread'] ?? false,
        createdAt: json['createdAt'] ?? ''
    );
  }


}
