import 'package:flutter/material.dart';
import 'package:memo_share/domain/user.dart';

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
    );
  }
}
