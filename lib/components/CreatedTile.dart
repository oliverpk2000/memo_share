// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../domain/entry.dart';

class CreatedTile extends StatefulWidget {
  CreatedTile(
      {super.key,
      required this.entry,
      required this.deleteFunction,
      required this.icon,
      required this.favorite,
      required this.unfavorite,
      required this.update});

  final Entry entry;
  final Function update;
  final Function deleteFunction;
  final Function favorite;
  final Function unfavorite;
  IconData icon;

  @override
  State<CreatedTile> createState() => _CreatedTileState();
}

class _CreatedTileState extends State<CreatedTile> {
  late IconData favIcon = widget.icon;

  @override
  Widget build(BuildContext context) {
    if (widget.icon != favIcon) {
      favIcon = widget.icon;
    }

    return ListTile(
      title: Text(widget.entry.title),
      subtitle: Text(widget.entry.created.toString()),
      trailing: SizedBox(
        width: 120.0,
        child: Row(
          children: [
            IconButton(
                onPressed: () async {
                  await widget.deleteFunction(widget.entry.id);
                },
                tooltip: "Entfernen",
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                )),
            IconButton(
              onPressed: () async {
                await Navigator.pushNamed(context, "/updater",
                    arguments: widget.entry);

                widget.update(widget.entry.creatorId);
              },
              tooltip: "Editieren",
              icon: const Icon(Icons.edit),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    if (favIcon == Icons.star_border) {
                      favIcon = Icons.star;
                      widget.icon = Icons.star;
                      widget.favorite(widget.entry.id);
                    } else {
                      favIcon = Icons.star_border;
                      widget.icon = Icons.star_border;
                      widget.unfavorite(widget.entry.id);
                    }
                  });
                },
                tooltip: favIcon == Icons.star_border
                    ? "Favorit hinzufügen"
                    : "Favorit entfernen",
                icon: Icon(
                  favIcon,
                  color: Colors.orange,
                )),
          ],
        ),
      ),
    );
  }
}

//FINISH
