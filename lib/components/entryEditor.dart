import 'package:flutter/material.dart';
import 'package:memo_share/domain/entry.dart';
import 'package:memo_share/pages/home.dart';
import 'package:memo_share/services/EntryService.dart';
import 'package:memo_share/services/UserService.dart';

class EntryEditor extends StatefulWidget {
  const EntryEditor({super.key});

  @override
  State<EntryEditor> createState() => _EntryEditorState();
}

class _EntryEditorState extends State<EntryEditor> {
  String title = "";
  String content = "";
  List<String> chosenTags = [];
  List<String> avaiableTags = List.of(tags);
  String dropDownValue = tags.first;
  bool private = false;
  List<String> imageUrls = [];
  late Map<String, dynamic> pageData =
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  late Entry? entry = pageData["entry"] as Entry?;
  late int uid = pageData["uid"];
  EntryService entryService = EntryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editor"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Center(
          child: Column(
            children: [
              const Text("Title"),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your Title',
                ),
                autofocus: true,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  setState(() {
                    title = value;
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              ),
              const Text("Content"),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your Text',
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                onChanged: (value) {
                  setState(() {
                    content = value;
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              ),
              const Text("Tags"),
              avaiableTags.isEmpty
                  ? const Text("Keine Tags mehr verfügbar")
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DropdownButton(
                            value: dropDownValue,
                            items: avaiableTags
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                dropDownValue = value!;
                              });
                            }),
                        const Padding(padding: EdgeInsets.only(left: 30)),
                        FloatingActionButton(
                            child: const Text("Add Tag"),
                            onPressed: () {
                              setState(() {
                                avaiableTags.remove(dropDownValue);
                                chosenTags.add(dropDownValue);

                                if (avaiableTags.isEmpty) {
                                  dropDownValue = "";
                                } else {
                                  dropDownValue = avaiableTags.first;
                                }
                              });
                            })
                      ],
                    ),
              SizedBox(
                width: 1000.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: chosenTags
                      .map((e) => Expanded(
                            child: Row(
                              children: [
                                Text(e),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        chosenTags.remove(e);
                                        avaiableTags.add(e);
                                        dropDownValue = avaiableTags.first;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ))
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
              /*TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter the Tags with ,',
              ),
              autofocus: true,
              keyboardType: TextInputType.text,
              onChanged: (value) {
                setState(() {
                  tags = value.split(",");
                });
              },
            ),*/
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              ),
              const Text("Private"),
              Checkbox(
                value: private,
                onChanged: (bool? value) {
                  setState(() {
                    private = value!;
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              ),
              const Text("Images"),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Image Paths with ,',
                ),
                autofocus: true,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  setState(() {
                    imageUrls = value.split(",");
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              ),
              TextButton(
                  onPressed: enableButton()
                      ? null
                      : () async {
                          await entryService.addEntry(entry!);
                          UserService()
                              .addToCreated(entry!.id, uid)
                              .whenComplete(() => Navigator.pop(context));
                        },
                  child: const Text("save"))
            ],
          ),
        ),
      ),
    );
  }

  bool enableButton() {
    setState(() {
      entry = Entry.withNewID(
          title: title,
          content: content,
          tags: chosenTags,
          private: private,
          imageUrls: imageUrls,
          created: DateTime.now(),
          creatorId: uid);
    });

    if (entry!.title.isEmpty && entry!.content.isEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
