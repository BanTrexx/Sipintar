import 'package:flutter/material.dart';
import 'package:pintar/pages/home.dart';
import 'package:pintar/pages/product.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes : <String, WidgetBuilder>{
        '/home' : (BuildContext context) => HomePage(),
        '/product' : (BuildContext context) => ProductPage(
          productId: 1,
          name: 'Nama Produk',
          price: 'Rp. 100.000',
          image: 'assets/images/01.png',
          description: 'placeholder deskripsi produk',
        ),
        '/checkout' : (BuildContext context) => HomePage(),
      }
    );
  }
}