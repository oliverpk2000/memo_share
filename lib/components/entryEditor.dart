import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:memo_share/domain/entry.dart';
import 'package:memo_share/pages/home.dart';
import 'package:memo_share/services/EntryService.dart';
import 'package:memo_share/services/IdService.dart';
import 'package:memo_share/services/UserService.dart';
import 'package:universal_platform/universal_platform.dart';

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
              const Text("Titel"),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Titel hier eingeben',
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
              const Text("Inhalt"),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Inhalt hier eingeben',
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
                            heroTag: "tag",
                            child: const Icon(
                              Icons.add,
                              color: Colors.green,
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
              /*TextField(
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
              ),*/

              FloatingActionButton(
                  backgroundColor: Colors.red,
                  heroTag: "image",
                  onPressed: () async {
                    print("noch da");
                    FilePickerResult? result;
                    if (UniversalPlatform.isWeb) {
                      result = await FilePickerWeb.platform.pickFiles(
                          allowMultiple: true,
                          type: FileType.custom,
                          allowedExtensions: ["png", "jpg", "jpeg"]);

                    } else {
                      result = await FilePicker.platform.pickFiles(
                          allowMultiple: true,
                          type: FileType.custom,
                          allowedExtensions: ["png", "jpg", "jpeg"]);
                    }

                    if (result != null) {
                      var name = "upload/$uid-${DateTime.now().toString()}.${result.files.first.extension!}";
                      var storageRef = FirebaseStorage.instance.ref(name);
                      await storageRef.putData(result.files.first.bytes!);

                      var downloadUrl = await storageRef.getDownloadURL();
                      imageUrls.add(downloadUrl + name);
                      print(imageUrls);

                    } else {
                      print("Abgebrochen");
                    }

                  }),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              ),
              TextButton(
                  onPressed: enableButton()
                      ? null
                      : () async {
                          var service = IdService();
                          await service.init();

                          entry = Entry.withNewID(
                              title: title,
                              content: content,
                              tags: tags,
                              private: private,
                              imageUrls: imageUrls,
                              created: DateTime.now(),
                              creatorId: uid,
                              idService: service);

                          await entryService.addEntry(entry!);
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
}
