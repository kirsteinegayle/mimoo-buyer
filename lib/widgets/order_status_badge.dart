import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({super.key, required this.status});
  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      OrderStatus.pending => ('Pending', Colors.grey),
      OrderStatus.toShip => ('To Ship', Colors.blue),
      OrderStatus.inTransit => ('In Transit', Colors.orange),
      OrderStatus.outForDelivery => ('Out for Delivery', Colors.purple),
      OrderStatus.delivered => ('Delivered', Colors.green),
      OrderStatus.cancelled => ('Cancelled', Colors.red),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}
