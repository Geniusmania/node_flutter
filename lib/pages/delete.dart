import 'package:flutter/material.dart';
import 'package:flutter_shop/utils/services.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {

  final Api _api =Api();
  List<dynamic> _products = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() => _isLoading = true);
    try {
      _products = await _api.getProducts(); // Ensure getProducts() is in services.dart
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(' Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteProduct(String name) async {
    try {
      bool isDeleted = await _api.deleteProduct(name);
      if (isDeleted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(' $name deleted successfully!')),
        );
        _fetchProducts(); // Refresh the list
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(' Failed to delete $name: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product List')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
              ? const Center(child: Text('No products available'))
              : ListView.builder(
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    return ListTile(
                      title: Text(product['name']),
                      subtitle: Text('Category: ${product['category']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteConfirmation(product['name']),
                      ),
                    );
                  },
                ),
    );
  }

  void _deleteConfirmation(String productName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Confirmation'),
        content: Text('Are you sure you want to delete "$productName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteProduct(productName);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
