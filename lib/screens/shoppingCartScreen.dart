import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopconnect/provider/cartProvider.dart';
import 'package:shopconnect/screens/customerHomeScreen.dart';
//import 'package:shopconnect/screens/home_screen.dart';
import 'package:shopconnect/screens/orderStatusScreen.dart'; //  Order Status import

class ShoppingCartScreen extends StatelessWidget {
  static const routeName = '/shopping-cart';
  const ShoppingCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    const deliveryCharge = 20;

    double subtotal = 0;
    cart.items.forEach((item, qty) {
      subtotal += item.price * qty;
    });

    final total = subtotal + deliveryCharge;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: const Color(0xFF0D5BFF),
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Your cart is empty!',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        // Browse items navigate
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CustomerHomeScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D5BFF),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Browse Items',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: cart.items.entries.map((entry) {
                      final item = entry.key;
                      final qty = entry.value;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Item name & quantity
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
                                    Text('₹${item.price} x $qty'),
                                  ],
                                ),
                              ),
                              // Delete icon
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  cart.removeItem(item);
                                },
                              ),
                              // Total price for this item
                              Text(
                                '₹${item.price * qty}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // Subtotal & Delivery Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: const Border(
                      top: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Subtotal',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '₹$subtotal',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Delivery', style: TextStyle(fontSize: 16)),
                          Text('₹20', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      const Divider(height: 20, thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '₹$total',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ✅ Place Order Button (with Order Data)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // 🟢 Create order data from cart
                            final orderItems = cart.items.entries.map((entry) {
                              final item = entry.key;
                              final qty = entry.value;
                              return {
                                'name': item.id,
                                'quantity': qty,
                                'price': item.price * qty,
                                'image':
                                    'https://via.placeholder.com/60', // dummy image
                              };
                            }).toList();

                            final totalAmount = subtotal + deliveryCharge;

                            // 🟢 Navigate with data to Order Status screen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OrderStatusScreen(
                                  hasOrder: true,
                                  orderItems: orderItems,
                                  totalAmount: totalAmount,
                                ),
                              ),
                            );

                            // ✅ Clear cart after placing order
                            cart.clearCart();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D5BFF),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Place Order',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
