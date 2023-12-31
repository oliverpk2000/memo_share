import 'dart:html';

import 'package:flutter/material.dart';
import 'package:memo_share/domain/entry.dart';
import 'package:memo_share/services/EntryService.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FloatingActionButton(
              onPressed: () async {
                var entry = Entry.withNewID(title:"3333333", content: "ertzui", tags: [], private: true, imageUrls: []);
                EntryService().addEntry(entry);
            },
            child: const Text("Add"),
          ),

          FloatingActionButton(
            onPressed: () async {
              var back = await EntryService().getAll();
              print(back);
            },
            child: const Text("Get"),
          ),

          FloatingActionButton(
            onPressed: () async {
              var entry = Entry(id: 3, title:"444444", content: "ertzui", tags: [], private: true, imageUrls: []);
              await EntryService().updateEntry(entry, 11);
            },
            child: const Text("Change"),
          ),

          FloatingActionButton(
            onPressed: () async {
              EntryService().deleteEntry(25);
            },
            child: const Text("Delete"),
          ),
        ],


      ),
    );
  }
}
