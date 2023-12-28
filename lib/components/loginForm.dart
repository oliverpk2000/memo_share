import 'package:flutter/material.dart';

import '../domain/user.dart';

class loginForm extends StatefulWidget {

  const loginForm({super.key, required this.validateUser});

  final void Function(User) validateUser;

  @override
  State<loginForm> createState() => _loginFormState();
}

class _loginFormState extends State<loginForm> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

