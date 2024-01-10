// ignore_for_file: use_build_context_synchronously

import 'dart:html';

import 'package:flutter/material.dart';
import 'package:memo_share/services/IdService.dart';
import 'package:memo_share/services/UserService.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/userForm.dart';
import '../domain/user.dart';

class Register extends StatefulWidget {
  const Register({super.key, required String title});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String errors = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
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
                  setState(() {
                    loading = true;
                  });

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
                    setState(() {
                      loading = false;
                    });
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
          )),
    );
  }
}
