enum OrderStatus {
  pending,
  toShip,
  inTransit,
  outForDelivery,
  delivered,
  cancelled,
}

class OrderItem {
  const OrderItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.variation,
    required this.imageUrl,
  });
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String? variation;
  final String imageUrl;
}

class Order {
  const Order({
    required this.id,
    required this.items,
    required this.status,
    required this.totalAmount,
    required this.placedAt,
    this.voucherCode,
    this.discount = 0.0,
    required this.paymentMethod,
    this.rating,
    this.feedback,
  });
  final String id;
  final List<OrderItem> items;
  final OrderStatus status;
  final double totalAmount;
  final DateTime placedAt;
  final String? voucherCode;
  final double discount;
  final String paymentMethod;
  final int? rating;
  final String? feedback;
}
