import 'package:flutter/material.dart';
import 'package:shopconnect/data/dummy_data.dart';
import 'package:shopconnect/models/shop.dart';
import 'package:shopconnect/screens/shopsItemsScreen.dart'; // ShopItemsScreen

class CategoryShopsScreen extends StatefulWidget {
  final String categoryTitle;

  const CategoryShopsScreen({super.key, required this.categoryTitle});

  @override
  State<CategoryShopsScreen> createState() => _CategoryShopsScreenState();
}

class _CategoryShopsScreenState extends State<CategoryShopsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String query = '';

  @override
  Widget build(BuildContext context) {
    final List<Shop> categoryShops = dummyShops
        .where((shop) => shop.categoryType == widget.categoryTitle)
        .toList();

    // Filtered shops based on search query
    final filteredShops = categoryShops
        .where(
          (shop) =>
              shop.name.toLowerCase().contains(query.toLowerCase()) ||
              shop.categoryType.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D5BFF),
        title: Text(
          widget.categoryTitle,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search shops...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (value) {
                  setState(() {
                    query = value;
                  });
                },
              ),
            ),
          ),
        ),
      ),
      body: filteredShops.isEmpty
          ? const Center(
              child: Text(
                'No matching shops found!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredShops.length,
              itemBuilder: (context, index) {
                final shop = filteredShops[index];
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
                      // Navigate to ShopItemsScreen
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
