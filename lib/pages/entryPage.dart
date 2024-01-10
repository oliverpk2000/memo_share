// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:memo_share/services/EntryService.dart';
import 'package:memo_share/services/UserService.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../domain/entry.dart';

class EntryPage extends StatefulWidget {
  const EntryPage({super.key, required String title});

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  late Entry entry = Entry.defaultEntry;
  var loading = true;
  late int currentId = 0;

  void getEntry(Map<String, int> data) {
    int id = data['id']!; //Arguments are passed from home

    try {
      EntryService().getEntry(id).then((value) {
        entry = value;
        currentId = data['uid'] ?? entry.creatorId;

        setState(() {
          loading = false;
        });
      });
    } catch (error) {
      throw "ID does not exsist $id";
    }
  }

  @override
  void didChangeDependencies() {
    var data = ModalRoute.of(context)?.settings.arguments as Map<String, int>;
    getEntry(data);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: loading, //Waiting for DB
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.pink,
            title: const Text("Sieh dir diesen Eintrag genauer an"),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    //Check if entry is public or not
                    var visibility = entry.private ? "privat" : "öffentlich";
                    var snackBar = SnackBar(
                        duration: const Duration(seconds: 2),
                        content: Text(
                            "Dieser Eintrag ist $visibility und wurde am ${entry.created.day}.${entry.created.month}.${entry.created.year}"));

                    setState(() {
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    });
                  },
                  tooltip: "Details",
                  icon: const Icon(
                    Icons.info,
                    color: Colors.white,
                  )),

              if (currentId != entry.creatorId)
                IconButton(onPressed: () async {
                  var user = await UserService().getUser(entry.creatorId);
                  Navigator.pushNamed(context, "/profile", arguments: {"user": user, "other": true, "current": currentId});
                }, icon: const Icon(Icons.person, color: Colors.white,))

            ],
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    entry.title,
                    style: const TextStyle(
                        fontSize: 40.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Text(entry.content),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 60.0),
                  child: Text(
                    "Tags für diesen Eintrag",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: entry.tags.isEmpty
                      ? const Text("Keine Tags für diesen Eintrag gefunden")
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: entry.tags
                              .map((e) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: Text(
                                      e,
                                      style: TextStyle(
                                          backgroundColor: Colors.grey[400]),
                                    ),
                                  ))
                              .toList(),
                        ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Text(
                    "Angefügte Bilder:",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                entry.imageUrls.isEmpty
                    ? const Text("Keine Bilder zu diesem Beitrag hinzugefügt")
                    : Expanded(
                        child: SizedBox(
                          width: entry.imageUrls.length * 300,
                          height: entry.imageUrls.length * 300,
                          child: ListView.builder(
                            itemCount: entry.imageUrls.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Image.network(entry.imageUrls[index]);
                            },
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ));
  }
}
