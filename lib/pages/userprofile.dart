import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:memo_share/services/UserService.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../domain/user.dart';

class Userprofile extends StatefulWidget {
  const Userprofile({super.key, required String title});

  @override
  State<Userprofile> createState() => _UserprofileState();
}

class _UserprofileState extends State<Userprofile> {
  late User user = ModalRoute.of(context)!.settings.arguments as User;
  var password = "";
  var username = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black38,
          title: const Text('Profil', style: TextStyle(color: Colors.white),),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 200, vertical: 50),
          child: Center(
            child: Column(
              children: [
                Text("Username: ${user.username}", style: const TextStyle(fontSize: 30),),

                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('Username ändern:'),
                ),

                TextField(
                  decoration: const InputDecoration(
                    hintText: "New Username",
                  ),
                  onChanged: (newUsername) {
                    setState(() {
                      username = newUsername;
                    });
                  },
                ),

                TextButton(
                    onPressed: () {
                      setState(() {
                        loading = true;
                      });

                      pushUsername(username, user.id)
                      .whenComplete(() {
                        setState(() {
                          loading = false;
                        });
                        Navigator.pop(context);
                      });
                    },
                    child: const Text('Speichern')),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 40),
                  child: Text('Passwort ändern:'),
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: "Neues Passwort"
                  ),
                  obscureText: true,
                  onChanged: (newPassword) {
                    setState(() {
                      password = newPassword;
                    });
                  },
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        loading = true;
                      });

                      pushPassword(password, user.id).whenComplete(()  {
                        setState(() {
                          loading = false;
                        });
                      });
                    },
                    child: const Text('Speichern')),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: IconButton(onPressed: () => Navigator.pushNamed(context, "/login"), icon: const Icon(Icons.logout, color: Colors.red,)),
                )

              ],
            ),
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
}
