import 'package:flutter/material.dart';
import 'package:shopconnect/shoppartnerWidgets/orderNavBar.dart';
import 'package:shopconnect/shoppartnerscreens/shoporders/activeorders.dart';
import 'package:shopconnect/shoppartnerscreens/shoporders/donescreen.dart';
import 'package:shopconnect/shoppartnerscreens/shoporders/pendingorders.dart';
import 'package:shopconnect/shoppartnerscreens/shoporders/readyscreen.dart';

import '../dashboardScreen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int selectedIndex = 0;
  final List<String> tabs = ['Active', 'Pending', 'Ready', 'Done'];

  // List of tab screens
  final List<Widget> tabScreens = const [
    ActiveOrders(),
    PendingOrders(),
    ReadyOrders(),
    DoneOrders(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF5F9E), Color(0xFF7B2CFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          titleSpacing: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DashboardScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Order Management',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 55, top: 0),
                child: Text(
                  '1 pending orders',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ],
          ),
          toolbarHeight: 70,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: Column(
        children: [
          // 🔹 Reusable OrdersNavBar
          OrdersNavBar(
            tabs: tabs,
            selectedIndex: selectedIndex,
            onTabSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),

          // 🔹 Tab content
          Expanded(child: tabScreens[selectedIndex]),
        ],
      ),
    );
  }
}
