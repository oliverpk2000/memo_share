import 'package:flutter/material.dart';

class Liked extends StatefulWidget {
  const Liked({super.key, required String title});

  @override
  State<Liked> createState() => _FavoritesState();
}

class _FavoritesState extends State<Liked> {
  late Map<String, dynamic> pageData =
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  late List<int> idList = pageData["idList"];
  late int uid = pageData["uid"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: const Text("Geliked"),
      ),
      body: const Placeholder(),
    );
  }
}
