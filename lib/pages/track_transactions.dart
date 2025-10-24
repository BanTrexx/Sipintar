import 'package:flutter/material.dart';
import 'package:pintar/api_service.dart';

class TrackTransactionPage extends StatefulWidget {
  const TrackTransactionPage({super.key});

  @override
  State<TrackTransactionPage> createState() => _TrackTransactionPageState();
}

class _TrackTransactionPageState extends State<TrackTransactionPage> {
  final _controller = TextEditingController();
  Map<String, dynamic>? transaction;
  bool isLoading = false;
  String? error;

  Future<void> _fetchTransaction() async {
    final id = _controller.text.trim();
    if (id.isEmpty) return;

    setState(() {
      isLoading = true;
      error = null;
      transaction = null;
    });

    try {
      final data = await ApiService().getTransactionById(id);
      setState(() {
        transaction = data;
      });
    } catch (e) {
      setState(() {
        error = "Transaksi tidak ditemukan atau terjadi kesalahan.";
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Lacak Transaksi"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSearchBox(),
            const SizedBox(height: 20),
            if (isLoading) const CircularProgressIndicator(),
            if (error != null) _buildError(error!),
            if (transaction != null) _buildTransactionCard(transaction!),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        children: [
          TextFormField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: "Masukkan Transaction ID",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text("Lacak Transaksi"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _fetchTransaction,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _transactionInfoRow("Transaction ID", data['transaction_id']),
          _transactionInfoRow("Nama Pembeli", data['customer_name']),
          _transactionInfoRow("Produk", data['product']['name']),
          _transactionInfoRow("Jumlah", data['quantity'].toString()),
          _transactionInfoRow("Status", _capitalize(data['status'])),
          const SizedBox(height: 10),
          Text(
            "Alamat Pengiriman:",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(data['delivery_address']),
        ],
      ),
    );
  }

  Widget _transactionInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(width: 140, child: Text("$label:", style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }
}
