import 'package:flutter/material.dart';

class Shop {
  final String id;
  final String name;
  final bool isPremium;
  final String categoryType;
  final double rating;
  final double distance;

  Shop({
    required this.id,
    required this.name,
    required this.isPremium,
    required this.categoryType,
    required this.rating,
    required this.distance,
  });
}
