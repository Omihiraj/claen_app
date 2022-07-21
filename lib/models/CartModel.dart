import 'package:clean_app/models/book.dart';
import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  final List<Book> _items = [];

  /// The current total price of all items (assuming all items cost $42).
  List get totalPrice => _items;

  /// Adds [item] to cart. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void add(Book item) {
    _items.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _items.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
