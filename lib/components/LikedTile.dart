import 'package:flutter/material.dart';

import '../domain/entry.dart';
import '../services/UserService.dart';

class LikedTile extends StatefulWidget {
  const LikedTile(
      {super.key, required this.entry});

  final Entry entry;

  @override
  State<LikedTile> createState() => _LikedTileState();
}

class _LikedTileState extends State<LikedTile> {
  String username = "";

  @override
  void initState() {
    UserService().getUser(widget.entry.creatorId).then((value) {
      setState(() {
        username = value.username;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.entry.title),
      subtitle: Text("Erstellt von $username"),
      trailing: const Icon(Icons.favorite, color: Colors.pinkAccent,)
    );

  }
}
