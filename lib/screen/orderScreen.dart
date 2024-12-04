import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ikanapps/backend/nativeChannel.dart';

class Customer {
  final String nama;
  final String telepon;
  final String telepon2;
  final String alamat;
  final String patokan;
  final String gps;

  Customer({
    required this.nama,
    required this.telepon,
    required this.telepon2,
    required this.alamat,
    required this.patokan,
    required this.gps,
  });

  // Factory method untuk membuat instance Customer dari JSON
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      nama: json['nama'] ?? '',
      telepon: json['telepon'] ?? '',
      telepon2: json['telepon2'] ?? '',
      alamat: json['alamat'] ?? '',
      patokan: json['patokan'] ?? '',
      gps: json['gps'] ?? '',
    );
  }
}

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  Customer? _selectedCustomer;

  // Fungsi untuk mengambil data customer
  Future<Map<String, Customer>> fetchCustomer() async {
    try {
      // Memanggil fungsi untuk mengambil data customer dari Native Channel
      final String result = await NativeChannel.instance.getCustomers(
          '', '', '', '', '', '' // Gantilah parameter ini sesuai kebutuhan
      );
      print("Fetched Customers: $result");  // Log hasil pemanggilan

      // Decode JSON yang diterima dan map ke Customer
      final Map<String, dynamic> rawData = json.decode(result);
      return rawData.map((key, value) {
        return MapEntry(key, Customer.fromJson(value));
      });
    } catch (e) {
      print('Error fetching customers: $e');
      throw Exception('Failed to fetch customers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orderan Ikan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Menggunakan FutureBuilder untuk menunggu data customer
            FutureBuilder<Map<String, Customer>>(
              future: fetchCustomer(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No customers available');
                } else {
                  final customersMap = snapshot.data!;

                  return DropdownButtonFormField<String>(
                    value: _selectedCustomer != null
                        ? customersMap.keys
                        .firstWhere(
                            (key) => customersMap[key] == _selectedCustomer)
                        : null,
                    onChanged: (String? key) {
                      setState(() {
                        _selectedCustomer = customersMap[key!];
                      });
                    },
                    items: customersMap.keys.map((key) {
                      final customer = customersMap[key];
                      return DropdownMenuItem<String>(
                        value: key,
                        child: Text(customer!.nama), // Menampilkan nama customer
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Pilih Customer',
                      border: OutlineInputBorder(),
                    ),
                  );
                }
              },
            ),
            if (_selectedCustomer != null) ...[
              const SizedBox(height: 20),
              Text("Telepon 1: ${_selectedCustomer!.telepon}"),
              Text("Telepon 2: ${_selectedCustomer!.telepon2}"),
              Text("Alamat: ${_selectedCustomer!.alamat}"),
              Text("Patokan: ${_selectedCustomer!.patokan}"),
              Text("GPS: ${_selectedCustomer!.gps}"),
            ],
          ],
        ),
      ),
    );
  }
}
