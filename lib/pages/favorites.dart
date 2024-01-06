import 'package:flutter/material.dart';
import 'package:memo_share/components/FavoriteTile.dart';
import 'package:memo_share/services/EntryService.dart';
import 'package:memo_share/services/UserService.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../domain/entry.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key, required String title});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  bool loading = true;
  List<Entry> entries = [];
  late List<int> idList;
  late int uid;

  @override
  void didChangeDependencies() {
    late Map<String, dynamic> pageData =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    idList = pageData["idList"];
    uid = pageData["uid"];

    EntryService()
      .getEntriesToId(idList)
      .then((value) {
        entries = value;

        setState(() {
          loading = false;
        });
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: const Text("Favoriten"),
        ),
          body: entries.isEmpty
              ? const Center(child: Text("Keine favorisierten Einträge"))
              : Flex(direction: Axis.horizontal, children: [
            Expanded(
                child: ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries.elementAt(index);

                      return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/entry",
                                arguments: {"id": entry.id});
                          },
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(
                                100.0, 10.0, 100.0, 10.0),
                            decoration: BoxDecoration(
                                border:
                                Border.all(color: Colors.blueAccent),
                                color: Colors.lightBlueAccent[100]),
                            child: FavoriteTile(
                              entry: entry,
                            ),
                          ));
                    }))
          ]),
      ),
    );
  }
}
