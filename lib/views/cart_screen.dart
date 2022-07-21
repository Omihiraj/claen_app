import 'package:clean_app/models/book.dart';

import 'package:clean_app/services/firebase_service.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int total = 0;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            height: screenHeight * 0.55,
            child: StreamBuilder<List<Book>>(
              stream: FireService.getBook(),
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

                        total = TotalCal(book: bookings).calculateTotal();

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
          ),
          Container(
            height: screenHeight * 0.45,
            decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 6,
                    offset: Offset(0.0, -1.0),
                  )
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Center(
                      child: Container(
                    width: screenWidth * 0.1,
                    height: 7,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(141, 158, 158, 158),
                        borderRadius: BorderRadius.circular(30)),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: const [
                      Text(
                        "Total",
                        style: TextStyle(
                            color: Colors.purple,
                            fontSize: 32,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    width: screenWidth * 0.9,
                    height: 1,
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: InkWell(
                    child: Container(
                      width: screenWidth * 0.7,
                      decoration: BoxDecoration(
                          color: Colors.lightGreen,
                          borderRadius: BorderRadius.circular(25)),
                      padding: const EdgeInsets.all(20),
                      child: const Center(
                          child: Text(
                        "Check Out",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      )),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
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
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15)),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      topLeft: Radius.circular(15),
                      bottomRight: Radius.circular(40),
                      topRight: Radius.circular(40)),
                  child: Image.network(
                    fit: BoxFit.cover,
                    book.img,
                    width: screenWidth * 0.2,
                    height: 100,
                  ),
                ),
                const SizedBox(
                  width: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: screenWidth * 0.5,
                      child: Text(
                        book.serviceName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
                          width: 20,
                        ),
                        const Icon(Icons.timelapse_rounded,
                            color: Colors.lightGreen),
                        Text(
                          book.hours.toString() + "hrs",
                          style: const TextStyle(
                              color: Colors.purple, fontSize: 20),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Icon(Icons.person, color: Colors.lightGreen),
                        Text(
                          book.cleaners.toString(),
                          style: const TextStyle(
                              color: Colors.purple, fontSize: 20),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text("\$${book.price}.00",
                        style:
                            const TextStyle(color: Colors.purple, fontSize: 20))
                  ],
                ),
                IconButton(
                  onPressed: () {
                    FireService.deleteBook(book.bookingId);
                  },
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                )
              ],
            )),
      ),
    );
  }
}

class TotalCal {
  final List<Book> book;
  TotalCal({required this.book});

  calculateTotal() {
    int total = 0;
    for (int i = 0; i < book.length; i++) {
      total += book[i].price;
    }
    return total;
  }
}
