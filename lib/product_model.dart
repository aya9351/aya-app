class Product {
  final String id;
  final String name;
  final String image;
  final String description;
  final String category;
  final double price;
  bool isFavorite;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
    this.isFavorite = false,
    this.quantity = 1,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['title'] ?? 'No Name',
      price: (json['price'] as num).toDouble(),
      image: json['image'] ?? '',
      category: json['category'] ?? 'General',
      description: json['description'] ?? 'No description available.',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': name,
      'price': price,
      'image': image,
      'category': category,
      'description': description,
    };
  }
}
