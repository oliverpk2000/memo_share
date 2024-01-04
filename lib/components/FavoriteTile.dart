import 'package:flutter/material.dart';

import '../domain/entry.dart';

class FavoriteTile extends StatefulWidget {
  const FavoriteTile(
      {super.key, required this.entry, required this.deleteFunction});

  final Entry entry;
  final Function deleteFunction;

  @override
  State<FavoriteTile> createState() => _FavoriteTileState();
}

class _FavoriteTileState extends State<FavoriteTile> {
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
                  //TODO delete from favorites
                },
                tooltip: "Favorit entfernen",
                icon: const Icon(Icons.star)),
          ],
        ),
      ),
    );
  }
}
