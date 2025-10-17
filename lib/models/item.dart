import 'package:flutter/material.dart';

class Item {
  const Item({
    required this.id,
    required this.categoryType,
    required this.shopName,
    required this.availableStock,
    required this.price,
  });

  final String id;
  final String categoryType; // e.g., 'Grocery', 'Bakery'
  final String shopName; // e.g., 'FreshMart Grocery'
  final int availableStock; // e.g., 50
  final double price; // e.g., 20.0
}
