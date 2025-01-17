import 'package:flutter/material.dart';
import 'package:flutter_shop/utils/services.dart';

class Create extends StatefulWidget {
  const Create({super.key});

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  void _submit() {}
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController categoryController = TextEditingController();
    TextEditingController old_priceController = TextEditingController();
    TextEditingController new_priceController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController imageController = TextEditingController();

    return Scaffold(
        body: Column(
      children: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
              isDense: true, hintText: 'name', border: OutlineInputBorder()),
        ),
        TextField(
          controller: categoryController,
          decoration: const InputDecoration(
              hintText: 'Category', border: OutlineInputBorder()),
        ),
        TextField(
          controller: old_priceController,
          decoration: const InputDecoration(
              hintText: 'Old_price', border: OutlineInputBorder()),
        ),
        TextField(
          controller: new_priceController,
          decoration: const InputDecoration(
              hintText: 'New_price', border: OutlineInputBorder()),
        ),
        TextField(
          controller: descriptionController,
          decoration: const InputDecoration(
              hintText: 'description', border: OutlineInputBorder()),
        ),
        TextField(
          controller: imageController,
          decoration: const InputDecoration(
              hintText: 'image', border: OutlineInputBorder()),
        ),
        ElevatedButton(
            onPressed: () {
              var data = {
                'name': nameController.text,
                'category': categoryController.text,
                'old_price': old_priceController.text,
                'new_price': new_priceController.text,
                'description': descriptionController.text,
                'image': imageController.text,
              };
             
            },
            child: const Text('submit')),
      ],
    ));
  }
}
