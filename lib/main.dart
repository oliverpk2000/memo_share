import 'package:flutter/material.dart';
import 'package:memo_share/pages/EntryPage.dart';
import 'package:memo_share/pages/register.dart';
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
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: "/register",
      routes: {
        "/home": (context) =>  Home(title:"MemoShare", user: User.defaultUser()),
        "/login": (context) => Login(),
        "/register": (context) => Register(),
        "/entry": (context) => EntryPage(title: "Entry"),
        "/test": (context) => Test(),
      },
    );
  }
}

