import 'package:flutter/material.dart';
import '../models/item.dart';

class CartProvider extends ChangeNotifier {
  final Map<Item, int> _items = {};

  Map<Item, int> get items => _items;

  int get totalItems => _items.values.fold(0, (sum, qty) => sum + qty);

  void addItem(Item item, int quantity) {
    if (quantity <= 0) return;

    if (_items.containsKey(item)) {
      _items[item] = _items[item]! + quantity;
    } else {
      _items[item] = quantity;
    }
    notifyListeners();
  }

  void removeItem(Item item) {
    _items.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
