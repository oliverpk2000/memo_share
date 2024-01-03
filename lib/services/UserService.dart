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

    //TODO created, liked, favorite
}