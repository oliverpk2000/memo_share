import 'package:flutter/material.dart';
import 'package:memo_share/components/PublicTile.dart';
import 'package:memo_share/domain/entry.dart';
import 'package:memo_share/services/EntryService.dart';
import 'package:memo_share/services/UserService.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Hub extends StatefulWidget {
  const Hub({super.key});

  @override
  State<Hub> createState() => _HubState();
}

class _HubState extends State<Hub> {
  late int uid = 0;
  late List<Entry> otherEntries = [];
  bool loading = true;
  List<int> liked = [];

  Future<void> getOtherEntries() async {
    var entries = await EntryService().getPublic();
    otherEntries =
        entries.where((element) => element.creatorId != uid).toList();
  }

  @override
  void didChangeDependencies() {
    uid = ModalRoute.of(context)!.settings.arguments as int;

    getOtherEntries().whenComplete(() {
      UserService().getUser(uid).then((value) {
        liked = value.liked;

        setState(() {
          loading = false;
        });
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
          title: const Text(
            "MemoShare-Hub",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: otherEntries.isEmpty
            ? const Center(child: Text("Keine anderen Einträge"))
            : Flex(direction: Axis.horizontal, children: [
                Expanded(
                    child: ListView.builder(
                        itemCount: otherEntries.length,
                        itemBuilder: (context, index) {
                          final entry = otherEntries.elementAt(index);

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
                                  child: PublicTile(
                                      entry: entry,
                                      alreadyLiked: liked.contains(entry.id),
                                      like: like,
                                      unlike: unlike)));
                        }))
              ]),
      ),
    );
  }

  like(entryId) async {
    loading = true;
    await UserService().addToLiked(entryId, uid);
    getOtherEntries().whenComplete(() {
      UserService().getUser(uid).then((value) {
        liked = value.liked;

        setState(() {
          loading = false;
        });
      });
    });
  }

  unlike(entryId) async {
    loading = true;
    await UserService().deleteLiked(entryId, uid);
    getOtherEntries().whenComplete(() {
      UserService().getUser(uid).then((value) {
        liked = value.liked;

        setState(() {
          loading = false;
        });
      });
    });
  }
}
