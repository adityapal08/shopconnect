import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shopconnect/provider/cartProvider.dart';
import 'package:shopconnect/screens/shoppingCartScreen.dart';
import '../data/dummy_data.dart';
import '../models/item.dart';

class ShopItemsScreen extends StatefulWidget {
  final String shopName;
  final double shopRating;
  final double shopDistance;

  const ShopItemsScreen({
    super.key,
    required this.shopName,
    required this.shopRating,
    required this.shopDistance,
  });

  @override
  State<ShopItemsScreen> createState() => _ShopItemsScreenState();
}

class _ShopItemsScreenState extends State<ShopItemsScreen> {
  final Map<String, int> quantities = {};
  final TextEditingController _searchController = TextEditingController();
  String query = '';

  @override
  Widget build(BuildContext context) {
    final List<Item> shopItems = dummyItems
        .where((item) => item.shopName == widget.shopName)
        .toList();

    final filteredItems = shopItems
        .where(
          (item) =>
              item.id.toLowerCase().contains(query.toLowerCase()) ||
              item.shopName.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D5BFF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.shopName, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 4),
            Text(
              '⭐ ${widget.shopRating}  |  ${widget.shopDistance} km away',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, ShoppingCartScreen.routeName);
                },
              ),
              if (cart.totalItems > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cart.totalItems}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
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
                  hintText: 'Search items...',
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
      body: filteredItems.isEmpty
          ? const Center(
              child: Text(
                'No matching items found!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final Item item = filteredItems[index];
                quantities[item.id] ??= 0;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Left: Image + Quantity controls
                        Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[200],
                              ),
                              child: const Icon(Icons.image, size: 36),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (quantities[item.id]! > 0) {
                                        quantities[item.id] =
                                            quantities[item.id]! - 1;
                                      }
                                    });
                                  },
                                ),
                                Text('${quantities[item.id]}'),
                                IconButton(
                                  icon: const Icon(
                                    Icons.add_circle,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (quantities[item.id]! <
                                          item.availableStock) {
                                        quantities[item.id] =
                                            quantities[item.id]! + 1;
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        // Middle: Item name, price
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.id,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text('₹${item.price} / kg'),
                            ],
                          ),
                        ),
                        // Right: Stock badge + Add to Cart button
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${item.availableStock} in stock',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                cart.addItem(item, quantities[item.id]!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${quantities[item.id]} x ${item.id} added to cart',
                                    ),
                                  ),
                                );
                                setState(() {
                                  quantities[item.id] = 0;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0D5BFF),
                              ),
                              child: const Text('Add to Cart'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
