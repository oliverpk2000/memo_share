import 'dart:html';

import 'package:flutter/material.dart';
import 'package:memo_share/domain/entry.dart';


class EntryList extends StatefulWidget {
  const EntryList({super.key, required this.entryList});
  final List<Entry> entryList;


  @override
  State<EntryList> createState() => _EntryListState();
}

class _EntryListState extends State<EntryList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.entryList.length,
      itemBuilder: (context, index) {
        final entry = widget.entryList.elementAt(index);
        return Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          child: ListTile(
            title: Text(entry.title),
            subtitle: const Text('date (TODO)'),
            trailing: IconButton(onPressed: (){
              print('unfinished lmoa');
              //TODO: link to ertl's entry creator/editor
          },
            icon: const Icon(Icons.edit),),
        ),
        );
      }
    );
  }
}
