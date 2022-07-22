import 'package:clean_app/models/book.dart';
import 'package:clean_app/models/location.dart';
import 'package:clean_app/models/service.dart';
import 'package:clean_app/views/cart_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FireService {
  static Stream<List<Service>> getServices() => FirebaseFirestore.instance
      .collection('services')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Service.fromJson(doc.data())).toList());

  static Stream<List<Location>> getLocations(String id) => FirebaseFirestore
      .instance
      .collection("service-location")
      .where("service-id", isEqualTo: "7WFeiBlUllVLBkzFF7ey")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Location.fromJson(doc.data())).toList());

  static Future putBook(
      {required BuildContext context,
      required String userId,
      required int beds,
      required int cleaners,
      required Timestamp date,
      required int hours,
      required List<String> location,
      required Map<String, int> materials,
      required int price,
      required String serviceId,
      required String serviceName,
      required String img}) async {
    final String bookingId =
        FirebaseFirestore.instance.collection("booking").doc().id;
    final book =
        FirebaseFirestore.instance.collection("booking").doc(bookingId);
    final bookItem = Book(
        bookingId: bookingId,
        serviceName: serviceName,
        img: img,
        userId: userId,
        beds: beds,
        cleaners: cleaners,
        date: date,
        hours: hours,
        location: location,
        materials: materials,
        price: price,
        serviceId: serviceId,
        status: 0);

    final json = bookItem.toJson();
    await book
        .set(json)
        .then((value) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => CartScreen())))
        .catchError((error) {
      print("Some Error Occured");
    });
  }

  static Stream<List<Book>> getBook(String id) => FirebaseFirestore.instance
      .collection("booking")
      .where("user-id", isEqualTo: id)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Book.fromJson(doc.data())).toList());

  static Stream<List<Book>> activeOrders(String id) =>
      FirebaseFirestore.instance
          .collection("booking")
          .where("status", isEqualTo: 1)
          .where("user-id", isEqualTo: id)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Book.fromJson(doc.data())).toList());

  static Stream<List<Book>> completeOrders(String id) =>
      FirebaseFirestore.instance
          .collection("booking")
          .where("status", isEqualTo: 2)
          .where("user-id", isEqualTo: id)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Book.fromJson(doc.data())).toList());

  static deleteBook(String id) =>
      FirebaseFirestore.instance.collection("booking").doc(id).delete();

  static Future signInFire(String user, String pass) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: user, password: pass);
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  static Future signUpFire(String user, String pass) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: user, password: pass);
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }
}
