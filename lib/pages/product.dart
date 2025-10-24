import 'package:flutter/material.dart';
import 'package:pintar/pages/checkout_page.dart';
import 'package:intl/intl.dart';


class ProductPage extends StatelessWidget {
  final int productId;
  final String name;
  final String price;
  final String image;
  final String description; // Tambahan

  const ProductPage({
    super.key,
    required this.productId,
    required this.name,
    required this.price,
    required this.image,
    required this.description, // Tambahan
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: image.startsWith('http') ? Image.network(image, fit: BoxFit.cover, width: double.infinity) : Image.asset(image, fit: BoxFit.cover, width: double.infinity),
            ),
            SizedBox(height: 20),
            Text(
              name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "${formatter.format(int.tryParse(price) ?? 0)}",
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
            SizedBox(height: 20),
            Text(
              description,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutPage(
                        productId: productId,
                        name: name,
                        price: price,
                        image: image,
                      ),
                    ),
                  );
                },
                child: Text("Beli Sekarang"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
