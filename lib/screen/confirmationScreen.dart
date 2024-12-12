import 'package:flutter/material.dart';
import 'package:ikanapps/backend/nativeChannel.dart';
import 'package:intl/intl.dart';
import 'dart:math';  // Untuk menggunakan random number

class ConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic>? selectedCustomerDetails;
  final List<Map<String, String>> orderList;
  final String totalHarga;
  late String generatedKodeCustomer; // Tambahkan properti ini

  ConfirmationScreen({
    required this.selectedCustomerDetails,
    required this.orderList,
    required this.totalHarga
  }) {
    // Generate kode customer hanya sekali saat objek ini dibuat
    generatedKodeCustomer = generateKodeCustomer();
    print("Selected Supplier Details: $selectedCustomerDetails");
    print("Selected Order List: $orderList");
  }

  String generateKodeCustomer() {
    // Generate kode customer yang unik
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String randomDigits = Random().nextInt(1000).toString().padLeft(3, '0');
    return 'MJL$timestamp$randomDigits';  // Misal hasilnya MJL123456789012300
  }

  Future<List> saveOrder() async {
    try {
      // Print debug info
      print("Saving order...");

      var date = DateTime.now();

      String dateString = "${date.day}-${date.month}-${date.year}";

      var produkData = await NativeChannel.instance.saveOrder(
          body: {
            'id': selectedCustomerDetails?['id'],
            'kodeCustomer': generateKodeCustomer(),  // Menggunakan fungsi generateKodeCustomer
            'nama': selectedCustomerDetails?['nama'],
            'kodeProduk': 'lauk',
            'jumlahPesanan': orderList.first['jumlahPesanan'],
            'hargaKg': orderList.first['hargaKg'],
            'shipment': orderList.first['shipment'],
            'payment': orderList.first['payment'],
            'totalPenerimaan': orderList.first['totalPenerimaan'],
            'piutang': orderList.first['piutang'],
            'aging': orderList.first['aging'],
            'tglTransaksi': dateString
          }
      );

      print("Order saved successfully: $produkData");
      return produkData as List;
    } catch (e) {
      print("Error saving order: $e");
      return []; // Return empty list on error
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Building ConfirmationScreen with selectedCustomerDetails: $selectedCustomerDetails");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Confirmation'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Supplier Information
                  Text(
                    'Supplier Details:',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const Divider(),
                  _buildSupplierInfo(),

                  const SizedBox(height: 20),

                  // Order List Section
                  Text(
                    'Order Details:',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const Divider(),
                  _buildOrderInfo(),

                  const SizedBox(height: 20),

                  // Transaction Details
                  Text(
                    'Transaction Summary:',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const Divider(),
                  _buildTransactionInfo(),

                  const SizedBox(height: 30),
                  // Save Button
                  ElevatedButton(
                    onPressed: () async {
                      var result = await saveOrder();
                      if (result.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Order successfully saved!')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to save order.')),
                        );
                      }
                    },
                    child: const Text('Send Data'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSupplierInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('ID:', selectedCustomerDetails?['id']),
        _buildInfoRow('Kode Custumer:', generateKodeCustomer()),
        _buildInfoRow('Nama Order:', selectedCustomerDetails?['nama']),
      ],
    );
  }

  Widget _buildOrderInfo() {
    if (orderList.isEmpty) {
      return const Text('No orders available.');
    }
    return Column(
      children: orderList.map((order) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Ikan:', order['fish']),
            _buildInfoRow('Variant:', order['variant']),
            _buildInfoRow('Bobot:', order['quantity']),
            _buildInfoRow('Jumlah:', order['jumlahPesanan']),
            _buildInfoRow('Harga:', order['hargaKg']),
            _buildInfoRow('Total Penerimaan:', order['totalPenerimaan']),
            _buildInfoRow('Piutang:', order['piutang']),
            _buildInfoRow('Aging:', order['aging']),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildTransactionInfo() {
    var date = DateTime.now();
    String dateString = "${date.day}-${date.month}-${date.year}";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        _buildInfoRow('Total Harga:', totalHarga),
        _buildInfoRow('Tanggal Transaksi:', dateString),
      ],
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? 'Unknown',
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
