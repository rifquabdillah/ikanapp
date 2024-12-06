import 'package:flutter/material.dart';
import 'package:ikanapps/backend/nativeChannel.dart';
import 'confirmationScreen.dart';

class PembelianScreen extends StatefulWidget {
  const PembelianScreen({Key? key}) : super(key: key);

  @override
  State<PembelianScreen> createState() => _PembelianScreenState();
}

class _PembelianScreenState extends State<PembelianScreen> {
  Map<String, String>? _selectedCustomer;
  String? _selectedFish;
  String? _selectedFishVariant;
  String? _selectedFishCount;
  String? _quantity;
  String? _price;

  List<String> _fishVariants = [];
  final List<Map<String, String>> _orderList = [];

  Future<List<Map<String, dynamic>>> fetchStok() async {
    try {
      print("Fetching stock data...");  // Debugging line
      var produkData = await NativeChannel.instance.fetchStok();
      print("Data fetched: $produkData"); // Debugging
      return produkData;
    } catch (e) {
      print("Error fetching stock data: $e");
      return [];
    }
  }



  // Function to update fish variants based on selected fish
  void _updateFishVariants(String selectedFish) {
    setState(() {
      // Simpan logika untuk memperbarui varian berdasarkan ikan yang dipilih dari data backend
      _fishVariants = ['Varian 1', 'Varian 2', 'Varian 3'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6693be),
        title: const Text("Pembelian Ikan"),
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
              const SizedBox(height: 20),

              // FutureBuilder for fetching fish stock
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchStok(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  print("Loading...");  // Debugging line
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print("Error: ${snapshot.error}");  // Debugging line
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No data available');
                } else {
                  print("Fetched data: ${snapshot.data}");  // Debugging line
                  List<Map<String, dynamic>> fishData = snapshot.data!;
                  return DropdownField<String>(
                    value: _selectedFish,
                    items: fishData.map((item) => item['nama'] as String).toList(),
                    label: "Pilih Jenis Ikan",
                    itemLabel: (item) => item,
                    onChanged: (value) {
                      setState(() {
                        _selectedFish = value;
                        _selectedFishVariant = null; // Reset variant when fish changes
                        _updateFishVariants(value!); // Update variants based on selected fish
                      });
                    },
                  );

                }
              },
            ),


            const SizedBox(height: 20),
              // Dropdown for Fish Variant
              if (_selectedFish != null)
                DropdownField<String>(
                  value: _selectedFishVariant,
                  items: _fishVariants,
                  label: "Pilih Varian Ikan",
                  itemLabel: (item) => item,
                  onChanged: (value) {
                    setState(() {
                      _selectedFishVariant = value;
                    });
                  },
                ),
              const SizedBox(height: 20),

              // TextField for Quantity
              if (_selectedFishVariant != null)
                _buildQuantityField(),

              const SizedBox(height: 20),
              // TextField for Price
              if (_quantity != null)
                _buildPriceField(),

              const SizedBox(height: 15),
              // Button to Add Order
              _buildAddOrderButton(),

              const SizedBox(height: 20),
              // Order Summary
              const Text("Pesanan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildOrderTable(),

              const SizedBox(height: 10),
              // Confirmation Button
              _buildConfirmationButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityField() {
    return TextField(
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          _quantity = value;
        });
      },
      decoration: const InputDecoration(
        labelText: "Jumlah Transaksi",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPriceField() {
    return TextField(
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          _price = value;
        });
      },
      decoration: const InputDecoration(
        labelText: "Harga (per kg)",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildAddOrderButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_selectedFish != null &&
              _selectedFishVariant != null &&
              _quantity != null &&
              _price != null) {
            _addOrder();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Mohon lengkapi semua data!")),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6693be),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          foregroundColor: const Color(0xffe9f0f6),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
        child: const Text("Tambah Pesanan"),
      ),
    );
  }

  void _addOrder() {
    setState(() {
      _orderList.add({
        'fish': _selectedFish!,
        'variant': _selectedFishVariant!,
        'quantity': _quantity!,
        'price': _price!,
      });
    });
  }

  Widget _buildOrderTable() {
    if (_orderList.isEmpty) {
      return const Text("Belum ada pesanan.");
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _orderList.length,
      itemBuilder: (context, index) {
        final order = _orderList[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black54),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Ikan: ${order['fish']}"),
              Text("Varian: ${order['variant']}"),
              Text("Jumlah: ${order['quantity']}"),
              Text("Harga: ${order['price']}"),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConfirmationButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _orderList.isEmpty
            ? null
            : () {
          // Navigate to confirmation screen
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          backgroundColor: const Color(0xFF6693be),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
        child: const Text("Konfirmasi Pesanan"),
      ),
    );
  }
}

Widget DropdownField<T>({
  required T? value,
  required List<T> items,
  required String label,
  required ValueChanged<T?>? onChanged,
  required String Function(T) itemLabel,
  bool isEnabled = true,
}) {
  return DropdownButtonFormField<T>(
      value: value,
      items: items.map((item) {
    return DropdownMenuItem<T>(
      value: item,
      child: Text(itemLabel(item)),
    );
  }).toList(),
  onChanged: isEnabled ? onChanged : null,
  decoration: InputDecoration(
  labelText: label,
  border: OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  ),
  )
  );
}
