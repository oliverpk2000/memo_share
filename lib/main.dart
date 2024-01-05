import 'package:flutter/material.dart';
import 'package:memo_share/components/entryEditor.dart';
import 'package:memo_share/pages/EntryPage.dart';
import 'package:memo_share/pages/Userprofile.dart';
import 'package:memo_share/pages/favorites.dart';
import 'package:memo_share/pages/liked.dart';
import 'package:memo_share/pages/register.dart';
import 'package:memo_share/pages/test.dart';

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
      initialRoute: "/login",
      routes: {
        "/home": (context) =>  Home(title:"MemoShare"),
        "/login": (context) => const Login(),
        "/register": (context) => const Register(),
        "/entry": (context) => const EntryPage(title: "Entry"),
        "/test": (context) => const Test(),
        "/editor": (context) => const EntryEditor(),
        "/favorites": (context) => const Favorites(title: "Favoriten"),
        "/liked" : (context) => const Liked(title: "Liked"),
        "/profile" : (context) => const Userprofile(title: "Profil",),
      },
    );
  }
}

