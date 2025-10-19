import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shopconnect/screens/shoppartnerauth.dart';

class Product {
  String id;
  String productName;
  int quantity;
  String unit;
  double sellingPrice;
  double purchasePrice;
  File? imageFile;

  Product({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.unit,
    required this.sellingPrice,
    required this.purchasePrice,
    this.imageFile,
  });

  double get profit => sellingPrice - purchasePrice;
  double get profitPercent => (profit / purchasePrice) * 100;
}

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  File? _imageFile;
  final picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _purchasePriceController =
      TextEditingController();

  List<Product> _products = [];

  Future<void> _pickImage() async {
    var status = await Permission.photos.status;
    if (!status.isGranted) {
      status = await Permission.photos.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo permission denied!')),
        );
        return;
      }
    }
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  void _showAddEditForm(BuildContext context, [Product? product]) {
    bool isEdit = product != null;

    if (isEdit) {
      _nameController.text = product.productName;
      _quantityController.text = product.quantity.toString();
      _priceController.text = product.sellingPrice.toString();
      _purchasePriceController.text = product.purchasePrice.toString();
      _unitController.text = product.unit;
      _imageFile = product.imageFile;
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: title + close icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isEdit ? 'Edit Item' : 'Add New Item',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7B2CFF),
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.close,
                          color: Colors.grey,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Product Name
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Image picker row
                  Row(
                    children: [
                      _imageFile != null
                          ? Image.file(
                              _imageFile!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              Icons.image_outlined,
                              size: 60,
                              color: Colors.grey,
                            ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.upload),
                        label: const Text('Choose Image'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7B2CFF),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Quantity
                  TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Selling Price
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Selling Price',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Purchase Price
                  TextField(
                    controller: _purchasePriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Purchase Price',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Unit
                  TextField(
                    controller: _unitController,
                    decoration: const InputDecoration(
                      labelText: 'Unit (e.g. kg, pcs)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Save/Update button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_nameController.text.isEmpty ||
                            _quantityController.text.isEmpty ||
                            _priceController.text.isEmpty ||
                            _unitController.text.isEmpty ||
                            _purchasePriceController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all fields!'),
                            ),
                          );
                          return;
                        }

                        setState(() {
                          if (isEdit) {
                            product!.productName = _nameController.text;
                            product.quantity = int.parse(
                              _quantityController.text,
                            );
                            product.unit = _unitController.text;
                            product.sellingPrice = double.parse(
                              _priceController.text,
                            );
                            product.purchasePrice = double.parse(
                              _purchasePriceController.text,
                            );
                            product.imageFile = _imageFile;
                          } else {
                            _products.add(
                              Product(
                                id: DateTime.now().toString(),
                                productName: _nameController.text,
                                quantity: int.parse(_quantityController.text),
                                unit: _unitController.text,
                                sellingPrice: double.parse(
                                  _priceController.text,
                                ),
                                purchasePrice: double.parse(
                                  _purchasePriceController.text,
                                ),
                                imageFile: _imageFile,
                              ),
                            );
                          }
                          _nameController.clear();
                          _quantityController.clear();
                          _priceController.clear();
                          _unitController.clear();
                          _purchasePriceController.clear();
                          _imageFile = null;
                        });

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B2CFF),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        isEdit ? 'Update Item' : 'Save Item',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _deleteItem(String id) {
    setState(() {
      _products.removeWhere((prod) => prod.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF7B2CFF),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Items Management',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Products: ${_products.length} items',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ShopPartnerAuthScreen(),
              ),
            );
          },
        ),
        actions: [
          TextButton.icon(
            onPressed: () => _showAddEditForm(context),
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Add Item',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
      body: _products.isEmpty
          ? const Center(
              child: Text('No Items Added Yet', style: TextStyle(fontSize: 18)),
            )
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (ctx, index) {
                final product = _products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        product.imageFile != null
                            ? Image.file(
                                product.imageFile!,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image, size: 40),
                              ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.productName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Selling Price: ₹${product.sellingPrice}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              const SizedBox(height: 5),
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
                                  '${product.quantity} ${product.unit}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Purchase: ₹${product.purchasePrice}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Profit Margin: ₹${product.profit.toStringAsFixed(0)} (${product.profitPercent.toStringAsFixed(0)}%)',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: () =>
                                        _showAddEditForm(context, product),
                                    icon: const Icon(Icons.edit, size: 18),
                                    label: const Text('Edit'),
                                  ),
                                  const SizedBox(width: 10),
                                  OutlinedButton.icon(
                                    onPressed: () => _deleteItem(product.id),
                                    icon: const Icon(
                                      Icons.delete,
                                      size: 18,
                                      color: Colors.red,
                                    ),
                                    label: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
