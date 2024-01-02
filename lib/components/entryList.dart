import 'package:flutter/material.dart';
import 'package:memo_share/domain/entry.dart';
import 'package:memo_share/services/EntryService.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class EntryList extends StatefulWidget {
  const EntryList({super.key, required this.idList});

  final List<int> idList;

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
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: ListView.builder(
          itemCount: entryList.length,
          itemBuilder: (context, index) {
            final entry = entryList.elementAt(index);
            return Container(
              margin: const EdgeInsets.fromLTRB(100.0, 10.0, 100.0, 10.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  color: Colors.lightBlueAccent[100]),
              child: ListTile(
                title: Text(entry.title),
                subtitle: Text(entry.created.toString()),
                trailing: SizedBox(
                  width: 120.0,
                  child: Row(
                    children: [
                      IconButton(onPressed: () {
                        Navigator.pushNamed(context, "/entry", arguments: {"id": entry.id});
                      },
                          icon: const Icon(Icons.more_horiz)),

                      IconButton(
                          onPressed: () async {
                            loading = true;

                            await EntryService()
                                .deleteEntry(entry.id)
                                .whenComplete(() => getEntryList(widget.idList));
                                    //.whenComplete(() => loading = false));
                          },
                          icon: const Icon(Icons.delete)),
                      IconButton(
                        onPressed: () {
                          print('unfinished lmoa');
                          //TODO: link to ertl's entry editor
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
