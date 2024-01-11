// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:memo_share/components/userForm.dart';
import 'package:memo_share/services/UserService.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../domain/user.dart';

class Login extends StatefulWidget {
  const Login({super.key, required String title});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                register:false,
                loginUser: (username, password) async {
                  setState(() {
                    loading = true;
                  });

                  try {
                    var toLogin = User(
                        id: 0,
                        username: username,
                        password: password,
                        created: [],
                        liked: [],
                        favorited: []);

                    var userWithData = await UserService().login(toLogin);
                    setState(() {
                      loading = false;
                    });
                    Navigator.pushNamed(context, "/home",
                        arguments: userWithData.id);

                    setState(() {
                      errors = "";
                    });

                  } catch (error) {
                    setState(() {
                      errors = "Fehler: $error";
                      loading = false;
                    });
                  }
                },
              ),
              Text(
                errors,
                style: const TextStyle(color: Colors.red),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text("Keinen Account?", style: TextStyle(fontSize: 15),),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("/register");
                  },
                  child: const Text('Registrieren', style: TextStyle(fontSize: 15),)),
            ],
          )),
    );
  }
}

//FINISH
