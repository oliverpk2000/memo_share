import 'package:flutter/material.dart';
import 'package:memo_share/domain/entry.dart';
import 'package:memo_share/pages/home.dart';
import 'package:memo_share/services/EntryService.dart';
import 'package:memo_share/services/IdService.dart';
import 'package:memo_share/services/UserService.dart';

class EntryUpdater extends StatefulWidget {
  const EntryUpdater({super.key});

  @override
  State<EntryUpdater> createState() => _EntryUpdaterState();
}

class _EntryUpdaterState extends State<EntryUpdater> {
  late Entry? entry = ModalRoute.of(context)!.settings.arguments as Entry?;
  late String title = entry!.title;
  late String content = entry!.content;
  late List<String> chosenTags = entry!.tags;
  List<String> avaiableTags = List.of(tags);
  String dropDownValue = tags.first;
  late bool private = entry!.private;
  late List<String> imageUrls = entry!.imageUrls;
  late int uid = entry!.creatorId;
  EntryService entryService = EntryService();

  @override
  Widget build(BuildContext context) {
    setState(() {
      for (String tag in chosenTags) {
        avaiableTags.remove(tag);
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editor"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Center(
          child: Column(
            children: [
              const Text("Titel"),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Titel hier eingeben',
                ),
                initialValue: title,
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
              const Text("Inhalt"),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Inhalt des Beitrages eingeben',
                ),
                initialValue: content,
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
                            backgroundColor: Colors.green,
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
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
              Flex(
                mainAxisSize: MainAxisSize.min,
                direction: Axis.vertical,
                children: chosenTags
                    .map((e) => Flexible(
                          fit: FlexFit.loose,
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              ),
              const Text("Privat"),
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
              const Text("Bilder"),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Image Paths with ,',
                ),
                initialValue: urlsToString(imageUrls),
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
                          var service = IdService();
                          await service.init();

                          entry = Entry(
                            id: entry!.id,
                              title: title,
                              content: content,
                              tags: tags,
                              private: private,
                              imageUrls: imageUrls,
                              created: DateTime.now(),
                              creatorId: uid,
                          );

                          await entryService.updateEntry(entry!, entry!.id);
                          UserService()
                              .addToCreated(entry!.id, uid)
                              .whenComplete(() => Navigator.pop(context));
                        },
                  child: const Text("Speichern"))
            ],
          ),
        ),
      ),
    );
  }

  bool enableButton() {
    setState(() {
      entry = Entry(
          id: 0,
          title: title,
          content: content,
          tags: chosenTags,
          private: private,
          imageUrls: imageUrls,
          created: DateTime.now(),
          creatorId: uid);
    });

    if (entry!.title.isEmpty || entry!.content.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  String urlsToString(List<String> urls) {
    String urlString = "";
    for (String url in urls) {
      urlString += ", $url";
    }
    return urlString;
  }
}
