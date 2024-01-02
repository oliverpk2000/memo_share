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
            heroTag: "add",
            onPressed: () async {
              var entry = Entry.withNewID(
                  title: "Mein Eintrag",
                  content: "Dein Langer Text hihihi",
                  tags: ["Leben", "Hobbys"],
                  private: false,
                  imageUrls: [
                    "https://picsum.photos/250?image=9",
                    "https://picsum.photos/250?image=9"
                  ],
                  creatorId: -1,
                  created: DateTime.now());

              EntryService().addEntry(entry);
            },
            child: const Text("Add"),
          ),

          /* FloatingActionButton(
            onPressed: () async {
              var back = await EntryService().getAll();
              print(back);
            },
            child: const Text("Get"),
          ),

          FloatingActionButton(
            onPressed: () async {
              var entry = Entry(id: 3, title:"444444", content: "ertzui", tags: ["ssss", "dddd"], private: true, imageUrls: []);
              await EntryService().updateEntry(entry, 11);
            },
            child: const Text("Change"),
          ),

          FloatingActionButton(
            onPressed: () async {
              await EntryService().deleteEntry(11);
            },
            child: const Text("Delete"),
          ),*/

          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, "/entry", arguments: {"id": 11});
            },
            child: const Text("Entry 1"),
          ),
          Image.network("https://picsum.photos/250?image=9"),
        ],
      ),
    );
  }
}
