import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:memo_share/services/EntryService.dart';
import 'package:memo_share/services/UserService.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/PublicTile.dart';
import '../domain/entry.dart';
import '../domain/user.dart';

class Userprofile extends StatefulWidget {
  const Userprofile({super.key, required String title});

  @override
  State<Userprofile> createState() => _UserprofileState();
}

class _UserprofileState extends State<Userprofile> {
  late Map<String, dynamic> pageData = {};
  late User user = User.defaultUser();
  late bool other = false;
  late int current = 0;
  var password = "";
  var username = "";
  bool loading = false;
  late List<Entry> userEntries = [];
  List<int> currentLiked = [];

  @override
  void didChangeDependencies() {
    pageData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    other = pageData['other'] ?? false;
    user = pageData['user'];
    current = pageData['current'] ?? user.id;

    if (other) {
      setState(() {
        loading = true;
      });

      print(user);

      EntryService()
      .getEntriesToId(user.created)
      .then((value) {
        userEntries = value.where((element) => !element.private).toList();
        print(userEntries);
        getLiked(current);
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black38,
          title: const Text(
            'Profil',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: Column(
            children: other ? [
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Text("Username: ${user.username}", style: const TextStyle(fontSize: 30),),
              ),
              ListView.builder(
                  itemCount: userEntries.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final entry = userEntries.elementAt(index);

                    return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/entry",
                              arguments: {"id": entry.id, "uid": current});
                        },
                        child: Container(
                            margin: const EdgeInsets.fromLTRB(
                                100.0, 10.0, 100.0, 10.0),
                            decoration: BoxDecoration(
                                border:
                                Border.all(color: Colors.blueAccent),
                                color: Colors.lightBlueAccent[100]),
                            child: PublicTile(
                                entry: entry,
                                icon: currentLiked.contains(entry.id) ? Icons.favorite : Icons.favorite_border,
                                like: like,
                                unlike: unlike)));
                  }),
            ] : [
              Text(
                "Username: ${user.username}",
                style: const TextStyle(fontSize: 30),
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text('Username ändern:'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 200, vertical: 20),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "Neuer Username",
                  ),
                  onChanged: (newUsername) {
                    setState(() {
                      username = newUsername;
                    });
                  },
                ),
              ),
              TextButton(
                style: const ButtonStyle(),
                  onPressed: username.isEmpty ? null : () {
                    setState(() {
                      loading = true;
                    });

                    pushUsername(username, user.id).whenComplete(() {
                      setState(() {
                        loading = false;
                      });
                      Navigator.pop(context);
                    });
                  },
                  child: const Text('Speichern')),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text('Passwort ändern:'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 200, vertical: 20),
                child: TextField(
                  decoration:
                      const InputDecoration(hintText: "Neues Passwort"),
                  obscureText: true,
                  onChanged: (newPassword) {
                    setState(() {
                      password = newPassword;
                    });
                  },
                ),
              ),
              TextButton(
                style: const ButtonStyle(),
                  onPressed: password.isEmpty ? null : () {
                    setState(() {
                      loading = true;
                    });

                    pushPassword(password, user.id).whenComplete(() {
                      setState(() {
                        loading = false;
                      });
                    });
                  },
                  child: const Text('Speichern')),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: IconButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, "/login"),
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.red,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pushUsername(String username, int id) async {
    await UserService().changeUsername(username, id);
  }

  Future<void> pushPassword(String password, int id) async {
    var hash = sha224.convert(utf8.encode(password)).toString();
    await UserService().changePassword(hash, id);
  }

  like(entryId) async {
    setState(() {
      loading = true;
    });

    await UserService().addToLiked(entryId, current);
    getLiked(current);

  }

  unlike(entryId) async {
    setState(() {
      loading = true;
    });

    await UserService().deleteLiked(entryId, current);
    getLiked(current);
  }

  Future<void> getLiked(int uid) async {
    UserService()
        .getUser(current)
        .then((value)  {
       currentLiked = value.liked;

       setState(() {
         loading = false;
       });
    });
  }
}
