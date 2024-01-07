import 'package:flutter/material.dart';
import 'package:memo_share/services/UserService.dart';

import '../domain/entry.dart';

class PublicTile extends StatefulWidget {
  const PublicTile(
      {super.key,
      required this.entry,
      required this.alreadyLiked,
      required this.like,
      required this.unlike});

  final Entry entry;
  final bool alreadyLiked;
  final Function like;
  final Function unlike;

  @override
  State<PublicTile> createState() => _PublicTileState();
}

class _PublicTileState extends State<PublicTile> {
  var likedIcon = Icons.favorite_border;
  var username = "";

  @override
  void initState() {
    if (widget.alreadyLiked) {
      likedIcon = Icons.favorite;
    }

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
      trailing: SizedBox(
        width: 120.0,
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    if (likedIcon == Icons.favorite_border) {
                      likedIcon = Icons.favorite;
                      widget.like(widget.entry.id);
                    } else {
                      likedIcon = Icons.favorite_border;
                      widget.unlike(widget.entry.id);
                    }
                  });
                },
                tooltip: likedIcon == Icons.star_border
                    ? "Like hinzufügen"
                    : "Like entfernen",
                icon: Icon(likedIcon)),
          ],
        ),
      ),
    );
  }
}
