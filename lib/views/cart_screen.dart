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
    return ListView(children: [
      Container(
        width: double.infinity,
        height: screenHeight * 0.6,
        child: Scaffold(
          body: FutureBuilder<List<Book>>(
            future: FireService.getBook().first,
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
      ),
      Container(child: Text("Total Price :$total"))
    ]);
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
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15)),
            padding: const EdgeInsets.all(10.0),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.serviceId,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text("Price :\$ ${book.price}.00",
                        style: TextStyle(
                          color: Colors.green[900],
                        ))
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    book.img,
                    width: screenWidth * 0.3,
                  ),
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
