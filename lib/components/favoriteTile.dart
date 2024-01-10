// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../domain/entry.dart';

class FavoriteTile extends StatefulWidget {
  const FavoriteTile({super.key, required this.entry});

  final Entry entry;

  @override
  State<FavoriteTile> createState() => _FavoriteTileState();
}

class _FavoriteTileState extends State<FavoriteTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.entry.title),
      subtitle: Text(widget.entry.created.toString()),
      trailing: const Icon(
        Icons.star,
        color: Colors.orange,
      ),
    );
  }
}

//FINISH
