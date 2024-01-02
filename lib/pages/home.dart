import 'package:flutter/material.dart';
import 'package:memo_share/components/entryList.dart';
import 'package:memo_share/domain/user.dart';
import 'package:memo_share/domain/entry.dart';

class Home extends StatefulWidget {
  const Home({super.key, required String title, required this.user});

  final User user;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MemoShare"),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Created Entries'),
            Expanded(child: EntryList(entryList: widget.user.created)),
            const Text('favorite Entries'),
            Expanded(child: EntryList(entryList: widget.user.favorited)),
            const Text('liked Entries'),
            Expanded(child: EntryList(entryList: widget.user.liked)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("added entry lmoa");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
