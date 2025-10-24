import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pintar/api_service.dart';

class CheckoutPage extends StatefulWidget {
  final String name;
  final String price;
  final String image;
  final int productId; // ← tambahkan ini

  const CheckoutPage({
    super.key,
    required this.name,
    required this.price,
    required this.image,
    required this.productId,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  int _quantity = 1;
  bool _isSubmitting = false;

  int getParsedPrice() {
    try {
      return int.parse(widget.price.replaceAll(RegExp(r'[^0-9]'), ''));
    } catch (_) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final unitPrice = getParsedPrice();
    final total = unitPrice * _quantity;

    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: widget.image.startsWith('http')
                        ? Image.network(widget.image, width: 100, height: 100, fit: BoxFit.cover)
                        : Image.asset(widget.image, width: 100, height: 100, fit: BoxFit.cover),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        SizedBox(height: 8),
                        Text("Harga satuan: ${formatter.format(unitPrice)}", style: TextStyle(fontSize: 16, color: Colors.green)),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Nama Pembeli"),
                validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "No. Telepon"),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: "Alamat Pengiriman"),
                maxLines: 2,
                validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Jumlah: $_quantity", style: TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (_quantity > 1) {
                            setState(() {
                              _quantity--;
                            });
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Divider(),
              Text("Total Harga: ${formatter.format(total)}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              if (_isSubmitting)
                Center(child: CircularProgressIndicator())
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitTransaction,
                    child: Text("Konfirmasi Pembelian"),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final success = await ApiService().submitTransaction(
      productId: widget.productId,
      quantity: _quantity,
      customerName: _nameController.text,
      phoneNumber: _phoneController.text,
      deliveryAddress: _addressController.text,
    );

    setState(() => _isSubmitting = false);

    if (success != null) {
      _showSuccessDialog(context, success['transaction_id']); // tampilkan ID dari server
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengirim transaksi")),
      );
    }
  }

  void _showSuccessDialog(BuildContext context, String transactionId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Berhasil!"),
        content: Text("Pesanan Anda telah dikonfirmasi.\nID Transaksi: $transactionId"),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
