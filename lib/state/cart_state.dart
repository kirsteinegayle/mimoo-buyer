import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class CartState extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _items.fold(0.0, (sum, item) => sum + item.product.price * item.quantity);

  void add(Product product) {
    final existing = _items.where((i) => i.product.id == product.id);
    if (existing.isNotEmpty) {
      existing.first.quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void remove(Product product) {
    _items.removeWhere((i) => i.product.id == product.id);
    notifyListeners();
  }

  void increment(Product product) {
    _items.firstWhere((i) => i.product.id == product.id).quantity++;
    notifyListeners();
  }

  void decrement(Product product) {
    final item = _items.firstWhere((i) => i.product.id == product.id);
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(item);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  bool contains(Product product) =>
      _items.any((i) => i.product.id == product.id);
}
