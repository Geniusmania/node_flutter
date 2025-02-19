import 'package:flutter/material.dart';
import 'package:flutter_shop/utils/services.dart'; // Ensure addProduct function is imported

class Create extends StatefulWidget {
  const Create({super.key});

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController oldPriceController = TextEditingController();
  final TextEditingController newPriceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
Api _api = Api();
  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      var data = {
        'name': nameController.text,
        'category': categoryController.text,
        'old_price': double.tryParse(oldPriceController.text) ?? 0.0,
        'new_price': double.tryParse(newPriceController.text) ?? 0.0,
        'description': descriptionController.text,
        'image': imageController.text,
      };

      try {
        bool isAdded = await _api.addProductFromMap(data);
        if (isAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Product added successfully!')),
          );
          _clearFields();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(' Error: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _clearFields() {
    nameController.clear();
    categoryController.clear();
    oldPriceController.clear();
    newPriceController.clear();
    descriptionController.clear();
    imageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(nameController, 'Name', true),
                _buildTextField(categoryController, 'Category', true),
                _buildTextField(oldPriceController, 'Old Price', true, isNumber: true),
                _buildTextField(newPriceController, 'New Price', true, isNumber: true),
                _buildTextField(descriptionController, 'Description', true),
                _buildTextField(imageController, 'Image URL', true),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submit,
                        child: const Text('Submit'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, bool required, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (required && (value == null || value.isEmpty)) {
            return ' $label is required';
          }
          if (isNumber && value != null && double.tryParse(value) == null) {
            return ' Enter a valid number';
          }
          return null;
        },
      ),
    );
  }
}
