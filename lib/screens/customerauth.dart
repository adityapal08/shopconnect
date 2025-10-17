import 'package:flutter/material.dart';
import 'customerHomeScreen.dart';

class CustomerAuthScreen extends StatefulWidget {
  const CustomerAuthScreen({super.key});

  @override
  State<CustomerAuthScreen> createState() => _CustomerAuthScreenState();
}

class _CustomerAuthScreenState extends State<CustomerAuthScreen>
    with SingleTickerProviderStateMixin {
  bool isLogin = true;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
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
    fullNameController.dispose();
    pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3FA3FF), Color(0xFF7B2CFF)],
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
                const SizedBox(height: 24),
                Center(
                  child: Column(
                    children: const [
                      Text(
                        'Welcome Back!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Sign in to start shopping',
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
        color: Colors.white.withOpacity(0.8),
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
          _buildTextField(
            controller: phoneController,
            hintText: '+91 9876543210',
            keyboardType: TextInputType.phone,
          ),
          if (!isLogin) ...[
            const SizedBox(height: 12),
            const Text(
              'Full Name',
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
            const SizedBox(height: 6),
            _buildTextField(
              controller: fullNameController,
              hintText: 'John Doe',
              keyboardType: TextInputType.name,
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
                      _buildDropdown(
                        value: selectedState,
                        items: states,
                        onChanged: (val) {
                          if (val == null) return;
                          setState(() {
                            selectedState = val;
                            final districts =
                                stateToDistricts[val] ?? ['Select'];
                            selectedDistrict = districts.first;
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
                      _buildDropdown(
                        value: selectedDistrict,
                        items:
                            stateToDistricts[selectedState] ?? const ['Select'],
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
            _buildTextField(
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
          _buildTextField(
            controller: passwordController,
            hintText: '',
            obscureText: true,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: const Color(0xFF0D5BFF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const CustomerHomeScreen()),
                  (route) => false,
                );
              },
              child: Text(isLogin ? 'Login' : 'Sign Up'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
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

  Widget _buildDropdown({
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
