import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:memo_share/components/userForm.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MemoShare Login"),
      ),
      body: Column(
        children: [
          UserForm(loginUser: (username, password) async{
            print(username);
            var hashedPassword = sha224.convert(utf8.encode(password));
            print(hashedPassword);
          },),
          const Text("don't have an account? register here:"),
          TextButton(onPressed: (){Navigator.of(context).pushNamed("/register");}, child: const Text('register'))
        ],
      )
    );
  }
}
