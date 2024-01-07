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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(100.0, 10.0, 100.0, 0),
      child: Center(
        child: Column(
          children: <Widget> [
            const Text('Username:'),
            TextField(
              autofocus: true,
              onChanged: (value) {
                setState(() {
                  username = value;
                });
              },
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
            const Text('Passwort:'),
            TextField(
              autofocus: true,
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextButton(
                style: ButtonStyle(),
                  onPressed: (username.isEmpty || password.isEmpty)
                      ? null
                      : ()  {
                    password = sha224.convert(utf8.encode(password)).toString();
                    widget.loginUser(username, password);
                  },
                  child: const Text("Einloggen")),
            )
          ],
        ),
      ),
    );
  }
}
