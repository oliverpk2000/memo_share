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
  List<String> realnames = [];
  Map<String, FilePickerResult> added = {};
  List<String> imageUrls = [];
  late int uid =
      ModalRoute.of(context)!.settings.arguments as int;
  EntryService entryService = EntryService();
  late Entry entry;
  String errorLabel = "";

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

              FloatingActionButton(
                  backgroundColor: Colors.lightBlueAccent,
                  heroTag: "image",
                  onPressed: () async {
                    FilePickerResult? result;
                    if (UniversalPlatform.isWeb) {
                      result = await FilePickerWeb.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ["png", "jpg", "jpeg"]);

                    } else {
                      result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ["png", "jpg", "jpeg"]);
                    }

                    if (result != null && added.length < 4) {
                      var name = "upload/$uid-${DateTime.now().toString()}.${result.files.first.extension!}";

                      added[name] = result;
                      realnames.add(result.files.first.name);
                      print(added);
                      print(realnames);

                      setState(() {
                        errorLabel = "";
                      });

                    } else {
                      if (added.length == 4) {
                        setState(() {
                          errorLabel = "Fehler maximal 4 Bilder erlaubt";
                        });
                      }
                      print("Abgebrochen");
                    }

                  },
                  child: const Icon(Icons.image, color: Colors.white,)),

              Text(errorLabel, style: const TextStyle(color: Colors.red),),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              ),
              TextButton(
                  onPressed: enableButton()
                      ? null
                      : () async {
                          var service = IdService();
                          await service.init();

                          added.forEach((key, value) async {
                            var storageRef = FirebaseStorage.instance.ref(key);
                            await storageRef.putData(value.files.first.bytes!);

                            var downloadUrl = await storageRef.getDownloadURL();
                            imageUrls.add(downloadUrl + key);
                          });

                          print(imageUrls);

                          entry = Entry.withNewID(
                              title: title,
                              content: content,
                              tags: chosenTags,
                              private: private,
                              imageUrls: imageUrls,
                              created: DateTime.now(),
                              creatorId: uid,
                              idService: service);

                          print(entry);

                          await entryService.addEntry(entry);
                          UserService()
                              .addToCreated(entry.id, uid)
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
    return title.isEmpty || content.isEmpty;
  }
}
