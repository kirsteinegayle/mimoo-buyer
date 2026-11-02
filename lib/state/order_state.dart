import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderState extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  List<Order> get activeOrders => _orders
      .where((o) =>
          o.status != OrderStatus.delivered &&
          o.status != OrderStatus.cancelled)
      .toList();

  List<Order> get completedOrders =>
      _orders.where((o) => o.status == OrderStatus.delivered).toList();

  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }

  void updateStatus(String orderId, OrderStatus status) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index] = Order(
        id: _orders[index].id,
        items: _orders[index].items,
        status: status,
        totalAmount: _orders[index].totalAmount,
        placedAt: _orders[index].placedAt,
        voucherCode: _orders[index].voucherCode,
        discount: _orders[index].discount,
        paymentMethod: _orders[index].paymentMethod,
      );
      notifyListeners();
    }
  }
}
