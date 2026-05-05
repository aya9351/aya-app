import 'package:flutter/material.dart';
import 'product_model.dart';

class ShopProvider with ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: '1', 
      name: 'Smart Electric Kettle', 
      price: 150.0, 
      image: 'assets/2.jpg', 
      category: 'Kitchen', 
      description: 'High-quality smart kettle with temperature control and rapid boil technology.'
    ),
    Product(
      id: '2', 
      name: 'Smart Control Hub', 
      price: 310.0, 
      image: 'assets/4.jpg', 
      category: 'Smart Devices', 
      description: 'A central hub to control all your smart home appliances with one touch.'
    ),
    Product(
      id: '3', 
      name: 'Minimalist Desk Clock', 
      price: 280.0, 
      image: 'assets/5.jpg', 
      category: 'Smart Devices', 
      description: 'Sleek smart clock that displays time, date, and room temperature.'
    ),
    Product(
      id: '4', 
      name: 'Coffee Brewing Set', 
      price: 550.0, 
      image: 'assets/6.jpg', 
      category: 'Kitchen', 
      description: 'Professional set for coffee lovers, combining style and functionality.'
    ),
    Product(
      id: '5', 
      name: 'Emerald Luxury Kettle', 
      price: 395.0, 
      image: 'assets/7.jpg', 
      category: 'Kitchen', 
      description: 'Elegant emerald green kettle with a premium wooden handle design.'
    ),
    Product(
      id: '6', 
      name: 'Pop-up Power Socket', 
      price: 220.0, 
      image: 'assets/8.jpg', 
      category: 'Kitchen', 
      description: 'Hidden pop-up outlet with multiple AC sockets and USB charging ports.'
    ),
    Product(
      id: '7', 
      name: 'Compact Air Fryer', 
      price: 480.0, 
      image: 'assets/9.jpg', 
      category: 'Kitchen', 
      description: 'Healthy cooking made easy with this compact and powerful air fryer.'
    ),
    Product(
      id: '8', 
      name: 'Espresso Station', 
      price: 1250.0, 
      image: 'assets/11.jpg', 
      category: 'Kitchen', 
      description: 'Complete professional espresso machine for the perfect morning coffee.'
    ),
    Product(
      id: '9', 
      name: 'Bedside Smart Lamp', 
      price: 260.0, 
      image: 'assets/13.jpg', 
      category: 'Smart Devices', 
      description: 'Multifunctional bedside lamp with wireless charging and alarm clock.'
    ),
  ];

  final List<Product> _cart = [];

  List<Product> get products => _products;
  List<Product> get cart => _cart;
  List<Product> get favorites => _products.where((p) => p.isFavorite).toList();
  
  List<String> get categories => ['Kitchen', 'Smart Devices'];

  int get cartCount => _cart.length; 
  int get favoriteCount => favorites.length;

  double get totalCartPrice => _cart.fold(0, (sum, item) => sum + (item.price * item.quantity));

  void toggleFavorite(Product p) {
    p.isFavorite = !p.isFavorite;
    notifyListeners();
  }

  void addToCart(Product p) {
    if (!_cart.any((item) => item.id == p.id)) {
      p.quantity = 1;
      _cart.add(p);
    } else {
      p.quantity++;
    }
    notifyListeners();
  }

  void removeFromCart(Product p) {
    _cart.removeWhere((item) => item.id == p.id);
    p.quantity = 1;
    notifyListeners();
  }
  void updateQuantity(Product p, bool increment) {
    if (increment) {
      p.quantity++;
    } else {
      if (p.quantity > 1) {
        p.quantity--;
      } else {
        removeFromCart(p);
      }
    }
    notifyListeners();
  }
}