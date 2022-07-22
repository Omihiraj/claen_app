import 'package:clean_app/models/service.dart';
import 'package:clean_app/services/firebase_service.dart';
import 'package:clean_app/services/location_finder.dart';
import 'package:clean_app/utils/calculator.dart';
import 'package:clean_app/views/pages/auth_page.dart';
import 'package:clean_app/views/user_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';

import '../../models/location.dart';
import '../../utils/date_gen.dart';

enum Status { room, hour, cleaner }

class ServiceDetails extends StatefulWidget {
  final Service service;
  const ServiceDetails({Key? key, required this.service}) : super(key: key);

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  int rooms = 0;
  int hours = 0;
  int cleaners = 0;
  int total = 0;
  int daySelectItem = 0;
  double? latitude;
  double? longitude;
  String year = DateTime.now().year.toString();
  String? selectDate;
  String? selectTime;
  TimeOfDay time = TimeOfDay(hour: 10, minute: 30);
  bool userLog = false;
  String? userId;

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        userLog = true;
        userId = user.email;

        print('User is signed in!');
      }
    });
    print("Rooms $rooms   Hours  $hours  Cleaners  $cleaners");
    LocationFinder.determinePosition().then((Map<String, dynamic> loc) {
      print("Latitude:${loc['latitude']} Altitude:${loc['altitude']}");

      latitude = double.parse(loc['latitude']);
      longitude = double.parse(loc['altitude']);
    });

    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Order Details",
          style: TextStyle(color: Colors.purple),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(children: [
        Stack(
          children: [
            Image.network(
              widget.service.img,
              width: screenWidth,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: screenWidth,
                height: 100,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25))),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: screenWidth * 0.12,
                      height: 8,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(50, 158, 158, 158),
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Text(widget.service.name,
                          maxLines: 2,
                          style: const TextStyle(
                              color: Colors.purple,
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text("Number of Rooms",
              style: TextStyle(
                  color: Colors.purple,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
        ),
        Container(
            height: 70,
            child: listSlide(startNo: 0, count: 10, status: Status.room)),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text("Number of Hours",
              style: TextStyle(
                  color: Colors.purple,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
        ),
        Container(
            height: 70,
            child: listSlide(startNo: 1, count: 10, status: Status.hour)),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text("Number of Cleaners",
              style: TextStyle(
                  color: Colors.purple,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
        ),
        Container(
            height: 70,
            child: listSlide(startNo: 0, count: 10, status: Status.cleaner)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: screenWidth * 0.4,
              height: 50,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 0.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Center(
                  child: Text(
                "\$$total.00",
                style: const TextStyle(
                    color: Colors.purple,
                    fontSize: 28,
                    fontWeight: FontWeight.w500),
              )),
            ),
            InkWell(
              onTap: () {
                Calculator sum = Calculator(
                    bedNo: rooms,
                    hours: hours,
                    lat: "4.5",
                    alt: "2.5",
                    serviceId: widget.service.id);
                setState(() {
                  total = sum.calculate();
                });
              },
              child: Container(
                width: screenWidth * 0.4,
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Colors.purple,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 0.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: const Center(
                    child: Text(
                  "Generate Price",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                )),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text("Select Date",
              style: TextStyle(
                  color: Colors.purple,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
        ),
        Container(height: 120, child: dateListSlide()),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    topLeft: Radius.circular(20)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 0.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: const Text("Select Time",
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
            ),
            InkWell(
                onTap: () async {
                  TimeOfDay? newTime = await showTimePicker(
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Colors.purple, // <-- SEE HERE
                            onPrimary: Colors.white, // <-- SEE HERE
                            onSurface: Colors.lightGreen, // <-- SEE HERE
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              primary: Colors.grey, // button text color
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                    context: context,
                    initialTime: time,
                  );
                  if (newTime == null) return;
                  setState(() {
                    time = newTime;
                    String hour = time.hour.toString().padLeft(2, '0');
                    String minute = time.minute.toString().padLeft(2, '0');
                    selectTime = "$hour:$minute";
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: Text(
                      (time.hour).toString().padLeft(2, '0') +
                          ":" +
                          (time.minute).toString().padLeft(2, '0'),
                      style: const TextStyle(
                          color: Colors.lightGreen,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                )),
          ],
        ),
        const SizedBox(
          height: 40,
        ),
        Center(
          child: InkWell(
            onTap: () {
              if (userLog) {
                FireService.putBook(
                    context: context,
                    userId: userId!,
                    beds: rooms,
                    cleaners: cleaners,
                    date: Timestamp.fromDate(
                        DateTime.parse(selectDate! + " " + selectTime!)),
                    hours: hours,
                    location: [],
                    materials: {"1": 1},
                    price: total,
                    serviceId: widget.service.id,
                    img: widget.service.img,
                    serviceName: widget.service.name);
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StreamBuilder<User?>(
                            stream: FirebaseAuth.instance.authStateChanges(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ServiceDetails(
                                  service: widget.service,
                                );
                              } else {
                                return const AuthPage();
                              }
                            })));
              }

              print(selectDate! + " " + selectTime!);
            },
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(30), right: Radius.circular(30)),
                color: Colors.lightGreen,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 0.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              width: screenWidth * 0.8,
              child: const Center(
                  child: Text("Add to cart",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w600))),
            ),
          ),
        ),
        const SizedBox(
          height: 100,
        ),
      ]),
    );
  }

  checkColor(Status status, int itemNo, String widgetType) {
    if (widgetType == "Container") {
      if (status == Status.cleaner && cleaners == itemNo) {
        return Colors.lightGreen;
      } else if (status == Status.hour && hours == itemNo) {
        return Colors.lightGreen;
      } else if (status == Status.room && rooms == itemNo) {
        return Colors.lightGreen;
      } else {
        return Colors.white;
      }
    } else if (widgetType == "Text") {
      if (status == Status.cleaner && cleaners == itemNo) {
        return Colors.white;
      } else if (status == Status.hour && hours == itemNo) {
        return Colors.white;
      } else if (status == Status.room && rooms == itemNo) {
        return Colors.white;
      } else {
        return Colors.grey;
      }
    }
  }

  Widget listSlide(
      {required int startNo, required int count, required Status status}) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: count,
        itemBuilder: ((context, index) {
          int itemNo = index + 1 + startNo;
          return Padding(
            padding: const EdgeInsets.all(10),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (status == Status.cleaner) {
                    cleaners = itemNo;
                  } else if (status == Status.hour) {
                    hours = itemNo;
                  } else if (status == Status.room) {
                    rooms = itemNo;
                  }
                });
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                    color: checkColor(status, itemNo, "Container")),
                child: Center(
                    child: Text(
                  (itemNo).toString().padLeft(2, "0"),
                  style: TextStyle(
                      color: checkColor(status, itemNo, "Text"),
                      fontSize: 28,
                      fontWeight: FontWeight.w500),
                )),
              ),
            ),
          );
        }));
  }

  Widget dateListSlide() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: getDate()[0].length,
        itemBuilder: ((context, index) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: InkWell(
              onTap: () {
                setState(() {
                  String monthNo =
                      getDate()[3][index].toString().padLeft(2, '0');
                  String day = getDate()[0][index].toString().padLeft(2, '0');
                  selectDate = "$year-$monthNo-$day";
                  daySelectItem = index;
                });
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                    color: index == daySelectItem
                        ? Colors.lightGreen
                        : Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: Text(
                      (getDate()[1][index]),
                      style: TextStyle(
                          color: index == daySelectItem
                              ? Colors.white
                              : Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    )),
                    Center(
                        child: Text(
                      (getDate()[0][index]).toString().padLeft(2, "0"),
                      style: TextStyle(
                          color: index == daySelectItem
                              ? Colors.white
                              : Colors.grey,
                          fontSize: 28,
                          fontWeight: FontWeight.w500),
                    )),
                    Center(
                        child: Text(
                      (getDate()[2][index]),
                      style: TextStyle(
                          color: index == daySelectItem
                              ? Colors.white
                              : Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    )),
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
//   Widget dropDownBed() {
//     return DropdownButton<String>(
//       value: bedNo,
//       icon: const Icon(Icons.arrow_downward),
//       elevation: 16,
//       style: const TextStyle(color: Colors.deepPurple),
//       onChanged: (String? newValue) {
//         setState(() {
//           bedNo = newValue!;
//         });
//       },
//       items: <String>['1', '2', '3', '4', '5', '6', '7', '8']
//           .map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     );
//   }

//   Widget dropDownHour() {
//     return DropdownButton<String>(
//       value: hours,
//       icon: const Icon(Icons.arrow_downward),
//       elevation: 16,
//       style: const TextStyle(color: Colors.deepPurple),
//       onChanged: (String? newValue) {
//         setState(() {
//           hours = newValue!;
//         });
//       },
//       items: <String>['2', '3', '4', '5', '6', '7', '8', '9']
//           .map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     );
//   }
// }




// Column(
//           children: [
//             Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [const Text("No Of Beedrooms"), dropDownBed()]),
//             const SizedBox(
//               height: 10,
//             ),
//             Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [const Text("No Of Hours"), dropDownHour()]),
//             Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//               Text("Total :$total"),
//               TextButton(
//                   onPressed: () {
//                     Calculator sum = Calculator(
//                         bedNo: int.parse(bedNo),
//                         hours: int.parse(hours),
//                         lat: "4.5",
//                         alt: "2.5",
//                         serviceId: widget.service.id);
//                     setState(() {
//                       total = sum.calculate();
//                     });
//                   },
//                   child: const Text("Calculate"))
//             ])
//           ],
//         ),
//         TextButton(
//             onPressed: () {
//               FireService.putBook(
//                   userId: "1234",
//                   beds: int.parse(bedNo),
//                   cleaners: 5,
//                   date: Timestamp.fromDate(DateTime.now()),
//                   hours: int.parse(hours),
//                   location: [],
//                   materials: {"1": 1},
//                   price: 20,
//                   serviceId: "",
//                   img: "",
//                   serviceName: "");
//             },
//             child: Text("Send"))