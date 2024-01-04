import 'package:flutter/material.dart';
import 'package:memo_share/components/CreatedTile.dart';
import 'package:memo_share/components/FavoriteTile.dart';
import 'package:memo_share/components/LikedTile.dart';
import 'package:memo_share/domain/entry.dart';
import 'package:memo_share/services/EntryService.dart';
import 'package:memo_share/services/UserService.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../domain/Modes.dart';

class EntryList extends StatefulWidget {
  const EntryList(
      {super.key, required this.idList, required this.mode, required this.uid});

  final List<int> idList;
  final Modes mode;
  final int uid;

  @override
  State<EntryList> createState() => _EntryListState();
}

class _EntryListState extends State<EntryList> {
  List<Entry> entryList = [];
  bool loading = true;

  Future<void> getEntryList(List<int> idList) async {
    EntryService().getEntriesToId(widget.idList).then((value) {
      entryList = value;
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    getEntryList(widget.idList);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return widget.idList.isNotEmpty
        ? ModalProgressHUD(
            inAsyncCall: loading,
            child: ListView.builder(
                itemCount: entryList.length,
                itemBuilder: (context, index) {
                  final entry = entryList.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/entry",
                          arguments: {"id": entry.id});
                    },
                    child: Container(
                        margin:
                            const EdgeInsets.fromLTRB(100.0, 10.0, 100.0, 10.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent),
                            color: Colors.lightBlueAccent[100]),
                        child: Builder(builder: (context) {
                          if (widget.mode == Modes.created) {
                            return CreatedTile(
                              entry: entry,
                              deleteFunction: deleteCreated,
                            );
                            //TODO liked, public, favorite
                          } else if (widget.mode == Modes.favorite) {
                            return FavoriteTile(
                                entry: entry, deleteFunction: deleteFavorite
                            );
                          } else if (widget.mode == Modes.liked) {
                            return LikedTile(
                                entry: entry, deleteFunction: deleteLiked, uid: widget.uid,
                            );
                          }

                          return Placeholder();
                        })),
                  );
                }),
          )
        : const Text("No entries in this list");
  }

  deleteCreated(entryId) {
    loading = true;
    EntryService().deleteEntry(entryId).whenComplete(() {
      getEntryList(widget.idList);
      UserService()
          .deleteCreated(entryId, widget.uid)
          .whenComplete(() => getEntryList(widget.idList));
    });
  }

  deleteFavorite(entryId) {
    loading = true;
    UserService()
        .deleteFavorite(entryId, widget.uid)
        .whenComplete(() => getEntryList(widget.idList));
  }


  deleteLiked(entryId) {
    loading = true;
    UserService()
        .deleteLiked(entryId, widget.uid)
        .whenComplete(() => getEntryList(widget.idList));
  }

}
