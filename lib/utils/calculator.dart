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

  var locList = [];
  int price = 0;
  calculate() async {
    double distanceInMeters = 0;
    double minDistance = 9000000;

    final location = await FireService.getLocations(serviceId).first;

    for (int i = 0; i < location.length; i++) {
      locList.add(location[i].lName);
      distanceInMeters = Geolocator.distanceBetween(
          double.parse(lat),
          double.parse(alt),
          location[i].location.latitude,
          location[i].location.longitude);
      if (minDistance > distanceInMeters) {
        minDistance = distanceInMeters;
        price = location[i].price;
      }
    }

    return bedNo * hours * price;
  }
}
