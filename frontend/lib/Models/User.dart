class User {
 final dynamic userId;
 final String name;
 final String? email;
 final String? bio;
 final String username;
 final String? pfpPath;
 final DateTime? lastLogin;
 final DateTime? createdAt;

 User({
  required this.userId,
  required this.name,
  required this.username,
  this.email,
  this.bio,
  this.pfpPath,
  this.lastLogin,
  this.createdAt
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
      createdAt: json['createdAt'] ?? null
  );
 }


}