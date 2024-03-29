// ignore_for_file: file_names, avoid_print

import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:memo_share/domain/entry.dart';
import 'package:memo_share/pages/home.dart';
import 'package:memo_share/services/EntryService.dart';
import 'package:memo_share/services/IdService.dart';
import 'package:memo_share/services/UserService.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:universal_platform/universal_platform.dart';

class EntryEditor extends StatefulWidget {
  const EntryEditor({super.key, required String title});

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
  late int uid = ModalRoute.of(context)!.settings.arguments as int;
  EntryService entryService = EntryService();
  late Entry entry;
  String errorLabel = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Editor",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.lightGreen,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
          child: Center(
            child: ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      "Titel",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
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
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                      child: Text(
                    "Inhalt",
                    style: TextStyle(fontSize: 20),
                  )),
                ),
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
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                      child: Text(
                    "Tags",
                    style: TextStyle(fontSize: 20),
                  )),
                ),
                avaiableTags.isEmpty
                    ? const Center(child: Text("Keine Tags mehr verfügbar"))
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
                              mainAxisAlignment: MainAxisAlignment.center,
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
                  child: Center(
                      child: Text(
                    "Privat",
                    style: TextStyle(fontSize: 20),
                  )),
                ),
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
                Center(
                  child: FloatingActionButton(
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
                          var name =
                              "upload/$uid/${DateTime.now().toString()}.${result.files.first.extension!}";

                          added[name] = result;
                          realnames.add(result.files.first.name);
                          setState(() {});
                        } else {
                          if (added.length == 4) {
                            setState(() {
                              errorLabel = "Fehler maximal 4 Bilder erlaubt";
                            });
                          }
                          print("Abgebrochen");
                        }
                      },
                      child: const Icon(
                        Icons.image,
                        color: Colors.white,
                      )),
                ),
                Flex(
                  mainAxisSize: MainAxisSize.min,
                  direction: Axis.vertical,
                  children: realnames
                      .map((e) => Flexible(
                            fit: FlexFit.loose,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(e),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        var toDelete = added.entries
                                            .elementAt(realnames.indexOf(e))
                                            .key;
                                        added.removeWhere(
                                            (key, value) => key == toDelete);
                                        realnames.remove(e);

                                        setState(() {
                                          errorLabel = "";
                                        });
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
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Center(
                    child: Text(
                      errorLabel,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                Center(
                  child: TextButton(
                      onPressed: enableButton()
                          ? null
                          : () async {
                              setState(() {
                                loading = true;
                              });

                              var service = IdService();
                              await service.init();
                              await uploadImages();

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
                      child: const Text("Speichern")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool enableButton() {
    return title.isEmpty || content.isEmpty;
  }

  Future<void> uploadImages() async {
    for (var entry in added.entries) {
      var storageRef = FirebaseStorage.instance.ref(entry.key);
      await storageRef.putData(entry.value.files.first.bytes!);

      var downloadUrl = await storageRef.getDownloadURL();
      imageUrls.add(downloadUrl + entry.key);
    }
  }
}

//FINISH