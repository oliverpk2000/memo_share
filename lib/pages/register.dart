// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:memo_share/services/IdService.dart';
import 'package:memo_share/services/UserService.dart';

import '../components/userForm.dart';
import '../domain/user.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String errors = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 200,
          toolbarHeight: 75,
          title: const Text(
            "Als MemoShare User registrieren",
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
                var service = IdService();
                await service.init();

                try {
                  var newUser = User.withNewId(
                      username: username,
                      password: password,
                      liked: [],
                      favorited: [],
                      created: [],
                      idService: service);

                  //print(newUser);
                  await UserService().registerUser(newUser);
                  Navigator.pushNamed(context, "/home", arguments: newUser.id);

                  setState(() {
                    errors = "";
                  });
                } catch (error) {
                  setState(() {
                    errors = "Username existiert bereits";
                    service.removeUserId();
                  });
                }
              },
            ),
            Text(
              errors,
              style: const TextStyle(color: Colors.red),
            ),
            const Text("Schon einen Account?"),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/login");
                },
                child: const Text('Login')),
          ],
        ));
  }
}
