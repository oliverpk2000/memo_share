import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:memo_share/components/profileTile.dart';
import 'package:memo_share/services/UserService.dart';

import '../domain/user.dart';

class Userprofile extends StatefulWidget {
  const Userprofile({super.key, required String title});

  @override
  State<Userprofile> createState() => _UserprofileState();
}

class _UserprofileState extends State<Userprofile> {
  late User? user = ModalRoute.of(context)!.settings.arguments as User?;
  var password = "";
  var username = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('profile'),
      ),
      body: Center(
        child: Column(
          children: [
            profileTile(user: user!),
            const Text('change username:'),
            TextField(
              onChanged: (newUsername) {
                setState(() {
                  username = newUsername;
                });
              },
            ),
            TextButton(
                onPressed: () {
                  pushUsername(username, user!.id);
                },
                child: const Text('submit username changes')),
            const Text('change password:'),
            TextField(
              onChanged: (newPassword) {
                setState(() {
                  password =
                      sha224.convert(utf8.encode(newPassword)).toString();
                });
              },
            ),
            TextButton(
                onPressed: () {
                  pushPassword(password, user!.id);
                },
                child: const Text('submit password changes'))
          ],
        ),
      ),
    );
  }

  Future<void> pushUsername(String username, int id) async {
    await UserService().changeUsername(username, id);
  }

  Future<void> pushPassword(String password, int id) async {
    await UserService().changePassword(password, id);
  }
}
