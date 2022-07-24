import 'package:clean_app/models/location.dart';
import 'package:clean_app/services/firebase_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class Calculator {
  final int bedNo;
  final int hours;
  final String lat;
  final String alt;
  final String serviceId;

  Calculator(
      {required this.bedNo,
      required this.hours,
      required this.lat,
      required this.alt,
      required this.serviceId});

  late int nearPrice;
  calculate() {
    double distanceInMeters = 0;
    double minDistance = 9000000;
    int price = 0;
    Future<List<Location>> location = FireService.getLocations(serviceId).first;
    Future<int> lastPrice = location.then((value) async {
      for (int i = 0; i < value.length; i++) {
        distanceInMeters = Geolocator.distanceBetween(
            double.parse(lat),
            double.parse(alt),
            value[i].location.latitude,
            value[i].location.longitude);
        if (minDistance > distanceInMeters) {
          minDistance = distanceInMeters;
          price = value[i].price;
        }
        nearPrice = price;
      }
      return nearPrice;
    });
    // int las = await nearPrice ;

    // print(las);
    return bedNo * hours * 10;
  }
}
