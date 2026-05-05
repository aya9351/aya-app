import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shop_provider.dart';
import 'screens.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ShopProvider(),
      child: const SmartStoreApp(),
    ),
  );
}

class SmartStoreApp extends StatelessWidget {
  const SmartStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Store',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        primarySwatch: Colors.teal,
        fontFamily: 'Tajawal',
        useMaterial3: true,
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const CategoriesScreen(),
    const FavoritesScreen(),
    const CartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final shop = Provider.of<ShopProvider>(context);

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.teal.shade700,
        unselectedItemColor: Colors.grey.shade500,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view_rounded),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              label: Text(shop.favoriteCount.toString()),
              isLabelVisible: shop.favoriteCount > 0,
              backgroundColor: Colors.red,
              child: const Icon(Icons.favorite_outline_rounded),
            ),
            activeIcon: Badge(
              label: Text(shop.favoriteCount.toString()),
              isLabelVisible: shop.favoriteCount > 0,
              backgroundColor: Colors.red,
              child: const Icon(Icons.favorite_rounded),
            ),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              label: Text(shop.cartCount.toString()),
              isLabelVisible: shop.cartCount > 0,
              backgroundColor: Colors.teal,
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            activeIcon: Badge(
              label: Text(shop.cartCount.toString()),
              isLabelVisible: shop.cartCount > 0,
              backgroundColor: Colors.teal,
              child: const Icon(Icons.shopping_bag_rounded),
            ),
            label: 'Cart',
          ),
        ],
      ),
    );
  }
}