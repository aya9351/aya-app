import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shop_provider.dart';
import 'screens.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_screen.dart';
import 'profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyABsTi8aNfRQUA_dnjUZKfjsLSfVKbHvTI",
        authDomain: "smart-home-897a8.firebaseapp.com",
        projectId: "smart-home-897a8",
        storageBucket: "smart-home-897a8.firebasestorage.app",
        messagingSenderId: "171257968552",
        appId: "1:171257968552:web:dd6acd9b297c6c9d9ecf9d",
        measurementId: "G-8CH8MLK625",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          primary: Colors.teal.shade700,
          secondary: Colors.orangeAccent,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        fontFamily: 'Tajawal',
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Colors.teal),
              ),
            );
          }
          if (snapshot.hasData) {
            return const MainNavigation();
          }
          return AuthScreen();
        },
      ),
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
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final shop = Provider.of<ShopProvider>(context);

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
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
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
