import 'package:flutter/material.dart';
import 'package:flutter_shop/models/product_models.dart';
import 'package:flutter_shop/utils/services.dart';

class Read extends StatefulWidget {
  const Read({super.key});

  @override
  State<Read> createState() => _ReadState();
}

class _ReadState extends State<Read> {
  Api api = Api();
  late Future<List<Products>> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = api.getProducts(); // Load products initially
  }

  // 🔄 Refresh product list
  void _refreshProducts() {
    setState(() {
      _productFuture = api.getProducts();
    });
  }

  // Delete product with confirmation
  void _deleteProduct(String productName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "$productName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                bool isDeleted = await api.deleteProduct(productName);
                if (isDeleted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(' "$productName" deleted successfully!')),
                  );
                  _refreshProducts();
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(' Failed to delete "$productName": $e')),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product List')),
      body: SafeArea(
        child: FutureBuilder(
          future: _productFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('An error occurred. Please try again later.'));
            } else if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Center(child: Text('No products available.'));
              }

              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final product = snapshot.data![index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      title: Text(product.name),
                      subtitle: Text('Price: \$${product.new_price}\nCategory: ${product.category}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteProduct(product.name),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('Unexpected error.'));
            }
          },
        ),
      ),
    );
  }
}
