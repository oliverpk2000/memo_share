import 'package:flutter/material.dart';
import 'package:memo_share/components/favoriteTile.dart';
import 'package:memo_share/services/EntryService.dart';
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
  bool asc = true;
  String sortLabel = "Aufsteigend";
  bool ascDate = true;
  String dateLabel = "Neuste";

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
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    if (asc) {
                      entries.sort((entry1, entry2) =>
                          entry1.title.compareTo(entry2.title));
                      asc = false;
                      sortLabel = "Absteigend";
                    } else {
                      entries.sort((entry1, entry2) =>
                          entry2.title.compareTo(entry1.title));
                      asc = true;
                      sortLabel = "Aufsteigend";
                    }
                  });
                },
                tooltip: sortLabel,
                icon: const Icon(
                  Icons.abc,
                  size: 30,
                  color: Colors.white,
                )),

            IconButton(
                onPressed: () {
                  setState(() {
                    if (ascDate) {
                      entries.sort((entry1, entry2) =>
                          entry2.created.compareTo(entry1.created));
                      ascDate = false;
                      dateLabel = "Älteste";
                    } else {
                      entries.sort((entry1, entry2) =>
                          entry1.created.compareTo(entry2.created));
                      ascDate = true;
                      dateLabel = "Neuste";
                    }
                  });
                },
                tooltip: dateLabel,
                icon: const Icon(
                  Icons.date_range,
                  size: 30,
                  color: Colors.white,
                )),
          ],
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
