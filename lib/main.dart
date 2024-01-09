import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:memo_share/components/entryEditor.dart';
import 'package:memo_share/pages/entryPage.dart';
import 'package:memo_share/pages/Hub.dart';
import 'package:memo_share/pages/userprofile.dart';
import 'package:memo_share/pages/favorites.dart';
import 'package:memo_share/pages/liked.dart';
import 'package:memo_share/pages/register.dart';
import 'package:memo_share/components/entryUpdater.dart';
import 'firebase_options.dart';

import 'pages/home.dart';
import 'pages/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        "/home": (context) =>  const Home(title:"MemoShare"),
        "/login": (context) => const Login(),
        "/register": (context) => const Register(),
        "/entry": (context) => const EntryPage(title: "Entry"),
        "/editor": (context) => const EntryEditor(),
        "/updater": (context) => const EntryUpdater(),
        "/favorites": (context) => const Favorites(title: "Favoriten"),
        "/liked" : (context) => const Liked(title: "Liked"),
        "/profile" : (context) => const Userprofile(title: "Profil",),
        "/hub" : (context) => const Hub(),
      },
    );
  }
}

