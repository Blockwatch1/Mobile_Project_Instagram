import 'post.dart';

class User{
 List<User> _following= [];
 List<User> _followers= [];
 String _username;
 //TODO : change this later
 int id=0;
 String _profilePicUrl;
 List<Post> _posts = [];
 List<Post> _savedPosts = [];
 User(this._username,this._profilePicUrl);

 List<Post> get savedPosts => _savedPosts;

  List<Post> get posts => _posts;

 String get profilePicUrl => _profilePicUrl;

 List<User> get following => _following;

 String get username => _username;

 List<User> get followers => _followers;
 void addFollower(User user){
   _followers.add(user);
 }
 void addFollowing(User user){
   _following.add(user);
 }
 void removeFollowing(String username){
  int indexToRemove = _following.indexWhere((user){ return user.username==username;});
  _following.removeAt(indexToRemove);
 }
 void removeFollower(String username){
   int indexToRemove = _followers.indexWhere((user){ return user.username==username;});
   _followers.removeAt(indexToRemove);
 }
}