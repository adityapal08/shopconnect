import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopconnect/provider/cartProvider.dart';
import 'package:shopconnect/screens/shoppingCartScreen.dart';
import 'package:shopconnect/screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => CartProvider(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopConnect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      routes: {ShoppingCartScreen.routeName: (_) => const ShoppingCartScreen()},
    );
  }
}
