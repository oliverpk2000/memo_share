// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:memo_share/components/userForm.dart';
import 'package:memo_share/services/UserService.dart';
import 'package:universal_platform/universal_platform.dart';
import '../domain/user.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String errors = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 200,
          toolbarHeight: 75,
          title: const Text(
            "MemoShare Login",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.purple,
          centerTitle: true,
          leading: Image.asset("images/logotransparent_fullhd.png"),
        ),
        body: Column(
          children: <Widget>[
            UserForm(
              loginUser: (username, password) async {
                try {
                  var toLogin = User(
                      id: 0,
                      username: username,
                      password: password,
                      created: [],
                      liked: [],
                      favorited: []);
                  var userWithData = await UserService().login(toLogin);
                  Navigator.pushNamed(context, "/home",
                      arguments: userWithData.id);

                  setState(() {
                    errors = "";
                  });
                } catch (error) {
                  setState(() {
                    errors = "Fehler: $error";
                  });
                }
              },
            ),
            Text(
              errors,
              style: const TextStyle(color: Colors.red),
            ),
            const Text("Keinen Account?"),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/register");
                },
                child: const Text('Registrieren')),
          ],
        ));
  }
}
