import 'package:flutter/material.dart';

import '../domain/entry.dart';

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
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.entry.title),
      subtitle: Text(widget.entry.created.toString()),
      trailing: const Icon(Icons.favorite, color: Colors.pinkAccent,)
    );

  }
}
