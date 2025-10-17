import 'package:flutter/material.dart';
import 'package:shopconnect/data/dummy_data.dart';
import 'package:shopconnect/models/shop.dart';
import 'package:shopconnect/screens/shopsItemsScreen.dart'; // ShopItemsScreen

class CategoryShopsScreen extends StatelessWidget {
  final String categoryTitle;

  const CategoryShopsScreen({super.key, required this.categoryTitle});

  @override
  Widget build(BuildContext context) {
    final List<Shop> categoryShops = dummyShops
        .where((shop) => shop.categoryType == categoryTitle)
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D5BFF),
        title: Text(categoryTitle, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: categoryShops.isEmpty
          ? const Center(
              child: Text(
                'No shops found in this category!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categoryShops.length,
              itemBuilder: (context, index) {
                final shop = categoryShops[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF0D5BFF),
                      child: const Icon(Icons.storefront, color: Colors.white),
                    ),
                    title: Text(
                      shop.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      '⭐ ${shop.rating}  |  ${shop.distance} km away',
                    ),
                    trailing: shop.isPremium
                        ? const Icon(Icons.verified, color: Colors.blue)
                        : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ShopItemsScreen(
                            shopName: shop.name,
                            shopRating: shop.rating,
                            shopDistance: shop.distance,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
