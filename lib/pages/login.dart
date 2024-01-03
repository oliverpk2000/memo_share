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
        title: Text("Login to MemoShare"),
      ),
      body: UserForm(loginUser: (username, password) async{
        print(username);
        print(password);
      },)
    );
  }
}
