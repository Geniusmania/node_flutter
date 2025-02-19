import 'package:flutter/material.dart';
import 'package:flutter_shop/pages/all_products.dart';
import 'package:flutter_shop/pages/home_page.dart';
import 'package:flutter_shop/pages/read.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  const Read()
    );
  }
}

