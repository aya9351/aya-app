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
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product))),
              child: Image.asset(product.image, fit: BoxFit.cover),
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
                        Text(product.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12), maxLines: 1),
                        Text("\$${product.price}", style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
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
                backgroundColor: Colors.white.withOpacity(0.4),
                radius: 18,
                child: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final shop = Provider.of<ShopProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Text("Discover Products", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(15),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.8, crossAxisSpacing: 15, mainAxisSpacing: 15
                ),
                itemCount: shop.products.length,
                itemBuilder: (ctx, i) => ProductCard(product: shop.products[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Provider.of<ShopProvider>(context);
    final List<Map<String, dynamic>> categoryData = [
      {'name': 'Kitchen', 'icon': Icons.kitchen_rounded},
      {'name': 'Smart Devices', 'icon': Icons.devices_other_rounded},
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Categories", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              Expanded(
                child: ListView.builder(
                  itemCount: categoryData.length,
                  itemBuilder: (ctx, i) => GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                      builder: (_) => CategoryProductsScreen(categoryName: categoryData[i]['name'])
                    )),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 25),
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15)],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(categoryData[i]['icon'], size: 50, color: Colors.teal),
                          const SizedBox(height: 15),
                          Text(categoryData[i]['name'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Image.asset(product.image, fit: BoxFit.cover, width: double.infinity),
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Text("\$${product.price}", style: const TextStyle(fontSize: 22, color: Colors.teal, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(product.description, style: const TextStyle(color: Colors.grey, fontSize: 16, height: 1.5)),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF5F5DC),
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 0,
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

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final shop = Provider.of<ShopProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(20), child: Text("Your Cart", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold))),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: shop.cart.length,
                itemBuilder: (ctx, i) {
                  final item = shop.cart[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: item))),
                      leading: ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset(item.image, width: 60, height: 60, fit: BoxFit.cover)),
                      title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("\$${item.price}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => shop.updateQuantity(item, false)),
                          Text("${item.quantity}"),
                          IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => shop.updateQuantity(item, true)),
                          IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => shop.removeFromCart(item)),
                          ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Text("Total: \$${shop.totalCartPrice.toStringAsFixed(2)}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
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
      body: SafeArea(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(20), child: Text("Favorites", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold))),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: favs.length,
                itemBuilder: (ctx, i) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: favs[i]))),
                    leading: ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset(favs[i].image, width: 60, height: 60, fit: BoxFit.cover)),
                    title: Text(favs[i].name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: IconButton(icon: const Icon(Icons.favorite, color: Colors.red), onPressed: () => Provider.of<ShopProvider>(context, listen: false).toggleFavorite(favs[i])),
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
class CategoryProductsScreen extends StatelessWidget {
  final String categoryName;
  const CategoryProductsScreen({required this.categoryName, super.key});
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ShopProvider>(context).products.where((p) => p.category == categoryName).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName), 
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        foregroundColor: Colors.black,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.8, crossAxisSpacing: 15, mainAxisSpacing: 15),
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
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      });

      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5DC),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outline, color: Colors.black, size: 40),
              SizedBox(height: 15),
              Text(
                "Added to Cart",
                style: TextStyle(
                  color: Colors.black, 
                  fontWeight: FontWeight.bold, 
                  fontSize: 18
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}