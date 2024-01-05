// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:memo_share/components/entryList.dart';
import 'package:memo_share/domain/user.dart';

import '../domain/Modes.dart';

const List<String> tags = [
  "Sport und Fitness",
  "Schule",
  "Natur",
  "Reisen",
  "Freizeit",
  "Beruf"
];

class Home extends StatefulWidget {
  Home({super.key, required String title});

  late User user = User.defaultUser();

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MemoShare-Home"),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/favorites", arguments: {"idList": widget.user.favorited, "uid" : widget.user.id});
              },
              tooltip: "Favoriten",
              icon: const Icon(Icons.star, color: Colors.orange,)),

          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/liked", arguments: {"idList": widget.user.favorited, "uid" : widget.user.id});
              },
              tooltip: "Geliked",
              icon: const Icon(Icons.favorite, color: Colors.pinkAccent,)),

          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/profile", arguments: widget.user.id);
              },
              tooltip: "Profil",
              icon: const Icon(Icons.person, color: Colors.white,))
        ],
        //TODO Sort/Filter, Link to Hub
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Created Entries'),
            Expanded(child: EntryList(idList: widget.user.created, mode: Modes.created, uid: widget.user.id,)),
            //const Text('favorite Entries'),
            //Expanded(child: EntryList(idList: widget.user.favorited)),
            //const Text('liked Entries'),
            //Expanded(child: EntryList(idList: widget.user.liked)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            Navigator
                .pushNamed(context, "/editor", arguments: {"uid" : widget.user.id});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}