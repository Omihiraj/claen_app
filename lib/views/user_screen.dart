import 'package:clean_app/views/pages/auth_page.dart';
import 'package:clean_app/views/pages/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const UserPage();
              } else {
                return const AuthPage();
              }
            }));
  }
}

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "User Page",
            style: TextStyle(fontSize: 40),
          ),
          const SizedBox(
            height: 50,
          ),
          TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: Text("LogOut")),
        ],
      )),
    );
  }
}
