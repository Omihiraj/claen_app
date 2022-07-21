import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: "Email")),
        const SizedBox(
          height: 20,
        ),
        TextField(
            controller: passController,
            decoration: const InputDecoration(
              labelText: "Password",
            )),
        const SizedBox(
          height: 20,
        ),
        TextButton(onPressed: signIn, child: const Text("Sign In"))
      ]),
    );
  }

  Future signIn() async {
    // await FirebaseAuth.instance.signInWithEmailAndPassword(
    //     email: "omihiraj@gmail.com", password: "1234@qwer");
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "omihiraj@gmail.com", password: "1234@qwer");
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }
}
