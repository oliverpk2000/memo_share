import 'dart:html';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memo_share/domain/entry.dart';
import 'package:memo_share/services/EntryService.dart';

class EntryEditor extends StatefulWidget {
  const EntryEditor({super.key});

  @override
  State<EntryEditor> createState() => _EntryEditorState();
}

class _EntryEditorState extends State<EntryEditor> {
  late int id = entry!.id;
  late String title = "";
  late String content = "";
  late List<String> tags;
  late bool private = false;
  late List<String> imageUrls;
  late Entry? entry =  ModalRoute.of(context)!.settings.arguments as Entry?;
  EntryService entryService = EntryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        title: const Text("Editor"),
      ),
      body: Center(
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
          TextField(
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
          ),
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
          TextButton(onPressed: () {
            setState(() {
              entry = Entry(id:id, title:title, content:content, tags:tags, private:private, imageUrls:imageUrls);

              entryService.addEntry(entry!);
            });
          }, child: const Text("save"))
        ],
      ),
    ),
    );
  }
}
