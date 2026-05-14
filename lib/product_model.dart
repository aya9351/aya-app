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

  // تحويل JSON إلى كائن Product مع معالجة البيانات لضمان عدم وجود قيم فارغة (Null Safety)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(), // تحويل الـ ID لنص دائماً لتجنب مشاكل النوع
      name: json['title'] ?? 'No Name', 
      price: (json['price'] as num).toDouble(), // تحويل السعر لـ double بدقة
      image: json['image'] ?? '', 
      category: json['category'] ?? 'General',
      description: json['description'] ?? 'No description available.',
    );
  }

  // دالة اختيارية لتحويل الكائن مجدداً لـ Map إذا احتجت لحفظه مستقبلاً
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