import 'package:http/http.dart' as http;
import 'package:memo_share/domain/user.dart';
import 'dart:convert';

class UserService {
  final String pathToDB =
      "https://memoshare-bde3c-default-rtdb.europe-west1.firebasedatabase.app/";

  Future<List<User>> getAll() async {
    List<User> users = [];
    var url = Uri.parse("$pathToDB/users.json");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      for (var element in data) {
        if (element != null) {
          users.add(User.fromJSON(Map.castFrom(element)));
        }
      }

      return users;

    } else {
      throw "Somwthing went wrong while getting all Users";
    }
  }

  Future<User> getUser(int id) async {
    var url = Uri.parse("$pathToDB/users/$id.json");

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        return User.fromJSON(json.decode(response.body));
      }

      throw "Something went wrong while searching for ID: $id";
    } catch (error) {
      throw "ID $id not found";
    }
  }

  Future<void> registerUser(User user) async {
    var url = Uri.parse("$pathToDB/users/${user.id}.json");
    var allUsers = await getAll();

    if (allUsers.where((element) => element.username == user.username).toList().isNotEmpty) {
      throw "Username: ${user.username} already exists";
    }

    try {
      var response = await http.post(
          url,
          body: json.encode(user.toJSON()));

      if (response.statusCode == 200) {
        print("User Successfully Created");

      } else {
        throw "Something went wrong whlie creating User: $user";
      }
    } catch (error) {
      throw "Error while Creating user: $error";
    }
  }

  Future<User> login(User user) async {
    var allUsers = await getAll();
    var withUsername = allUsers.where((element) => element.username == user.username);

    if (withUsername.isEmpty) {
      throw "No user with this name: ${user.username}";

    } else if (withUsername.first.password == user.password) {
      return withUsername.first;
    }

    throw "Incorrect Password";
  }

  Future<void> addToCreated(entryId, userId) async {
    try {
      var user = await getUser(userId);

    } catch (error) {

    }
  }


    //TODO created, liked, favorite
}