import 'package:memo_share/domain/entry.dart';

class User{
  late int id;
  late String username;
  late String password;
  late List<Entry> liked;
  late List<Entry> favorited;
  late List<Entry> created;

  User(this.id, this.username, this.password, this.liked, this.favorited, this.created);

  User.defaultUser(){
    id = -1;
    username = "defaultUser";
    password = "defaultPassword";
    liked = [];
    favorited = [];
    created = [];
  }

}