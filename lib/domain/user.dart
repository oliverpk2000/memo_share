import 'package:memo_share/services/IdService.dart';

class User {
  late int id;
  late String username;
  late String password;
  late List<int> liked;
  late List<int> favorited;
  late List<int> created;

  User.defaultUser() {
    id = 0;
    username = "defaultUser";
    password = "defaultPassword";
    liked = [];
    favorited = [];
    created = [];
  }

  User(
      {required this.id,
      required this.username,
      required this.password,
      required this.liked,
      required this.favorited,
      required this.created});

  User.withNewId(
      {required this.username,
      required this.password,
      required this.liked,
      required this.favorited,
      required this.created,
      required IdService idService}) {
    id = idService.newUserId();
  }

  factory User.fromJSON(Map<String, dynamic> jsonMap) {
    List<dynamic> created = jsonMap['created'] ?? [];
    List<dynamic> liked = jsonMap['liked'] ?? [];
    List<dynamic> favorite = jsonMap['favorite'] ?? [];

    return User(
        id: jsonMap['id'],
        username: jsonMap['username'],
        password: jsonMap['password'],
        liked: List.castFrom(liked),
        favorited: List.castFrom(favorite),
        created: List.castFrom(created));
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "username": username,
      "password": password,
      "liked": liked,
      "favorite": favorited,
      "created": created
    };
  }

  @override
  bool operator ==(Object other) {
    var user = other as User;
    return user.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return """{
      id : $id,
      username : $username,
      password : $password,
      liked : ${liked.toString()},
      favorite : ${favorited.toString()},
      created : ${created.toString()},
    }""";
  }
}

//FINISH
