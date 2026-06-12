import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'product_model.dart';

class ShopProvider with ChangeNotifier {
  List<Product> _products = [];
  final List<Product> _cart = [];
  bool _isLoading = false;
  String _errorMessage = "";

  List<Product> get products => _products;
  List<Product> get cart => _cart;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<Product> get favorites => _products.where((p) => p.isFavorite).toList();
  
  int get cartCount => _cart.length;
  int get favoriteCount => favorites.length;
  double get totalCartPrice => _cart.fold(0, (sum, item) => sum + (item.price * item.quantity));

  Future<void> fetchProducts() async {
    if (_products.isNotEmpty) return;

    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    await _loadCartFromPrefs();

    try {
      final response = await http.get(Uri.parse("https://fakestoreapi.com/products"));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        _products = data.map((item) => Product.fromJson(item)).toList();
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('cached_products_json', response.body);
        
        await _loadFavoritesFromPrefs();
        _errorMessage = "";
      } else {
        await _loadFromCache();
      }
    } catch (e) {
      await _loadFromCache();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? cachedData = prefs.getString('cached_products_json');
      
      if (cachedData != null) {
        List<dynamic> data = json.decode(cachedData);
        _products = data.map((item) => Product.fromJson(item)).toList();
        await _loadFavoritesFromPrefs();
        _errorMessage = "Offline Mode: Active";
      } else {
        _errorMessage = "No internet and no cached data.";
      }
    } catch (e) {
      _errorMessage = "Error loading offline data.";
    }
  }

  Future<void> _saveFavoritesToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favIds = favorites.map((p) => p.id).toList();
    await prefs.setStringList('favorite_ids', favIds);
  }

  Future<void> _loadFavoritesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? favIds = prefs.getStringList('favorite_ids');
    
    if (favIds != null) {
      for (var product in _products) {
        if (favIds.contains(product.id)) {
          product.isFavorite = true;
        }
      }
    }
    notifyListeners();
  }

  void toggleFavorite(Product p) {
    p.isFavorite = !p.isFavorite;
    _saveFavoritesToPrefs();
    notifyListeners();
  }


  Future<void> _saveCartToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
  
    List<String> cartJsonList = _cart.map((item) => json.encode({
      'id': item.id,
      'title': item.name,
      'price': item.price,
      'image': item.image,
      'category': item.category,
      'description': item.description,
      'quantity': item.quantity,
    })).toList();
    await prefs.setStringList('cached_cart_list', cartJsonList);
  }
Future<void> _loadCartFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? cartJsonList = prefs.getStringList('cached_cart_list');
    
    if (cartJsonList != null) {
      _cart.clear();
      for (var itemStr in cartJsonList) {
        Map<String, dynamic> itemData = json.decode(itemStr);
        Product p = Product.fromJson(itemData);
        p.quantity = itemData['quantity'] ?? 1;
        _cart.add(p);
      }
      notifyListeners();
    }
  }

  void addToCart(Product p) {
    if (!_cart.any((item) => item.id == p.id)) {
      p.quantity = 1;
      _cart.add(p);
    } else {
      _cart.firstWhere((item) => item.id == p.id).quantity++;
    }
    _saveCartToPrefs();
    notifyListeners();
  }

  void removeFromCart(Product p) {
    _cart.removeWhere((item) => item.id == p.id);
    _saveCartToPrefs();
    notifyListeners();
  }

  void updateQuantity(Product p, bool increment) {
    if (increment) {
      p.quantity++;
    } else {
      if (p.quantity > 1) {
        p.quantity--;
      } else {
        _cart.removeWhere((item) => item.id == p.id);
      }
    }
    _saveCartToPrefs();
    notifyListeners();
  }
}  