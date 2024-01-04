import 'package:flutter/material.dart';
import 'package:memo_share/services/UserService.dart';

import '../domain/entry.dart';

class CreatedTile extends StatefulWidget {
  const CreatedTile(
      {super.key, required this.entry, required this.deleteFunction});

  final Entry entry;
  final Function deleteFunction;

  @override
  State<CreatedTile> createState() => _CreatedTileState();
}

class _CreatedTileState extends State<CreatedTile> {
  IconData favIcon = Icons.star_border;

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
                  widget.deleteFunction(
                      widget.entry.id);
                },
                tooltip: "Entfernen",
                icon: const Icon(Icons.delete)),
            IconButton(
              onPressed: () {
                print('unfinished lmoa');
                //TODO: link to ertl's entry editor
              },
              tooltip: "Editieren",
              icon: const Icon(Icons.edit),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    if (favIcon == Icons.star_border) {
                      favIcon = Icons.star;
                      UserService()
                          .addToFavorite(widget.entry.id, widget.entry.creatorId);
                    } else {
                      favIcon = Icons.star_border;
                      UserService()
                        .deleteFavorite(widget.entry.id, widget.entry.creatorId);
                    }
                  });
                },
                tooltip: favIcon == Icons.star_border ? "Favorit hinzufügen" : "Favorit entfernen",
                icon: Icon(favIcon)),
          ],
        ),
      ),
    );
  }
}
