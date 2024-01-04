import 'package:flutter/material.dart';
import 'package:memo_share/domain/entry.dart';
import 'package:memo_share/services/EntryService.dart';
import 'package:memo_share/services/UserService.dart';

import '../domain/user.dart';

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

          FloatingActionButton(
            heroTag: "addUser",
            onPressed: () async {
              //UserService().registerUser(User.defaultUser());
              UserService().changePassword("1234", 0);
            },
            child: const Text("Add"),
          ),

        ],
      ),
    );
  }
}
