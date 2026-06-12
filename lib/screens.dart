import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_model.dart';
import 'shop_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    final shop = Provider.of<ShopProvider>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Positioned.fill(
            child: InkWell(
              onTap: () => Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product))
              ),
              child: Image.network(
                product.image, 
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50),
              ),
            ),
          ),

          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name, 
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12), 
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text("\$${product.price}", 
                          style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      shop.addToCart(product);
                      showSuccessDialog(context);
                    }, 
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                      child: const Icon(Icons.add_shopping_cart, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10, left: 10,
            child: GestureDetector(
              onTap: () => shop.toggleFavorite(product),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.7),
                radius: 18,
                child: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border, 
                  color: Colors.red, size: 20
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ShopProvider>(context, listen: false).fetchProducts());
  }
  @override
  Widget build(BuildContext context) {
    final shop = Provider.of<ShopProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: shop.isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.teal))
                : GridView.builder(
                    padding: const EdgeInsets.all(15),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15),
                    itemCount: shop.products.length,
                    itemBuilder: (ctx, i) => ProductCard(product: shop.products[i]),
                  ),
          ),
        ],
      ),
    );
  }
}
class ProductDetailsScreen extends StatelessWidget {
  final Product product;
  const ProductDetailsScreen({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    final shop = Provider.of<ShopProvider>(context, listen: false);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.only(top: 50),
              child: Image.network(
                product.image, 
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name, 
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          maxLines: 2,
                        ),
                      ),
                      Text(
                        "\$${product.price}", 
                        style: const TextStyle(fontSize: 22, color: Colors.teal, fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.category.toUpperCase(),
                    style: TextStyle(color: Colors.teal.shade300, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        product.description, 
                        style: const TextStyle(color: Colors.grey, fontSize: 16, height: 1.5)
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                    ),
                    onPressed: () {
                      shop.addToCart(product);
                      showSuccessDialog(context);
                    },
                    child: const Text("Add to Cart", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categoryData = [
      {'name': 'electronics', 'icon': Icons.devices_other_rounded},
      {'name': 'jewelery', 'icon': Icons.diamond_rounded},
      {'name': "men's clothing", 'icon': Icons.checkroom_rounded},
      {'name': "women's clothing", 'icon': Icons.woman_rounded},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Categories")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: categoryData.length,
                itemBuilder: (ctx, i) => GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => CategoryProductsScreen(categoryName: categoryData[i]['name'])
                  )),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 20),
                        CircleAvatar(
                          backgroundColor: Colors.teal.withOpacity(0.1),
                          child: Icon(categoryData[i]['icon'], color: Colors.teal),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          categoryData[i]['name'].toUpperCase(), 
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                        ),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shop = Provider.of<ShopProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart")),
      body: Column(
        children: [
          Expanded(
            child: shop.cart.isEmpty 
              ? const Center(child: Text("Your cart is empty", style: TextStyle(fontSize: 18, color: Colors.grey)))
              : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: shop.cart.length,
              itemBuilder: (ctx, i) {
                final item = shop.cart[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10), 
                      child: Image.network(item.image, width: 50, height: 50, fit: BoxFit.contain)
                    ),
                    title: Text(item.name, maxLines: 1, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("\$${(item.price * item.quantity).toStringAsFixed(2)}", 
                      style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.teal), 
                          onPressed: () => shop.updateQuantity(item, false)
                        ),
                        Text("${item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: Colors.teal), 
                          onPressed: () => shop.updateQuantity(item, true)
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () => shop.removeFromCart(item),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Amount:", style: TextStyle(fontSize: 18, color: Colors.grey)),
                    Text("\$${shop.totalCartPrice.toStringAsFixed(2)}", 
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal)),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 55),
 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: shop.cart.isEmpty ? null : () {
                  },
                  child: const Text("Checkout Now", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favs = Provider.of<ShopProvider>(context).favorites;
    return Scaffold(
      appBar: AppBar(title: const Text("My Favorites")),
      body: favs.isEmpty 
        ? const Center(child: Text("No favorites yet", style: TextStyle(fontSize: 18, color: Colors.grey)))
        : ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: favs.length,
        itemBuilder: (ctx, i) => Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10), 
              child: Image.network(favs[i].image, width: 50, height: 50, fit: BoxFit.contain)
            ),
            title: Text(favs[i].name, maxLines: 1, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("\$${favs[i].price}", style: const TextStyle(color: Colors.teal)),
            trailing: IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red), 
              onPressed: () => Provider.of<ShopProvider>(context, listen: false).toggleFavorite(favs[i])
            ),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: favs[i]))),
          ),
        ),
      ),
    );
  }
}

class CategoryProductsScreen extends StatelessWidget {
  final String categoryName;
  const CategoryProductsScreen({required this.categoryName, super.key});

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ShopProvider>(context).products.where((p) => p.category == categoryName).toList();
    return Scaffold(
      appBar: AppBar(title: Text(categoryName.toUpperCase())),
      body: products.isEmpty 
        ? const Center(child: CircularProgressIndicator())
        : GridView.builder(
        padding: const EdgeInsets.all(15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, 
          childAspectRatio: 0.8, 
          crossAxisSpacing: 15, 
          mainAxisSpacing: 15
        ),
        itemCount: products.length,
        itemBuilder: (ctx, i) => ProductCard(product: products[i]),
      ),
    );
  }
}

void showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (Navigator.canPop(context)) Navigator.pop(context);
      });
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9), 
            borderRadius: BorderRadius.circular(20)
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.teal, size: 60),
              SizedBox(height: 10),
              Text("Added to Cart!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
        ),
      );
    },
  );
}                   