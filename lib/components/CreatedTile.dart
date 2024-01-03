import 'package:flutter/material.dart';

import '../domain/entry.dart';

class CreatedTile extends StatefulWidget {
  const CreatedTile({super.key, required this.entry, required this.deleteFunction});

  final Entry entry;
  final Function deleteFunction;

  @override
  State<CreatedTile> createState() => _CreatedTileState();
}

class _CreatedTileState extends State<CreatedTile> {
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
                  widget.deleteFunction(widget.entry.id);
                },
                tooltip: "Delete this Entry",
                icon: const Icon(Icons.delete)),
            IconButton(
              onPressed: () {
                print('unfinished lmoa');
                //TODO: link to ertl's entry editor
              },
              tooltip: "Edit this entry",
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
      ),
    );
  }
}
