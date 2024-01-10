// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:memo_share/domain/entry.dart';

class EntryService {
  final String pathToDB =
      "https://memoshare-bde3c-default-rtdb.europe-west1.firebasedatabase.app/";

  Future<void> addEntry(Entry entry) async {
    var url = Uri.parse("$pathToDB/entries/${entry.id}.json");

    try {
      var response = await http.put(
        url,
        body: json.encode(entry.toJson()),
      );

      if (response.statusCode == 200) {
        print("New Entry successfully created/updated!");
      } else {
        throw "Something went wrong while creating Entry: $entry";
      }
    } catch (error) {
      throw "Error while creating: $error";
    }
  }

  Future<List<Entry>> getAll() async {
    List<Entry> entries = [];
    var url = Uri.parse("$pathToDB/entries.json");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        final List<dynamic> data = json.decode(response.body) ?? [];

        for (var element in data) {
          if (element != null) {
            entries.add(Entry.fromJSON(Map.castFrom(element)));
          }
        }
      } catch (err) {
        final Map<String, dynamic> data = json.decode(response.body);
        data.forEach((key, value) {
          entries.add(Entry.fromJSON(value));
        });
      }

      return entries;
    } else {
      throw "Something went wrong while getting all Entries";
    }
  }

  Future<Entry> getEntry(int id) async {
    var url = Uri.parse("$pathToDB/entries/$id.json");

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        return Entry.fromJSON(json.decode(response.body));
      }

      throw "Something went wrong while searching for ID: $id";
    } catch (error) {
      throw "ID $id not found";
    }
  }

  Future<void> deleteEntry(int id) async {
    try {
      await getEntry(id);
    } catch (error) {
      throw "ID does not exist $id";
    }

    var url = Uri.parse("$pathToDB/entries/$id.json");
    var response = await http.delete(url);

    if (response.statusCode == 200) {
      print("Entry Successfully deleted");
    } else {
      throw "Error while deleting ID: $id";
    }
  }

  Future<void> updateEntry(Entry entry, int id) async {
    try {
      await getEntry(id);
    } catch (error) {
      throw "ID does not exist $id";
    }

    entry.id = id;
    addEntry(entry);
  }

  Future<List<Entry>> getEntriesToId(List<int> idList) async {
    var allEntries = await getAll();
    return allEntries.where((element) => idList.contains(element.id)).toList();
  }

  Future<List<Entry>> getPublic() async {
    var allEntries = await getAll();
    return allEntries.where((element) => !element.private).toList();
  }
}

//FINISH
