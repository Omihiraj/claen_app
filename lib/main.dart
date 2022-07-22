import 'package:clean_app/models/get_total.dart';
import 'package:clean_app/views/cart_screen.dart';

import 'package:clean_app/views/home_screen.dart';
import 'package:clean_app/views/order_screen.dart';
import 'package:clean_app/views/pages/all_services.dart';
import 'package:clean_app/views/user_screen.dart';
import 'package:clean_app/widgets/custom_nav_bar.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final screens = [
    const HomeScreen(),
    const OrderScreen(),
    const CartScreen(),
    const UserScreen()
  ];
  var index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      //body: const Text("Hello"),
      // bottomNavigationBar: NavigationBarTheme(
      //     data: const NavigationBarThemeData(indicatorColor: Colors.lightGreen),
      //     child: NavigationBar(
      //         selectedIndex: index,
      //         onDestinationSelected: (index) => setState(() {
      //               this.index = index;
      //             }),
      //         destinations: const [
      //           NavigationDestination(icon: Icon(Icons.home), label: "Home"),
      //           NavigationDestination(
      //               icon: Icon(Icons.card_giftcard), label: "Order"),
      //           NavigationDestination(
      //               icon: Icon(Icons.person), label: "Profile"),
      //           NavigationDestination(
      //               icon: Icon(Icons.home_work_outlined), label: "Company")
      //         ])),
      bottomNavigationBar: CustomNavBar(
        index: index,
        onChangedTab: onChangedTab,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AllService()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightGreen,
        splashColor: Colors.purple,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void onChangedTab(int index) {
    setState(() {
      this.index = index;
    });
  }
}
