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
  String? _selectedIkan;
  String? _selectedVarian;
  List<String> ikanTypes = ['Ikan Kecil', 'Ikan Besar'];
  List<String> varianTypes = ['Varian 1', 'Varian 2'];

  // Ambil data customer
  Future<Map<String, Customer>> fetchCustomer() async {
    try {
      final Map<String, dynamic> result = await NativeChannel.instance.getCustomers(
        '', '', '', '', '', '', // Gantilah parameter ini sesuai kebutuhan
      );
      print("Fetched Customers: $result");

      // Map data JSON ke objek Customer
      return result.map((key, value) {
        return MapEntry(key, Customer.fromJson(value));
      });
    } catch (e) {
      print('Error fetching customers: $e');
      throw Exception('Failed to fetch customers');
    }
  }

  // Tampilkan modal bottom sheet untuk input customer baru
  void _showCustomerForm() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Nama'),
                onChanged: (value) {},
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Telepon'),
                onChanged: (value) {},
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Alamat'),
                onChanged: (value) {},
              ),
              ElevatedButton(
                onPressed: () {
                  // Simpan data customer baru, kemudian tutup modal
                  Navigator.pop(context);
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Tampilkan halaman order setelah memilih customer
  void _showOrderForm() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedIkan,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedIkan = newValue;
                  });
                },
                items: ikanTypes.map((String ikan) {
                  return DropdownMenuItem<String>(
                    value: ikan,
                    child: Text(ikan),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Pilih Jenis Ikan',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedVarian,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedVarian = newValue;
                  });
                },
                items: varianTypes.map((String varian) {
                  return DropdownMenuItem<String>(
                    value: varian,
                    child: Text(varian),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Pilih Varian',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Simpan orderan dan tutup modal
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Order berhasil')),
                  );
                },
                child: const Text('Pesan'),
              ),
            ],
          ),
        );
      },
    );
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
            // Dropdown untuk memilih customer
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

                  return Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedCustomer != null
                            ? customersMap.keys.firstWhere(
                                (key) => customersMap[key] == _selectedCustomer,
                            orElse: () => ''
                        )
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
                            child: Text(customer!.nama),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Pilih Customer',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      TextButton(
                        onPressed: _showCustomerForm,
                        child: const Text('Tambah Customer Baru'),
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            // Tombol untuk melanjutkan ke form order
            ElevatedButton(
              onPressed: _selectedCustomer != null ? _showOrderForm : null,
              child: const Text('Isi Orderan'),
            ),
          ],
        ),
      ),
    );
  }
}
