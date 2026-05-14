import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shop_provider.dart';
import 'screens.dart';

void main() async {
  // التأكد من تهيئة الخدمات قبل تشغيل التطبيق
  WidgetsFlutterBinding.ensureInitialized();
  
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
      title: 'Smart Store Pro',
      theme: ThemeData(
        useMaterial3: true,
        // ألوان متناسقة وهادئة
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          primary: Colors.teal.shade700,
          secondary: Colors.orangeAccent,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        fontFamily: 'Tajawal', // تأكد من إضافة الخط في pubspec.yaml
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black, 
            fontSize: 20, 
            fontWeight: FontWeight.bold
          ),
        ),
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

  // القائمة الأساسية للشاشات
  final List<Widget> _pages = [
    const HomeScreen(),
    const CategoriesScreen(),
    const FavoritesScreen(),
    const CartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // استدعاء الموفر لمراقبة عدد العناصر في السلة والمفضلة لتحديث الـ Badges
    final shop = Provider.of<ShopProvider>(context);

    return Scaffold(
      body: IndexedStack( // استخدام IndexedStack للحفاظ على حالة الشاشات أثناء التنقل
        index: _currentIndex,
        children: _pages,
      ),
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
        backgroundColor: Colors.white,
        elevation: 10,
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