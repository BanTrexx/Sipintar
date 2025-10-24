import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://innovillage-sipintar-api.onrender.com/api/v1/app'; // ganti IP sesuai backend kamu

  Future<List<dynamic>> getAllProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengambil data produk');
    }
  }

  Future<Map<String, dynamic>?> submitTransaction({
    required int productId,
    required int quantity,
    required String customerName,
    required String phoneNumber,
    required String deliveryAddress,
  }) async {
    final url = Uri.parse('https://innovillage-sipintar-api.onrender.com/api/v1/app/transactions');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'product_id': productId,
        'quantity': quantity,
        'customer_name': customerName,
        'phone_number': phoneNumber,
        'delivery_address': deliveryAddress,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');


    if (response.statusCode == 201) {
      return jsonDecode(response.body); // akan mengandung transaction_id
    }

    return null;
  }

  Future<Map<String, dynamic>> getTransactionById(String transactionId) async {
    final url = Uri.parse('$baseUrl/transactions/$transactionId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengambil transaksi');
    }
  }
}
