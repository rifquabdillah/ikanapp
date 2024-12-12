import 'package:flutter/material.dart';
import 'package:ikanapps/backend/nativeChannel.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
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
  String? _quantity;
  String? jumlahPesanan;
  String? hargaKg;
  String? totalPenerimaan;
  String? piutang;
  String? aging;
  String? _selectedProductCode;
  String? _selectedShipment;
  String? _selectedPayment;
  bool isOrderAdded = false;


  List<String> _fishVariants = [];
  final List<Map<String, String>> _orderList = [];
  List<Map<String, dynamic>> suppliersData = [];
  Map<String, dynamic>? _selectedCustomerDetails;


  Future<List<Map<String, dynamic>>> fetchCustomer() async {
    try {
      print("Fetching customer data...");
      var produkData = await NativeChannel.instance.fetchCustomer();
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

  Future<List<Map<String, dynamic>>> fetchShipment() async {
    try {
      print("Fetching fish weight data...");
      var produkData = await NativeChannel.instance.fetchShipment();
      print("Data fetched: $produkData");
      return produkData;
    } catch (e) {
      print("Error fetching data: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchPayment() async {
    try {
      print("Fetching fish weight data...");
      var produkData = await NativeChannel.instance.fetchPayment();
      print("Data fetched: $produkData");
      return produkData;
    } catch (e) {
      print("Error fetching data: $e");
      return [];
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF07a0c3),
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
                future: fetchCustomer(), // Fetch customer data
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  List<Map<String, dynamic>> customerData = snapshot.data ?? [];
                  if (customerData.isEmpty) {
                    return const Center(child: Text('No customers available'));
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dropdown for selecting customer
                      DropdownField<String>(
                        value: _selectedSupplier,
                        items: customerData.map((item) {
                          return '${item['id']} - ${item['nama']}'; // Display customer ID and name
                        }).toList(),
                        label: "Pilih Customer",
                        itemLabel: (item) => item,
                        onChanged: isOrderAdded
                            ? (_) {} // No-op function when order is added
                            : (value) {
                          setState(() {
                            _selectedSupplier = value;
                            _selectedCustomerDetails = customerData.firstWhere(
                                  (item) =>
                              '${item['id']} - ${item['nama']}' == value,
                              orElse: () => {},
                            );
                          });
                        },
                      ),

                      const SizedBox(height: 10),

                      // Button to add new customer
                      // Button to add new customer
                      ElevatedButton(
                        onPressed: () async {
                          final result = await showModalBottomSheet<
                              Map<String, dynamic>>(
                            context: context,
                            isScrollControlled: true,
                            // Allow the modal to expand for inputs
                            builder: (_) => _AddCustomerBottomSheet(),
                          );

                          // Reload customer data if a new customer is added
                          if (result != null) {
                            setState(() {
                              customerData.add(
                                  result); // Add new customer to the list
                              _selectedSupplier =
                              '${result['id']} - ${result['nama']}';
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0690b0),
                          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          foregroundColor: const Color(0xffe9f0f6),
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        child: const Text("Tambah Customer"),
                      ),


                      // Check if the customer details are available and show the details card
                      if (_selectedCustomerDetails != null &&
                          _selectedCustomerDetails!.isNotEmpty)
                        _buildDetailCard(),
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
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('Tidak ada data stok tersedia.');
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
                                selectedProduct['kodeProduk'] ?? '-';
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
              const SizedBox(height: 20),
              _buildTotalPenerimaanField(),
              const SizedBox(height: 20),
              _buildPiutangField(),
              const SizedBox(height: 20),
              _buildAgingField(),
              const SizedBox(height: 20),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchShipment(),
                builder: (context, snapshot) {
                  List<Map<String, dynamic>> shipmentData = snapshot.data ?? [];
                  return DropdownField<String>(
                    value: _selectedShipment,
                    items: shipmentData
                        .map((item) =>
                    item['shipment'] ?? 'Unknown') // Ensure it's a String
                        .toList()
                        .cast<String>(),
                    // Cast the List<dynamic> to List<String>
                    label: "Shipment",
                    itemLabel: (item) => item,
                    // Assuming you want to display the shipment text
                    onChanged: (value) {
                      setState(() {
                        _selectedShipment = value;
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchPayment(),
                builder: (context, snapshot) {
                  List<Map<String, dynamic>> paymentData = snapshot.data ?? [];
                  return DropdownField<String>(
                    value: _selectedPayment,
                    items: paymentData
                        .map((item) =>
                    item['payment'] ?? 'Unknown') // Ensure it's a String
                        .toList()
                        .cast<String>(),
                    // Cast the List<dynamic> to List<String>
                    label: "Payment",
                    itemLabel: (item) => item,
                    // Assuming you want to display the shipment text
                    onChanged: (value) {
                      setState(() {
                        _selectedPayment = value;
                      });
                    },
                  );
                },
              ),
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

  Widget _buildDetailCard() {
    return Card(
      elevation: 5,
      // Menambahkan bayangan agar lebih menarik
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Rounded corners untuk tampilan lebih modern
      ),
      color: const Color(0xff51bdd5),
      // Warna background putih agar lebih bersih
      child: Padding(
        padding: const EdgeInsets.all(0.0), // Padding di dalam Card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // Menyusun elemen dari kiri ke kanan
          children: [
            _buildDetailContainer("ID Customer",
                _selectedCustomerDetails?['id']?.toString() ?? '-'),
            _buildDetailContainer(
                "Nama Customer", _selectedCustomerDetails?['nama'] ?? '-'),
            _buildDetailContainer(
                "Telepon", _selectedCustomerDetails?['telepon'] ?? '-'),
            _buildDetailContainer(
                "Telepon 2", _selectedCustomerDetails?['telepon2'] ?? '-'),
            _buildDetailContainer(
                "Alamat", _selectedCustomerDetails?['alamat'] ?? '-'),
          ],
        ),
      ),
    );
  }


  Widget _buildCountField() {
    return TextField(
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          jumlahPesanan = value; // Menyimpan jumlah yang dimasukkan
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
          hargaKg = value;
        });
      },
      decoration: const InputDecoration(
        labelText: "Harga (per kg)",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildTotalPenerimaanField() {
    return TextField(
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          totalPenerimaan = value; // Menyimpan jumlah yang dimasukkan
        });
      },
      decoration: const InputDecoration(
        labelText: "Total Penerimaan",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPiutangField() {
    return TextField(
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          piutang = value; // Menyimpan jumlah yang dimasukkan
        });
      },
      decoration: const InputDecoration(
        labelText: "Piutang",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildAgingField() {
    return TextField(
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          aging = value; // Menyimpan jumlah yang dimasukkan
        });
      },
      decoration: const InputDecoration(
        labelText: "Aging",
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
              jumlahPesanan != null &&
              totalPenerimaan !=null &&
              piutang !=null &&
              aging !=null &&
              hargaKg != null) {
            _addOrder();

            // Set the flag to lock the customer dropdown
            // Reset all fields except the customer dropdown
            setState(() {
              _selectedFish = null;
              _selectedFishVariant = null;
              _quantity = null;
              jumlahPesanan = null;
              hargaKg = null;
              totalPenerimaan = null;
              piutang = null;
              aging = null;
              _selectedShipment = null;
              _selectedPayment = null;
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Mohon lengkapi semua data!")),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0690b0),
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
        'jumlahPesanan': jumlahPesanan!,
        'hargaKg': hargaKg!,
        'totalPenerimaan': totalPenerimaan!,
        'piutang': piutang!,
        'aging': aging!,
        'shipment': _selectedShipment!,
        'payment': _selectedPayment!,

      });
    });
  }

  Widget _buildOrderTable() {
    if (_orderList.isEmpty) {
      return const Center(child: Text("Belum ada pesanan.",
          style: TextStyle(fontSize: 18, color: Colors.grey)));
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: _orderList.length,
      itemBuilder: (context, index) {
        final order = _orderList[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  15), // Rounded corners for modern look
            ),
            color: const Color(0xffFAF9F6),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title/Heading
                  const SizedBox(height: 8),
                  const Divider(),
                  // Product Information Section
                  _buildDetailRow("Nama Produk", order['fish'] ?? '-'),
                  _buildDetailRow("Varian Produk", order['variant'] ?? '-'),
                  // Order Information Section
                  _buildDetailRow("Jumlah Pesanan",
                      order['jumlahPesanan']?.toString() ?? '-'),
                  _buildDetailRow(
                      "Harga per Kg", order['hargaKg']?.toString() ?? '-'),
                  _buildDetailRow(
                      "Total Penerimaan", order['totalPenerimaan']?.toString() ?? '-'),
                  _buildDetailRow(
                      "Piutang", order['piutang']?.toString() ?? '-'),
                  _buildDetailRow(
                      "Aging", order['aging']?.toString() ?? '-'),
                  _buildStatusRow("Shipment", order['shipment'] ?? '-'),
                  _buildStatusRow("Payment", order['payment'] ?? '-'),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    Color statusColor = Colors.black87;

    // Apply color based on status (e.g., Payment, Shipment)
    if (label == "Payment") {
      statusColor = value == "Lunas" ? Colors.green : Colors.red;
    } else if (label == "Shipment") {
      statusColor = value == "Open" ? Colors.blue : (value == "Proses"
          ? Colors.orange
          : Colors.green);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: statusColor),
          ),
        ],
      ),
    );
  }

  _buildDetailContainer(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      // Padding vertical untuk jarak antar item
      child: Card(
        elevation: 5, // Menambahkan bayangan agar lebih menarik
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              12), // Rounded corners untuk tampilan lebih modern
        ),
        color: Colors.white, // Warna background putih agar lebih bersih
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
          // Padding di dalam Card
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // Menempatkan label dan value di sisi yang berbeda
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(
                      0xff06809c), // Menggunakan warna yang sesuai dengan tema
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Montserrat",
                  color: Colors.black87, // Warna teks nilai
                ),
              ),
            ],
          ),
        ),
      ),
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
                builder: (context) {
                  // Menghitung total harga
                  double totalHarga = 0.0;
                  for (var order in _orderList) {
                    double jumlahPesanan = double.tryParse(
                        order['jumlahPesanan'].toString()) ?? 0.0;
                    double hargaKg = double.tryParse(
                        order['hargaKg'].toString()) ?? 0.0;
                    totalHarga += jumlahPesanan * hargaKg;
                  }
                  // Format totalHarga as Rupiah
                  String formattedTotalHarga = NumberFormat.currency(
                      locale: 'id_ID', symbol: 'Rp ').format(totalHarga);
                  print('Total Harga: $formattedTotalHarga');

                  // Kirim data secara terpisah tanpa pembungkus
                  return ConfirmationScreen(
                    selectedCustomerDetails: _selectedCustomerDetails,
                    orderList: _orderList,
                    totalHarga: formattedTotalHarga

                  );
                },
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0690b0),
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
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xff046075), // Warna teks label
        ),
        filled: true, // Latar belakang field diwarnai
        fillColor: const Color(0xFFffffff), // Warna latar belakang
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Sudut border melengkung
          borderSide: const BorderSide(
            color: Color(0xff046075), // Warna border
            width: 2, // Ketebalan border
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xff046075), // Warna border saat fokus
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xff046075), // Warna border saat tidak fokus
            width: 1.5,
          ),
        ),
      ),
      style: const TextStyle(
        fontSize: 14, // Ukuran teks dropdown
        color: Colors.black87, // Warna teks dropdown
      ),
      dropdownColor: const Color(0xFFF0F4FF), // Warna latar belakang dropdown
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Color(0xff02303a), // Warna ikon dropdown
      ),
      onChanged: onChanged,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            itemLabel(item),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
              color: Color(0xff011013), // Warna teks setiap item
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _AddCustomerBottomSheet extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  final TextEditingController _telepon2Controller = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard visibility
        top: 16,
        left: 16,
        right: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Customer Name',
              border: OutlineInputBorder(),
            ),
          ),
          TextField(
            controller: _teleponController,
            decoration: const InputDecoration(
              labelText: 'Telepon',
              border: OutlineInputBorder(),
            ),
          ),
          TextField(
            controller: _telepon2Controller,
            decoration: const InputDecoration(
              labelText: 'Telepon',
              border: OutlineInputBorder(),
            ),
          ),
          TextField(
            controller: _alamatController,
            decoration: const InputDecoration(
              labelText: 'Alamat',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              String customerName = _nameController.text;
              if (customerName.isNotEmpty) {
                // Handle saving the new customer
                // For now, just show a confirmation message and close the bottom sheet
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added customer: $customerName')),
                );
                Navigator.pop(context); // Close the bottom sheet
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a customer name')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
