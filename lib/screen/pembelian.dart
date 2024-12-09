import 'package:flutter/material.dart';
import 'package:ikanapps/backend/nativeChannel.dart';
import 'package:ikanapps/screen/confirmationPembelian.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
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
  String? _quantity;
  String? _count;
  String? _price;
  String? _selectedProductCode;

  List<String> _fishVariants = [];
  final List<Map<String, String>> _orderList = [];
  List<Map<String, dynamic>> suppliersData = [];
  Map<String, dynamic>? _selectedSupplierDetails;

  String _calculateTotal() {
    double count = double.tryParse(_count ?? '0') ??
        0; // Gunakan _quantity untuk jumlah
    double price = double.tryParse(_price ?? '0') ?? 0; // Harga per kg
    double total = count * price; // Menghitung total harga
    return total.toStringAsFixed(0); // Menampilkan tanpa desimal
  }

  Future<List<Map<String, dynamic>>> fetchSupplier() async {
    try {
      print("Fetching customer data...");
      var produkData = await NativeChannel.instance.fetchSupplier();
      print("Data fetched: $produkData");
      return produkData;
    } catch (e) {
      print("Error fetching customer data: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchStok() async {
    try {
      print("Fetching stock data...");
      var produkData = await NativeChannel.instance.fetchStok();
      print("Data fetched: $produkData");
      return produkData;
    } catch (e) {
      print("Error fetching stock data: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchVarian() async {
    try {
      print("Fetching fish variant data...");
      var produkData = await NativeChannel.instance.fetchVarian();
      print("Data fetched: $produkData");
      return produkData;
    } catch (e) {
      print("Error fetching data: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchBobot() async {
    try {
      print("Fetching fish weight data...");
      var produkData = await NativeChannel.instance.fetchBobot();
      print("Data fetched: $produkData");
      return produkData;
    } catch (e) {
      print("Error fetching data: $e");
      return [];
    }
  }

  // Function to update fish variants based on selected fish
  void _updateFishVariants(String selectedFish) {
    setState(() {
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
              // Customer Dropdown
              FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchSupplier(),
                builder: (context, snapshot) {
                  List<Map<String, dynamic>> supplierData = snapshot.data ?? [];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownField<String>(
                        value: _selectedSupplier,
                        items: supplierData.map((item) {
                          return '${item['kodeSupplier']} - ${item['nama']}';
                        }).toList(),
                        label: "Pilih Supplier",
                        itemLabel: (item) => item,
                        onChanged: (value) {
                          setState(() {
                            _selectedSupplier = value;
                            _selectedSupplierDetails = supplierData.firstWhere(
                                  (item) =>
                              '${item['kodeSupplier']} - ${item['nama']}' == value,
                              orElse: () => {},
                            );
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildDetailContainer(
                        "ID Supplier",
                        _selectedSupplierDetails?['id']?.toString() ?? '-',
                      ),
                      _buildDetailContainer(
                        "Kode Supplier",
                        _selectedSupplierDetails?['kodeSupplier'] ?? '-',
                      ),
                      _buildDetailContainer(
                        "Telepon",
                        _selectedSupplierDetails?['nomor_handphone'] ?? '-',
                      ),
                      _buildDetailContainer(
                        "Alamat",
                        _selectedSupplierDetails?['alamat'] ?? '-',
                      ),
                    ],
                  );
                },
              ),


              const SizedBox(height: 20),

              // Fish Type Dropdown
              FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchStok(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('Tidak ada data stok tersedia.');
                    } else {
                      List<Map<String, dynamic>> stockData = snapshot.data ??
                          [];
                      return DropdownField<String>(
                        value: _selectedFish,
                        items: stockData.map((item) => item['nama'].toString())
                            .toList(),
                        label: "Pilih Ikan",
                        itemLabel: (item) => item,
                        onChanged: (value) {
                          setState(() {
                            _selectedFish = value;
                            // Ambil kodeProduk berdasarkan nama ikan yang dipilih
                            final selectedProduct = stockData.firstWhere(
                                  (item) => item['nama'] == value,
                            );
                            _selectedProductCode =
                                selectedProduct?['kodeProduk'] ?? '-';
                          });
                        },
                      );
                    }
                  }
              ),


              const SizedBox(height: 20),

              // Fish Variant Dropdown
              FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchVarian(),
                builder: (context, snapshot) {
                  List<Map<String, dynamic>> variantData = snapshot.data ?? [];
                  return DropdownField<String>(
                    value: _selectedFishVariant,
                    items: variantData.map((item) => item['nama'] as String)
                        .toList(),
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

              // Fish Weight Dropdown
              FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchBobot(),
                builder: (context, snapshot) {
                  List<Map<String, dynamic>> bobotData = snapshot.data ?? [];
                  return DropdownField<String>(
                    value: _quantity,
                    items: bobotData.map((item) => item['bobot'] as String)
                        .toList(),
                    label: "Masukkan Bobot Ikan",
                    itemLabel: (item) => item,
                    onChanged: (value) {
                      setState(() {
                        _quantity = value;
                      });
                    },
                  );
                },
              ),

              const SizedBox(height: 20),
              _buildCountField(),
              const SizedBox(height: 20),
              _buildPriceField(),

              const SizedBox(height: 15),
              _buildAddOrderButton(),
              const SizedBox(height: 20),

              const Text("Pesanan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildOrderTable(),
              const SizedBox(height: 10),
              _buildConfirmationButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountField() {
    return TextField(
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          _count = value; // Menyimpan jumlah yang dimasukkan
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

  Widget _buildDetailContainer(String label, String? value) {
    return Container(
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
        "$label: ${value ?? 'Tidak tersedia'}",
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  // Add the order to the list if all fields are filled
  Widget _buildAddOrderButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_selectedFish != null &&
              _selectedFishVariant != null &&
              _quantity != null &&
              _count != null &&
              _price != null) {
            _addOrder();

            // Reset the form after adding the order
            setState(() {
              _selectedFish = null;
              _selectedFishVariant = null;
              _quantity = null;
              _count = null;
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
        'count': _count!,
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
          child: Card(
            elevation: 2,
            color: const Color(0xffFAF9F6),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ID Customer: ${_selectedSupplierDetails?['id'] ?? '-'}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    "Kode Customer: ${_selectedSupplierDetails?['kodeCustomer'] ?? '-'}",
                  ),
                  Text("Nama Customer: ${_selectedSupplier ?? 'Belum dipilih'}"),
                  const SizedBox(height: 8),
                  Text("Jenis Ikan: ${order['fish']}"),
                  Text("Kode Produk (FK): ${order['productCode']}"),
                  Text("Varian Ikan: ${order['variant']}"),
                  Text("Jumlah: ${order['quantity']}"),
                  Text("Harga Total: ${_calculateTotal()}"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildConfirmationButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_selectedSupplier == null || _selectedSupplier!.isEmpty) {
            // Tampilkan peringatan jika supplier belum dipilih
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'Oops...',
              text: 'Silakan pilih supplier terlebih dahulu.',
            );
          } else {
            // Navigasi ke ConfirmationScreen dengan data
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ConfirmationPembelianScreen(
                  customerData: {
                    'Nama Customer': _selectedSupplier ?? 'Unknown', // Berikan nilai default jika _selectedSupplier null
                  },
                  orderList: _orderList.isNotEmpty
                      ? _orderList.map((order) {
                    return {
                      'item': order['fish'] ?? 'Unknown Fish', // Default untuk jenis ikan
                      'variant': order['variant'] ?? 'Unknown Variant', // Default untuk varian
                      'quantity': order['quantity'] ?? 0, // Default untuk jumlah
                      'price': order['price'] ?? 0, // Default untuk harga
                    };
                  }).toList()
                      : [],
                  params: {
                    'Total Harga': _orderList.isNotEmpty ? _calculateTotal() : '0', // Default untuk total harga
                    'Tanggal Transaksi': DateTime.now().toString(), // Contoh data tambahan
                  },
                ),
              ),
            );

          }
        },
        child: const Text("Konfirmasi Transaksi"),
      ),
    );
  }
}

class DropdownField<T> extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String label;
  final Function(String) itemLabel;
  final Function(String?) onChanged;

  const DropdownField({
    Key? key,
    required this.value,
    required this.items,
    required this.label,
    required this.itemLabel,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      onChanged: onChanged,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(itemLabel(item)),
        );
      }).toList(),
    );
  }
}
