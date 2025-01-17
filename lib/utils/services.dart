import 'dart:convert';

import 'package:flutter_shop/models/product_models.dart';
import 'package:flutter_shop/utils/base_url.dart';
import 'package:http/http.dart' as http;

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

}

