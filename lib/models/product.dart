class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.rating = 4.0,
    this.reviewCount = 0,
  });

  final int id;
  final String name;
  final double price;
  final String imageUrl;
  final String category;
  final double rating;
  final int reviewCount;
}
