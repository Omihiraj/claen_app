import 'package:clean_app/constants/constants.dart';
import 'package:clean_app/constants/constants.dart';
import 'package:clean_app/models/user_data.dart';
import 'package:clean_app/views/pages/all_services.dart';
import 'package:clean_app/views/pages/auth_page.dart';
import 'package:clean_app/views/pages/sign_in.dart';
import 'package:clean_app/views/pages/user_submit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool isUserSetup = false;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final user = FirebaseAuth.instance.currentUser!;
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('users')
        .where("user-id", isEqualTo: user.email)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: Container(),
        title: const Text("User Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 400,
              child: StreamBuilder<QuerySnapshot>(
                stream: _usersStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    final user = UserData.fromJson(data);
                    if (data.isNotEmpty) {
                      isUserSetup = true;
                    }

                    return Container(
                        child: Column(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(500),
                            child: Image.network(
                              user.img,
                              width: screenWidth / 2,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth * 0.8,
                        padding: const EdgeInsets.all(5),
                        color: Colors.grey[200],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Name",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              user.name,
                              style: const TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: screenWidth * 0.8,
                        padding: const EdgeInsets.all(5),
                        color: Colors.grey[200],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Address",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              user.address,
                              style: const TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: screenWidth * 0.8,
                        padding: const EdgeInsets.all(5),
                        color: Colors.grey[200],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Mobile",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              user.mobile,
                              style: const TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: screenWidth * 0.8,
                        padding: const EdgeInsets.all(5),
                        color: Colors.grey[200],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "Date Of Birth",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              "1997-08-09",
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ]));
                  }).toList());
                },
              ),
            ),
            isUserSetup == true
                ? Container()
                : InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserSubmit()));
                    },
                    child: Center(
                        child: Container(
                      decoration: const BoxDecoration(color: secondaryColor),
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        "Please Setup Your Details",
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
                  ),
            TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  textStyle: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                child: const Text(
                  "LogOut",
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
      ),
    );
  }
}
