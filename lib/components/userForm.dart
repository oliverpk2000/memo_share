import 'package:flutter/material.dart';

import '../domain/user.dart';

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
    return Center(
      child: Column(
        children: [
          const Text('username:'),
          TextField(autofocus: true,
            onChanged: (value){
              username = value;
            },
          ),
          const Text('password:'),
          TextField(autofocus: true,
          onChanged: (value){
            password = value;
          },)
        ],
      ),
    );
  }
}
