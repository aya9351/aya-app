class Product {
  final String id, name, image, description, category;
  final double price;
  bool isFavorite;
  int quantity;

  Product({
    required this.id, required this.name, required this.price,
    required this.image, required this.description, required this.category,
    this.isFavorite = false, this.quantity = 1,
  });
}