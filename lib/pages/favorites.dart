import 'package:flutter/material.dart';
import 'package:memo_share/components/entryList.dart';

import '../domain/Modes.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key, required String title});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  late Map<String, dynamic> pageData =
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  late List<int> idList = pageData["idList"];
  late int uid = pageData["uid"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Favoriten"),
      ),
      body: EntryList(idList: idList, mode: Modes.favorite, uid: uid),
    );
  }
}
