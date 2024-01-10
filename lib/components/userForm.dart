import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key, required this.loginUser});

  final void Function(String, String) loginUser;

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  String username = "";
  String password = "";
  TextEditingController nameControler = TextEditingController();
  TextEditingController passwordControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(700.0, 30.0, 700.0, 0),
      child: Center(
        child: Column(
          children: <Widget>[
            const Text(
              'Username:',
              style: TextStyle(fontSize: 20),
            ),
            TextField(
              controller: nameControler,
              autofocus: true,
              onChanged: (newName) {
                setState(() {
                  username = newName;
                });
              },
            ),
            const Padding(padding: EdgeInsets.all(20.0)),
            const Text(
              'Passwort:',
              style: TextStyle(fontSize: 20),
            ),
            TextField(
              controller: passwordControler,
              autofocus: true,
              obscureText: true,
              onChanged: (newPassword) {
                setState(() {
                  password = newPassword;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: TextButton(
                  style: const ButtonStyle(),
                  onPressed: (username.isEmpty || password.isEmpty) //Validation
                      ? null
                      : () async {
                          var hashed =
                              sha224.convert(utf8.encode(password)).toString();
                          widget.loginUser(nameControler.text, hashed);

                          setState(() {
                            nameControler.text = ""; //Reset Text
                            passwordControler.text = "";
                          });
                        },
                  child: const Text(
                    "Einloggen",
                    style: TextStyle(fontSize: 20),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

//FINISH
