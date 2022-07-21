import 'package:clean_app/models/book.dart';
import 'package:clean_app/services/firebase_service.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              "Orders",
              style: TextStyle(color: Colors.purple, fontSize: 32),
            ),
            centerTitle: true,
            bottom: const TabBar(
                indicatorColor: Colors.purple,
                unselectedLabelColor: Colors.grey,
                labelColor: Colors.lightGreen,
                tabs: [
                  Tab(
                    text: "Active Orders",
                  ),
                  Tab(
                    text: "Complete Orders",
                  )
                ]),
          ),
          body: TabBarView(children: [
            StreamBuilder<List<Book>>(
              stream: FireService.activeOrders(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      if (snapshot.data == null) {
                        return const Text('No data to show');
                      } else {
                        final bookings = snapshot.data!;

                        return ListView.builder(
                          itemCount: bookings.length,
                          itemBuilder: (BuildContext context, int index) {
                            return builtService(bookings[index]);
                          },
                        );
                      }
                    }
                }
              },
            ),
            StreamBuilder<List<Book>>(
              stream: FireService.completeOrders(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      if (snapshot.data == null) {
                        return const Text('No data to show');
                      } else {
                        final bookings = snapshot.data!;

                        return ListView.builder(
                          itemCount: bookings.length,
                          itemBuilder: (BuildContext context, int index) {
                            return builtService(bookings[index]);
                          },
                        );
                      }
                    }
                }
              },
            ),
          ])),
    );
  }

  Widget builtService(Book book) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        // onTap: () => Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => ServiceDetails(
        //               service: service,
        //             ))),
        child: Container(
            decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.5), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20)),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        maxLines: 2,
                        book.serviceName,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.lightGreen,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text("\$ ${book.price}.00",
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                            fontSize: 32,
                          )),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.bed,
                            color: Colors.lightGreen,
                          ),
                          Text(
                            book.beds.toString(),
                            style: const TextStyle(
                                color: Colors.purple, fontSize: 20),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          const Icon(Icons.timelapse_rounded,
                              color: Colors.lightGreen),
                          Text(
                            book.hours.toString() + "hrs",
                            style: const TextStyle(
                                color: Colors.purple, fontSize: 20),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(0), right: Radius.circular(20)),
                  child: Image.network(
                    fit: BoxFit.cover,
                    book.img,
                    width: screenWidth * 0.5,
                  ),
                )
              ],
            )),
      ),
    );
  }
}
