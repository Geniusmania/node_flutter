import 'dart:convert';
import 'dart:io';
import 'dart:html' as html;
import 'package:flutter_shop/models/product_models.dart';
import 'package:flutter_shop/utils/base_url.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';



class Api {
  
Future<List<Products>> getProducts() async {
  final response = await http.get(Uri.parse('$baseUrl/allproduct'));
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
   // print(jsonData);
    if (jsonData != null) {
      final productList = jsonData as List?;
      if (productList != null && productList.isNotEmpty) {
        print(productList);
        return productList.map<Products>((e) => Products.fromJson(e)).toList();
       
      } else {
        // Handle the case where productList is null or empty
        return [];
      }
    } else {
      // Handle the case where jsonData is null
      return [];
    }
  } else {
    throw Exception('Failed to load products');
  }
}
Future<bool> addProductFromMap(Map<String, dynamic> productData) async {
  final response = await http.post(
    Uri.parse('$baseUrl/addproduct'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(productData),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception('Failed to add product: ${response.body}');
  }

}


Future<bool> deleteProduct(String productName) async {
  final response = await http.delete(
    Uri.parse('$baseUrl/removeproduct'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'name': productName}),
  );

  if (response.statusCode == 200) {
    print('Product deleted successfully');
    return true;
  } else {
    throw Exception('Failed to delete product: ${response.body}');
  }
}
Future<bool> updateProduct(int productId, Map<String, dynamic> updatedData) async {
  final response = await http.put(
    Uri.parse('$baseUrl/updateproduct/$productId'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(updatedData),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception('Failed to update product: ${response.body}');
  }
}

Future<String> uploadProductImage() async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    await uploadInput.onChange.first;
    final file = uploadInput.files?.first;

    if (file == null) throw Exception('No file selected.');

    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);
    await reader.onLoadEnd.first;

    final formData = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload'));
    formData.files.add(http.MultipartFile.fromBytes(
      'product',
      reader.result as List<int>,
      filename: file.name,
      contentType: MediaType('image', file.type.split('/').last),
    ));

    final streamedResponse = await formData.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final respJson = jsonDecode(response.body);
      return respJson['image_url'];
    } else {
      throw Exception('Failed to upload image');
    }
  }
Future<List<String>> getAllImages() async {
  final response = await http.get(Uri.parse('$baseUrl/allimages'));
  if (response.statusCode == 200) {
    final List<dynamic> images = jsonDecode(response.body);
    return images.map((imageUrl) => imageUrl.toString()).toList();
  } else {
    throw Exception('Failed to load images');
  }
}
}

