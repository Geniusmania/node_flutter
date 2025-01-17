import 'package:flutter/material.dart';
import 'package:flutter_shop/utils/services.dart';

class Read extends StatefulWidget {
  const Read({super.key});

  @override
  State<Read> createState() => _ReadState();
}

class _ReadState extends State<Read> {
  Api api = Api();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder(
              future: api.getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('An error occurred. Please try again later.'));
                } else if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return const Center(child: Text('No products available.'));
                  }
      
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final product = snapshot.data![index];
                        return ListTile(
                          title: Text(product.name),
                          subtitle: Text(product.new_price.toString()),
                          leading: Text(product.category),
                          trailing: Text(product.description),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(child: Text('Unexpected error.'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
