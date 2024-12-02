import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'confirmationScreen.dart';
import 'package:ikanapps/provider/StockProvider.dart';
import 'package:ikanapps/model/Stock.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final List<Map<String, String>> _customers = [
    {
      "name": "Customer 1",
      "phone": "08123456789",
      "address": "Jl. Graha Alam Raya Bandung  No. 1"
    },
    {
      "name": "Customer 2",
      "phone": "08198765432",
      "address": "Jl. Graha Alam Raya Bandung No. 2"
    },
    {
      "name": "Customer 3",
      "phone": "08122334455",
      "address": "Jl. Graha Alam Raya Bandung No. 3"
    },
  ];

  Map<String, String>? _selectedCustomer;

  String? _selectedFish;
  String? _selectedFishVariant;
  String? _selectedFishCount;
  String? _quantity;
  String? _price;

  final List<String> _fishes = ["Ikan Nila", "Ikan Lele", "Ikan Mas"];
  final Map<String, List<String>> _fishVariants = {
    "Ikan Nila": ["Nila Merah", "Nila Hitam"],
    "Ikan Lele": ["Lele Sangkuriang", "Lele Lokal"],
    "Ikan Mas": ["Mas Koki", "Mas Lokal"],
  };
  final List<String> _fishCountOptions = [
    "1 kg 1 ekor",
    "1 kg 2 ekor",
    "1 kg 3 ekor",
    "1 kg 4 ekor",
    "1 kg 5 ekor",
    "1 kg 6 ekor",
  ];

  final List<Map<String, String>> _orderList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF205a92),
        title: const Text("Orderan Ikan"),
        centerTitle: true,
        elevation: 5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownField<Map<String, String>>(
                value: _selectedCustomer,
                items: _customers,
                label: "Pilih Customer",
                onChanged: _orderList.isEmpty
                    ? (value) {
                  setState(() {
                    _selectedCustomer = value;
                  });
                }
                    : null,
                itemLabel: (item) => item['name']!,
                isEnabled: _orderList.isEmpty,
              ),
              if (_selectedCustomer != null) ...[
                const SizedBox(height: 10),
                _buildCustomerInfo("Phone", _selectedCustomer!['phone']!),
                _buildCustomerInfo("Address", _selectedCustomer!['address']!),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _showAddCustomerBottomSheet(context),
                child: const Text("Tambah Customer Baru"),
              ),
              const SizedBox(height: 20),
              DropdownField<String>(
                value: _selectedFish,
                items: _fishes,
                label: "Pilih Jenis Ikan",
                itemLabel: (item) => item,
                onChanged: (value) {
                  setState(() {
                    _selectedFish = value;
                    _selectedFishVariant = null;
                  });
                },
              ),
              if (_selectedFish != null)
                ...[
                  const SizedBox(height: 20),
                  DropdownField<String>(
                    value: _selectedFishVariant,
                    items: _fishVariants[_selectedFish!] ?? [],
                    label: "Pilih Varian Ikan",
                    itemLabel: (item) => item,
                    onChanged: (value) {
                      setState(() {
                        _selectedFishVariant = value;
                      });
                    },
                  ),
                ],
              if (_selectedFishVariant != null)
                ...[
                  const SizedBox(height: 20),
                  DropdownField<String>(
                    value: _selectedFishCount,
                    items: _fishCountOptions,
                    label: "Bobot",
                    itemLabel: (item) => item,
                    onChanged: (value) {
                      setState(() {
                        _selectedFishCount = value;
                      });
                    },
                  ),
                ],
              if (_selectedFishCount != null)
                ...[
                  const SizedBox(height: 20),
                  _buildTextField("Jumlah Transaksi", (value) {
                    setState(() {
                      _quantity = value;
                    });
                  }),
                ],
              if (_quantity != null)
                ...[
                  const SizedBox(height: 20),
                  _buildTextField("Harga (per kg)", (value) {
                    setState(() {
                      _price = value;
                    });
                  }),
                ],
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canAddOrder() ? _addOrder : null,
                  style: _buttonStyle(),
                  child: const Text("Tambah Pesanan"),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Pesanan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildOrderTable(),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: _canCheckout() ? _processTransaction : null,
                  style: _buttonStyle(),
                  child: const Text("Checkout Transaksi"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerInfo(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          const BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        "$label: $value",
        style: const TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
      ),
    );
  }

  Widget _buildTextField(String label, ValueChanged<String> onChanged) {
    return TextField(
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF2464a2),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      foregroundColor: const Color(0xffd3e0ec),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: 'Montserrat',
      ),
    );
  }

  bool _canAddOrder() {
    return _selectedCustomer != null &&
        _selectedFish != null &&
        _selectedFishVariant != null &&
        _selectedFishCount != null &&
        _quantity != null;
  }

  bool _canCheckout() {
    return _orderList.isNotEmpty && _selectedCustomer != null;
  }

  void _addOrder() {
    setState(() {
      _orderList.add({
        'customer': _selectedCustomer!['name']!,
        'fish': _selectedFish!,
        'variant': _selectedFishVariant!,
        'weight': _selectedFishCount!,
        'quantity': _quantity!,
        'price': _price ?? "0",
      });
      _resetSelection();
    });
  }

  void _resetSelection() {
    _selectedFish = null;
    _selectedFishVariant = null;
    _selectedFishCount = null;
    _quantity = null;
    _price = null;
  }

  void _processTransaction() async {
    if (_canCheckout()) {
      // Mengumpulkan data pesanan
      final Map<String, dynamic> orderData = {
        'customer': _selectedCustomer!['name']!,
        'fish': _orderList.map((order) => order['fish']).toList(),
        'variant': _orderList.map((order) => order['variant']).toList(),
        'weight': _orderList.map((order) => order['weight']).toList(),
        'quantity': _orderList.map((order) => order['quantity']).toList(),
        'price': _orderList.map((order) => order['price']).toList(),
      };

      try {
        // Mengirim data ke API
        final response = await http.post(
          Uri.parse('http://103.139.244.148:5002/'),  // Ganti dengan URL API Anda
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(orderData),
        );

        if (response.statusCode == 200) {
          // Berhasil mengirim data
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Transaksi selesai!")),
          );
          setState(() {
            _orderList.clear();
            _selectedCustomer = null;
          });
        } else {
          // Jika terjadi error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Gagal mengirim transaksi. Error: ${response.statusCode}")),
          );
        }
      } catch (e) {
        // Menangani error jika terjadi masalah jaringan atau lainnya
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Terjadi kesalahan: $e")),
        );
      }
    }
  }


  Widget _buildOrderTable() {
    if (_orderList.isEmpty) {
      return const Center(child: Text("Belum ada pesanan."));
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: _orderList.length,
      itemBuilder: (context, index) {
        final order = _orderList[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            title: Text("${order['fish']} - ${order['variant']}"),
            subtitle: Text("Jumlah: ${order['quantity']}"),
            trailing: Text("Bobot: ${order['weight']}"),
          ),
        );
      },
    );
  }

  void _showAddCustomerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              const BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextFieldWithBottomBorder("Nama", (value) {}),
              _buildTextFieldWithBottomBorder("Nomor Telepon", (value) {}),
              _buildTextFieldWithBottomBorder("Alamat", (value) {}),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _customers.add({
                      'name': 'Customer Baru',
                      'phone': '0800000000',
                      'address': 'Alamat Baru',
                    });
                  });
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2464a2), // Warna tombol
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0), // Padding vertikal untuk membuat tombol lebih tinggi
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), // Membuat sudut tombol melengkung
                  foregroundColor: Colors.white, // Warna teks tombol
                  textStyle: const TextStyle(
                    fontSize: 16, // Ukuran font
                    fontWeight: FontWeight.bold, // Tebal font
                    fontFamily: 'Montserrat', // Gaya font
                  ),
                ),
                child: const Text("Simpan"),
              )

            ],
          ),
        );
      },
    );
  }

  Widget _buildTextFieldWithBottomBorder(String label,
      ValueChanged<String> onChanged) {
    return TextField(
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
        border: InputBorder.none,
        // Menghilangkan border default
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
              color: Colors.black54, width: 1.0), // Border bawah
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
              color: Colors.blue, width: 1.0), // Border bawah saat fokus
        ),
      ),
    );
  }
}

  class DropdownField<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String label;
  final ValueChanged<T?>? onChanged;
  final bool isEnabled;
  final String Function(T) itemLabel;

  const DropdownField({
    Key? key,
    required this.value,
    required this.items,
    required this.label,
    required this.itemLabel,
    required this.onChanged,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      onChanged: isEnabled ? onChanged : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(itemLabel(item)),
        );
      }).toList(),
    );
  }
}
