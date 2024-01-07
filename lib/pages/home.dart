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
  "Beruf"
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
          title: const Text("MemoShare-Home"),
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
          leading: Image.asset("images/logo_transparent.png"),
          actions: [
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
                icon: const Icon(
                  Icons.people,
                  color: Colors.green,
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
                )),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/profile", arguments: user.id);
                },
                tooltip: "Profil",
                icon: const Icon(
                  Icons.person,
                  color: Colors.white,
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
                                  alreadyInFavorite: inFavorite,
                                  favorite: favoriteCreated,
                                  unfavorite: unfavoriteCreated,
                                ),
                              ));
                        }))
              ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            loading = true;
            await Navigator.pushNamed(context, "/editor",
                arguments: {"uid": user.id});

            getUser(uid).whenComplete(() {
              setState(() {
                loading = false;
              });
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  deleteCreated(entryId) async {
    loading = true;
    await EntryService().deleteEntry(entryId);
    await UserService().deleteCreated(entryId, uid);
    getUser(uid).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  unfavoriteCreated(entryId) async {
    loading = true;
    await UserService().deleteFavorite(entryId, uid);
    getUser(uid).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  favoriteCreated(entryId) async {
    loading = true;
    await UserService().addToFavorite(entryId, uid);
    getUser(uid).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }
}
