import 'package:clean_app/models/book.dart';
import 'package:clean_app/models/location.dart';
import 'package:clean_app/models/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      {required String userId,
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
    final book = FirebaseFirestore.instance.collection("booking").doc();
    final bookItem = Book(
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
    await book.set(json);
  }

  static Stream<List<Book>> getBook() => FirebaseFirestore.instance
      .collection("booking")
      .where("user-id", isEqualTo: "9876")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Book.fromJson(doc.data())).toList());

  static Stream<List<Book>> activeOrders() => FirebaseFirestore.instance
      .collection("booking")
      .where("status", isEqualTo: 1)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Book.fromJson(doc.data())).toList());

  static Stream<List<Book>> completeOrders() => FirebaseFirestore.instance
      .collection("booking")
      .where("status", isEqualTo: 2)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Book.fromJson(doc.data())).toList());
}
