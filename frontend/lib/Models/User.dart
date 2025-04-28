import 'package:insta/Models/PostModel.dart';

class User {
 final dynamic userId;
 final String name;
 final String? email;
 final String? bio;
 final String username;
 final String? pfpPath;
 final String? lastLogin;
 final String? createdAt;
 final String? lastUsernameChange;
 final String? password;
 final List<dynamic>? followedBy;
 final List<dynamic>? following;
 final List<dynamic>? posts;

 User({
  required this.userId,
  required this.name,
  required this.username,
  this.email,
  this.bio,
  this.pfpPath,
  this.lastLogin,
  this.createdAt,
  this.password,
  this.lastUsernameChange,
  this.followedBy,
  this.following,
  this.posts
 });

 factory User.fromJson(Map<String, dynamic> json){
  return User (
      userId: json['userId'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      bio: json['bio'] ?? '',
      pfpPath: json['pfpPath'] ?? null,
      lastLogin: json['lastLogin'] ?? null,
      createdAt: json['createdAt'] ?? null,
      password: json['password'] ?? null,
      lastUsernameChange: json['lastUsernameChange'] ?? null,
      followedBy: json['followedBy'] ?? [],
      following: json['following'] ?? [],
      posts: json['posts'] ?? []
  );
 }


}