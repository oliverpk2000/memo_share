import 'package:flutter/material.dart';

import '../domain/entry.dart';

class LikedTile extends StatefulWidget {
  const LikedTile(
      {super.key, required this.entry, required this.deleteFunction, required this.uid});

  final int uid;
  final Entry entry;
  final Function deleteFunction;

  @override
  State<LikedTile> createState() => _LikedTileState();
}

class _LikedTileState extends State<LikedTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.entry.title),
      subtitle: Text(widget.entry.created.toString()),
      trailing: SizedBox(
        width: 120.0,
        child: Row(
          children: [

            IconButton(
                onPressed: () {
                  //TODO delete from liked mit uid vom derzeitigen user
                },
                tooltip: "Geliked entfernen",
                icon: const Icon(Icons.favorite, color: Colors.pinkAccent,)),
          ],
        ),
      ),
    );

  }
}
