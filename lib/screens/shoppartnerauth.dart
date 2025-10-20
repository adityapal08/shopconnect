import 'package:flutter/material.dart';
import 'package:shopconnect/shoppartnerscreens/dashboardScreen.dart';
// ✅ Import your dashboard screen

class ShopPartnerAuthScreen extends StatefulWidget {
  const ShopPartnerAuthScreen({super.key});

  @override
  State<ShopPartnerAuthScreen> createState() => _ShopPartnerAuthScreenState();
}

class _ShopPartnerAuthScreenState extends State<ShopPartnerAuthScreen> {
  bool isLogin = true;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();

  final List<String> states = const [
    'Select',
    'Maharashtra',
    'Karnataka',
    'Gujarat',
  ];
  final Map<String, List<String>> stateToDistricts = const {
    'Select': ['Select'],
    'Maharashtra': ['Select', 'Mumbai', 'Pune', 'Nagpur'],
    'Karnataka': ['Select', 'Bengaluru', 'Mysuru'],
    'Gujarat': ['Select', 'Ahmedabad', 'Surat'],
  };
  String selectedState = 'Select';
  String selectedDistrict = 'Select';

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    ownerNameController.dispose();
    shopNameController.dispose();
    pincodeController.dispose();
    super.dispose();
  }

  void _handleAuth() {
    if (phoneController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all required fields')),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: screenHeight, // ✅ Full screen height
        width: double.infinity, // ✅ Full screen width
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF7B2CFF), Color(0xFFFF1662)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Column(
                    children: const [
                      SizedBox(height: 8),
                      Icon(
                        Icons.store_mall_directory,
                        size: 48,
                        color: Colors.white,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Partner Portal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Manage your shop with ease',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildTabSwitcher(),
                const SizedBox(height: 16),
                _buildAuthCard(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _buildTabButton(
            'Login',
            isLogin,
            () => setState(() => isLogin = true),
          ),
          _buildTabButton(
            'Sign Up',
            !isLogin,
            () => setState(() => isLogin = false),
          ),
        ],
      ),
    );
  }

  Expanded _buildTabButton(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: active ? Colors.black87 : Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Phone Number',
            style: TextStyle(fontSize: 12, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          _textField(
            controller: phoneController,
            hintText: '+91 9876543210',
            keyboardType: TextInputType.phone,
          ),
          if (!isLogin) ...[
            const SizedBox(height: 12),
            const Text(
              'Your Name',
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
            const SizedBox(height: 6),
            _textField(
              controller: ownerNameController,
              hintText: 'John Doe',
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 12),
            const Text(
              'Shop Name',
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
            const SizedBox(height: 6),
            _textField(
              controller: shopNameController,
              hintText: 'My Shop',
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'State',
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                      const SizedBox(height: 6),
                      _dropdown(
                        value: selectedState,
                        items: states,
                        onChanged: (val) {
                          if (val == null) return;
                          setState(() {
                            selectedState = val;
                            selectedDistrict = stateToDistricts[val]!.first;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'District',
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                      const SizedBox(height: 6),
                      _dropdown(
                        value: selectedDistrict,
                        items: stateToDistricts[selectedState] ?? ['Select'],
                        onChanged: (val) {
                          if (val == null) return;
                          setState(() => selectedDistrict = val);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Pincode',
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
            const SizedBox(height: 6),
            _textField(
              controller: pincodeController,
              hintText: '400001',
              keyboardType: TextInputType.number,
            ),
          ],
          const SizedBox(height: 12),
          const Text(
            'Password',
            style: TextStyle(fontSize: 12, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          _textField(
            controller: passwordController,
            hintText: 'Enter your password',
            obscureText: true,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: const Color(0xFF6A00FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _handleAuth,
              child: Text(isLogin ? 'Login' : 'Sign Up'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool obscureText = false,
    required String hintText,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF3F3F6),
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _dropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items
          .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF3F3F6),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.black87),
      dropdownColor: Colors.white,
    );
  }
}
