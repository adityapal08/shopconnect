import 'package:flutter/material.dart';
import 'dashboardScreen.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String selectedPeriod = "Today";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive AppBar height
    final appBarHeight = screenWidth < 400 ? 220.0 : 200.0;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF80AB), Color(0xFF9C27B0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Header Row ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DashboardScreen(),
                              ),
                            );
                          },
                        ),
                        Expanded(
                          child: Text(
                            "Sales Analytics",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // === Period Button (White background, active look) ===
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            setState(() {
                              selectedPeriod = value;
                            });
                          },
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: "Today",
                              child: Text("Today"),
                            ),
                            const PopupMenuItem(
                              value: "This Week",
                              child: Text("This Week"),
                            ),
                            const PopupMenuItem(
                              value: "This Month",
                              child: Text("This Month"),
                            ),
                            const PopupMenuItem(
                              value: "This Year",
                              child: Text("This Year"),
                            ),
                          ],
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  selectedPeriod,
                                  style: const TextStyle(
                                    color: Colors.pink,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.pink,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // --- Two Info Boxes ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _buildInfoBox(
                            title: "Today's Revenue",
                            value: "₹12.6k",
                            growth: "+18% vs last week",
                            icon: Icons.trending_up,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildInfoBox(
                            title: "Today's Orders",
                            value: "124",
                            growth: "+12% vs last week",
                            icon: Icons.shopping_cart,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      // === Body ===
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    icon: Icons.people,
                    title: "Customers",
                    value: "87",
                    subtitle: "23 new this week",
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _statCard(
                    icon: Icons.inventory,
                    title: "Avg Order",
                    value: "₹345",
                    subtitle: "+45 from last week",
                  ),
                ),
              ],
            ),
            _dailySalesContainer(screenWidth),
            _topProductsContainer(),
            _customerAnalysisContainer(),
            _customerInsightsContainer(),
          ],
        ),
      ),
    );
  }

  // ====================== Widget Builders ======================

  Widget _buildInfoBox({
    required String title,
    required String value,
    required String growth,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.trending_up, color: Colors.green, size: 14),
              const SizedBox(width: 4),
              Text(
                growth,
                style: const TextStyle(color: Colors.greenAccent, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.purple, size: 20),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _dailySalesContainer(double screenWidth) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Daily Sales",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          const SizedBox(height: 12),
          ...["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"].map((day) {
            int orders = 15;
            double progress = orders / 30;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: Text(
                      day,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          height: 18,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[300],
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: progress,
                          child: Container(
                            height: 18,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF80AB), Color(0xFF9C27B0)],
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Center(
                            child: Text(
                              "$orders orders",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "₹345",
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _topProductsContainer() {
    final products = [
      {"name": "Product A", "units": 25, "price": 1200},
      {"name": "Product B", "units": 18, "price": 900},
      {"name": "Product C", "units": 12, "price": 600},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Top Selling Products",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          const SizedBox(height: 12),
          ...products.asMap().entries.map((entry) {
            int index = entry.key;
            var product = entry.value;
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.purple,
                    child: Text(
                      "${index + 1}",
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product["name"].toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "${product["units"]} units sold",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "₹${product["price"]}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _customerAnalysisContainer() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Customer Analysis",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _analysisBox(
            "Total Revenue",
            "₹12,600",
            gradient: const LinearGradient(
              colors: [Color(0xFF66BB6A), Color(0xFF2E7D32)],
            ),
          ),
          _analysisBox("Purchase Cost", "₹7,800", color: Colors.orange),
          _analysisBox("Platform Fee (5%)", "₹630", color: Colors.blue),
          _analysisBox(
            "Net Profit",
            "₹4,170",
            gradient: const LinearGradient(
              colors: [Color(0xFFFF80AB), Color(0xFF9C27B0)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _analysisBox(
    String title,
    String value, {
    Color? color,
    LinearGradient? gradient,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: color,
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _customerInsightsContainer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Customer Insights",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _insightLine("Repeat Customers", 0.75, Colors.green, "75%"),
          _insightLine("Satisfaction", 0.96, Colors.blue, "4.8/5.0"),
          _insightLine("Completion Rate", 0.92, Colors.purple, "92%"),
        ],
      ),
    );
  }

  Widget _insightLine(
    String label,
    double progress,
    Color color,
    String rightText,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: const TextStyle(fontSize: 14)),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: progress,
              color: color,
              backgroundColor: color.withOpacity(0.3),
              minHeight: 10,
            ),
          ),
          const SizedBox(width: 8),
          Text(rightText, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
