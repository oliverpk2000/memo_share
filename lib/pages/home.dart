// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:memo_share/components/CreatedTile.dart';
import 'package:memo_share/domain/user.dart';
import 'package:memo_share/services/EntryService.dart';
import 'package:memo_share/services/UserService.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../domain/entry.dart';

const List<String> tags = [
  "Sport und Fitness",
  "Schule",
  "Natur",
  "Reisen",
  "Freizeit",
  "Beruf",
  "Essen",
  "Gesundheit"
];

class Home extends StatefulWidget {
  const Home({super.key, required String title});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int uid;
  late User user = User.defaultUser();
  List<Entry> created = [];
  bool loading = true;
  bool asc = true;
  String sortLabel = "Aufsteigend";
  bool ascDate = true;
  String dateLabel = "Neuste";

  Future<void> getUser(uid) async {
    user = await UserService().getUser(uid);
    created = await EntryService().getEntriesToId(user.created);
  }

  @override
  void didChangeDependencies() {
    uid = ModalRoute.of(context)!.settings.arguments as int;
    getUser(uid).whenComplete(() {
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
          leadingWidth: 200,
          toolbarHeight: 75,
          title: const Text("MemoShare-Home"),
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
          leading: Image.asset("images/logotransparent_fullhd.png"),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    if (asc) {
                      created.sort((entry1, entry2) =>
                          entry1.title.compareTo(entry2.title));
                      asc = false;
                      sortLabel = "Absteigend";
                    } else {
                      created.sort((entry1, entry2) =>
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
                      created.sort((entry1, entry2) =>
                          entry2.created.compareTo(entry1.created));
                      ascDate = false;
                      dateLabel = "Älteste";
                    } else {
                      created.sort((entry1, entry2) =>
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

            IconButton(
                onPressed: () async {
                  await Navigator.pushNamed(context, "/hub",
                      arguments: user.id);

                  getUser(uid).whenComplete(() {
                    setState(() {
                      loading = false;
                    });
                  });
                },
                tooltip: "Andere Beiträge",
                icon: Icon(
                  Icons.people,
                  color: Colors.lightBlue[50],
                  size: 35,
                )),
            IconButton(
                onPressed: () async {
                  await Navigator.pushNamed(context, "/favorites",
                      arguments: {"idList": user.favorited, "uid": user.id});

                  getUser(uid).whenComplete(() {
                    setState(() {
                      loading = false;
                    });
                  });
                },
                tooltip: "Favoriten",
                icon: const Icon(
                  Icons.star,
                  color: Colors.orange,
                  size: 30,
                )),
            IconButton(
                onPressed: () async {
                  await Navigator.pushNamed(context, "/liked",
                      arguments: {"idList": user.liked, "uid": user.id});

                  getUser(uid).whenComplete(() {
                    setState(() {
                      loading = false;
                    });
                  });
                },
                tooltip: "Geliked",
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.pinkAccent,
                  size: 30,
                )),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/profile", arguments: user.id);
                },
                tooltip: "Profil",
                icon: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 30,
                )),
          ],
          //TODO Link to Hub
        ),
        body: created.isEmpty
            ? const Center(child: Text("Keine erstellten Einträge"))
            : Flex(direction: Axis.horizontal, children: [
                Expanded(
                    child: ListView.builder(
                        itemCount: created.length,
                        itemBuilder: (context, index) {
                          final entry = created.elementAt(index);
                          var inFavorite = user.favorited.contains(entry.id);

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
                                child: CreatedTile(
                                  entry: entry,
                                  deleteFunction: deleteCreated,
                                  icon: inFavorite
                                      ? Icons.star
                                      : Icons.star_border,
                                  favorite: favoriteCreated,
                                  unfavorite: unfavoriteCreated,
                                ),
                              ));
                        }))
              ]),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () async {
            loading = true;
            await Navigator.pushNamed(context, "/editor",
                arguments: user.id);

            getUser(uid).whenComplete(() {
              setState(() {
                loading = false;
              });
            });
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  deleteCreated(entryId) async {
    setState(() {
      loading = true;
    });

    await EntryService().deleteEntry(entryId);
    await UserService().deleteCreated(entryId, uid);
    getUser(uid).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  unfavoriteCreated(entryId) async {
    setState(() {
      loading = true;
    });

    await UserService().deleteFavorite(entryId, uid);
    getUser(uid).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  favoriteCreated(entryId) async {
    setState(() {
      loading = true;
    });

    await UserService().addToFavorite(entryId, uid);
    getUser(uid).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }
}
