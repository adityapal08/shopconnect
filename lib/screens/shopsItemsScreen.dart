import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final List<Item> shopItems = dummyItems
        .where((item) => item.shopName == widget.shopName)
        .toList();

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
          IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () {}),
        ],
      ),
      body: shopItems.isEmpty
          ? const Center(
              child: Text(
                'No items found in this shop!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: shopItems.length,
              itemBuilder: (context, index) {
                final Item item = shopItems[index];
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
                                color: Colors.grey[200], // placeholder color
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
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${quantities[item.id]} x ${item.id} added to cart',
                                    ),
                                  ),
                                );
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
