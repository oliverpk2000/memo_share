import 'package:flutter/material.dart';
import 'package:memo_share/components/entryEditor.dart';
import 'package:memo_share/pages/test.dart';

import 'domain/user.dart';
import 'pages/home.dart';
import 'pages/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: "/test",
      routes: {
        "/home": (context) =>  Home(title:"MemoShare", user: User.defaultUser()),
        "/login": (context) => const Login(),
        "/test": (context) => const Test(),
        "/editor": (context) => const EntryEditor(),
      },
    );
  }
}

