import 'package:flutter/material.dart';

import '../domain/entry.dart';

class CreatedTile extends StatefulWidget {
  const CreatedTile(
      {super.key, required this.entry, required this.deleteFunction, required this.alreadyInFavorite, required this.favorite, required this.unfavorite});

  final Entry entry;
  final Function deleteFunction;
  final Function favorite;
  final Function unfavorite;
  final bool alreadyInFavorite;

  @override
  State<CreatedTile> createState() => _CreatedTileState();
}

class _CreatedTileState extends State<CreatedTile> {
  IconData favIcon = Icons.star_border;

  @override
  void initState() {
    if (widget.alreadyInFavorite) {
      favIcon = Icons.star;
    }

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print("building");
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
                icon: const Icon(Icons.delete)),

            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/updater",
                    arguments: widget.entry);
              },
              tooltip: "Editieren",
              icon: const Icon(Icons.edit),
            ),

            IconButton(
                onPressed: () {
                  setState(() {
                    if (favIcon == Icons.star_border) {
                      favIcon = Icons.star;
                      widget.favorite(widget.entry.id);
                    } else {
                      favIcon = Icons.star_border;
                      widget.unfavorite(widget.entry.id);
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
