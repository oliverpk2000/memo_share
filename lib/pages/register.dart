import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

import '../components/userForm.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("register as MemoShare User"),
        ),
        body: Column(
          children: [
            UserForm(loginUser: (username, password) async{
              print(username);
              var hashedPassword = sha224.convert(utf8.encode(password));
              print(hashedPassword);
            },),
            const Text("already a member? login here:"),
            TextButton(onPressed: (){Navigator.of(context).pushNamed("/login");}, child: const Text('login'))
          ],
        )
    );
  }
}
