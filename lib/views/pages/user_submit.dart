import 'package:clean_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class UserSubmit extends StatefulWidget {
  const UserSubmit({Key? key}) : super(key: key);

  @override
  State<UserSubmit> createState() => _UserSubmitState();
}

class _UserSubmitState extends State<UserSubmit> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool isPassVisible = true;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView(children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(500),
              child: Image.network(
                "https://images.unsplash.com/photo-1638803040283-7a5ffd48dad5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80",
                width: screenWidth / 2,
                height: screenWidth / 2,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
              color: Color.fromARGB(115, 226, 220, 220),
              borderRadius: BorderRadius.circular(20)),
          child: Center(
            child: TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Name',
                contentPadding:
                    const EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
              color: Color.fromARGB(115, 226, 220, 220),
              borderRadius: BorderRadius.circular(20)),
          child: Center(
            child: TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Address',
                contentPadding:
                    const EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
              color: Color.fromARGB(115, 226, 220, 220),
              borderRadius: BorderRadius.circular(20)),
          child: Center(
            child: TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Email',
                contentPadding:
                    const EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
              color: Color.fromARGB(115, 226, 220, 220),
              borderRadius: BorderRadius.circular(20)),
          child: Center(
            child: TextField(
              controller: passController,
              decoration: InputDecoration(
                  hintText: 'Password',
                  contentPadding: const EdgeInsets.only(
                    left: 20.0,
                    top: 15,
                  ),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    highlightColor: secondaryColor,
                    icon: isPassVisible
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        isPassVisible = !isPassVisible;
                      });
                    },
                  )),
              obscureText: isPassVisible,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            width: double.infinity,
            height: 70,
            decoration: BoxDecoration(boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 2.0), //(x,y)
                blurRadius: 10.0,
              ),
            ], color: primaryColor, borderRadius: BorderRadius.circular(30)),
            child: const Center(
                child: Text(
              "Submit",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )),
          ),
        ),
      ]),
    );
  }
}
