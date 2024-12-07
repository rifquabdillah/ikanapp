import 'package:flutter/material.dart';
import 'package:ikanapps/backend/nativeChannel.dart';
import 'confirmationScreen.dart';

class Orderscreen extends StatefulWidget {
  const Orderscreen({Key? key}) : super(key: key);

  @override
  State<Orderscreen> createState() => _OrderscreenState();
}

class _OrderscreenState extends State<Orderscreen> {
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
  Map<String, dynamic>? _selectedSupplierDetails;


  Future<List<Map<String, dynamic>>> fetchCustomer() async {
    try {
      print("Fetching stock data..."); // Debugging line
      var produkData = await NativeChannel.instance.fetchCustomer();
      print("Data fetched: $produkData"); // Debugging
      return produkData;
    } catch (e) {
      print("Error fetching stock data: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchStok() async {
    try {
      print("Fetching stock data..."); // Debugging line
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
        title: const Text("Orderan"),
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
                future: fetchCustomer(),
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
                          value: _selectedSupplier,
                          // Variable to store selected supplier
                          items: supplierData.map((
                              item) => item['nama'] as String).toList(),
                          label: "Pilih Customer",
                          itemLabel: (item) => item,
                          onChanged: (value) {
                            setState(() {
                              _selectedSupplier =
                                  value; // Store selected supplier
                              // Find and set details of the selected supplier
                              _selectedSupplierDetails =
                                  supplierData.firstWhere(
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
                              "Telepon: ${_selectedSupplierDetails!['telepon'] ??
                                  'Tidak tersedia'}",
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
                              "Telepon 2: ${_selectedSupplierDetails!['telepon2'] ??
                                  'Tidak tersedia'}",
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
                              "Alamat: ${_selectedSupplierDetails!['alamat'] ??
                                  'Tidak tersedia'}",
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
                              "Patokan: ${_selectedSupplierDetails!['patokan'] ??
                                  'Tidak tersedia'}",
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
                    print("Loading..."); // Debugging line
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    print("Error: ${snapshot.error}"); // Debugging line
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No data available');
                  } else {
                    print("Fetched data: ${snapshot.data}"); // Debugging line
                    List<Map<String, dynamic>> fishData = snapshot.data!;
                    return DropdownField<String>(
                      value: _selectedFish,
                      items: fishData.map((item) => item['nama'] as String)
                          .toList(),
                      label: "Pilih Jenis Ikan",
                      itemLabel: (item) => item,
                      onChanged: (value) {
                        setState(() {
                          _selectedFish = value;
                          _selectedFishVariant =
                          null; // Reset variant when fish changes
                          _updateFishVariants(
                              value!); // Update variants based on selected fish
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
              const Text("Pesanan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

            // Reset the form after adding the order
            setState(() {
              _selectedFish = null;
              _selectedFishVariant = null;
              _quantity = null;
              _price = null;
            });
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
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          // Margin for spacing between cards
          child: Card(
            elevation: 2,
            color: const Color(0xffFAF9F6), // Card background color
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Customer name
                  Text(
                    "Nama Customer: ${_selectedSupplier ?? 'Belum dipilih'}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),

                  // Row for Fish and Variant with Qty and Price aligned to the right
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // Align items between left and right
                    children: [
                      // Left side: Fish and Variant
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Ikan ${order['fish'] ?? 'Unknown Fish'}",
                            style: const TextStyle(fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins'),
                          ),
                          Text(
                            "${order['variant'] ?? 'Unknown Variant'}",
                            style: const TextStyle(fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins'),
                          ),
                        ],
                      ),

                      // Right side: Qty and Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${order['quantity'] ?? '0'} kg',
                            // Display quantity with kg
                            style: const TextStyle(fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500),
                          ),

                          const SizedBox(height: 8),
                          // Space between quantity and price
                          Text(
                            'Rp.${order['price']?.toString() ?? '0'}',
                            // Display price
                            style: const TextStyle(fontSize: 14,
                                color: Colors.teal,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Additional details (like fish code or specific order info)
                  Text(
                    'Detail: ${order['detail'] ??
                        'No active period available'}',
                    // Display additional details
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xff909EAE)),
                  ),
                ],
              ),
            ),
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
          // Prepare the customer data and order list to pass
          Map<String, String> customerData = {
            'customerName': _selectedSupplier ?? 'Unknown',  // Ensure the value is a String
            'customerDetails': _selectedSupplierDetails.toString(), // Convert to String if necessary
            'telepon': _selectedSupplierDetails?['telepon'] ?? 'Tidak tersedia',
            'telepon2': _selectedSupplierDetails?['telepon2'] ?? 'Tidak tersedia',
            'alamat': _selectedSupplierDetails?['alamat'] ?? 'Tidak tersedia',
            'patokan': _selectedSupplierDetails?['patokan'] ?? 'Tidak tersedia',
          };

          // Navigate to confirmation screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConfirmationScreen(
                orderList: _orderList, // Passing the order list
                customerData: customerData, // Passing the customer data
              ),
            ),
          );
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

}