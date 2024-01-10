// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;

class IdService {
  int entryId = 0;
  int userId = 0;
  final String pathToDB =
      "https://memoshare-bde3c-default-rtdb.europe-west1.firebasedatabase.app/";

  Future<void> init() async {
    var userResponse =
        await http.get(Uri.parse("$pathToDB/ids/latestUserId.json"));
    var entryResponse =
        await http.get(Uri.parse("$pathToDB/ids/latestEntryId.json"));
    userId = int.parse(userResponse.body);
    entryId = int.parse(entryResponse.body);
  }

  int newEntryId() {
    entryId++;

    http.patch(Uri.parse("$pathToDB/ids.json"),
        body: json.encode({"latestEntryId": entryId}));

    return entryId;
  }

  newUserId() {
    userId++;

    http.patch(Uri.parse("$pathToDB/ids.json"),
        body: json.encode({"latestUserId": userId}));

    return userId;
  }

  removeUserId() {
    userId--;
    http.patch(Uri.parse("$pathToDB/ids.json"),
        body: json.encode({"latestUserId": userId}));
  }
}
//FINISH
