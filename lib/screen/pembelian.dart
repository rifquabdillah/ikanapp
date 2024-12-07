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
  String? _selectedSupplier;
  String? _selectedFishVariant;
  String? _selectedFishCount;
  String? _quantity;
  String? _price;

  List<String> _fishVariants = [];
  final List<Map<String, String>> _orderList = [];
  List<Map<String, dynamic>> suppliersData = [];
  List<Map<String, dynamic>> varianData = [];
  Map<String, dynamic>? _selectedSupplierDetails;



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

  Future<List<Map<String, dynamic>>> fetchSupplier() async {
    try {
      print("Fetching stock data...");  // Debugging line
      var produkData = await NativeChannel.instance.fetchSupplier();
      print("Data fetched: $produkData"); // Debugging
      return produkData;
    } catch (e) {
      print("Error fetching stock data: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchVarian() async {
    try {
      print("Fetching stock data...");  // Debugging line
      var produkData = await NativeChannel.instance.fetchVarian();
      print("Data fetched: $produkData"); // Debugging
      return produkData;
    } catch (e) {
      print("Error fetching stock data: $e");
      return [];
    }
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
              FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchSupplier(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No data available');
            } else {
              List<Map<String, dynamic>> supplierData = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownField<String>(
                    value: _selectedSupplier, // Variable to store selected supplier
                    items: supplierData.map((item) => item['nama'] as String).toList(),
                    label: "Pilih Supplier",
                    itemLabel: (item) => item,
                    onChanged: (value) {
                      setState(() {
                        _selectedSupplier = value; // Store selected supplier
                        // Find and set details of the selected supplier
                        _selectedSupplierDetails = supplierData.firstWhere(
                              (item) => item['nama'] == value,
                          orElse: () => {},
                        );
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  if (_selectedSupplierDetails != null) ...[
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        "Nomor HP: ${_selectedSupplierDetails!['nomor_handphone'] ?? 'Tidak tersedia'}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        "Alamat: ${_selectedSupplierDetails!['alamat'] ?? 'Tidak tersedia'}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ]
                ],
              );
            }
          },
          ),

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
                      });
                    },
                  );

                }
              },
            ),


            const SizedBox(height: 20),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchVarian(),
                builder: (context, snapshot) {
                  // Loading state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Error state
                  if (snapshot.hasError) {
                    debugPrint("Error: ${snapshot.error}");
                    return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
                  }

                  // Empty data state
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Tidak ada data varian tersedia'));
                  }

                  // Success state
                  List<Map<String, dynamic>> varianData = snapshot.data!;
                  List<String> fishVariants = varianData
                      .map((item) => item['varian']?.toString() ?? "Unknown Variant")
                      .toList(); // Keep duplicates

                  // Reset value if it's invalid
                  if (_selectedFishVariant != null &&
                      !fishVariants.contains(_selectedFishVariant)) {
                    _selectedFishVariant = null;
                  }

                  return DropdownField<String>(
                    value: _selectedFishVariant,
                    items: fishVariants,
                    label: "Pilih Varian Ikan",
                    itemLabel: (item) => item,
                    onChanged: (value) {
                      setState(() {
                        _selectedFishVariant = value;
                      });
                    },
                  );
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
