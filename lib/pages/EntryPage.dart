import 'package:flutter/material.dart';
import 'package:memo_share/services/EntryService.dart';
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


  Future<void> getEntry(Map<String, int> data) async {
    int id = data['id']!; //Arguments are passed in home

    try {
      print(id);
      EntryService()
          .getEntry(id)
          .then((value) {
            entry = value;

            setState(() {
              loading = false;
            });

            print(entry);
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
            title: const Text("Dein Eintrag"),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    //Check if entry is public or not
                    var visibility = entry.private ? "privat" : "öffentlich";
                    var snackBar = SnackBar(
                        duration: const Duration(seconds: 2),
                        content: Text("Dieser Eintrag ist $visibility"));

                    setState(() {
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    });
                  },
                  icon: const Icon(
                    Icons.info,
                    color: Colors.white,
                  )),
              IconButton(
                  //Delete
                  onPressed: () async {
                    Navigator.pop(context);
                    await EntryService().deleteEntry(entry.id);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  )),
              IconButton(
                  //Updating
                  onPressed: () {
                    //TODO implement update
                    //var newEntry = await Navigator.pushnamed("/changeForm, Entry.toJson ...");
                  },
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                  )),
            ],
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                Text(entry.title),
                Text(entry.content),
                const Text("Your Tags:"),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: entry.tags
                        .map((e) => Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Text(e),
                            ))
                        .toList(),
                  ),
                ),
                const Text("Your Images"),
                  SizedBox(
                    width: entry.imageUrls.length * 300,
                    height: entry.imageUrls.length * 300,
                    child: ListView.builder(
                      itemCount: entry.imageUrls.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Image.network(entry.imageUrls[index]);
                    },
                    ),
                  ),
              ],
            ),
          ),
        ));
  }
}
