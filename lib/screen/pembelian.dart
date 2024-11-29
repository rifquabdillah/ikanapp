import 'package:flutter/material.dart';
import 'confirmationScreen.dart';

class PembelianScreen extends StatefulWidget {
  const PembelianScreen({Key? key}) : super(key: key);

  @override
  State<PembelianScreen> createState() => _PembelianScreenState();
}

class _PembelianScreenState extends State<PembelianScreen> {
  final List<Map<String, String>> _customers = [
    {"name": "Suplier 1", "phone": "08123456789", "address": "Jl. Graha Alam Raya Bandung  No. 1"},
    {"name": "Suplier 2", "phone": "08198765432", "address": "Jl. Graha Alam Raya Bandung No. 2"},
    {"name": "Suplier 3", "phone": "08122334455", "address": "Jl. Graha Alam Raya Bandung No. 3"},
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
        backgroundColor: Color(0xFFd9e6ec),
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
              DropdownField<Map<String, String>>(
                value: _selectedCustomer,
                items: _customers,
                label: "Pilih Supplier",
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), // Mengurangi padding horizontal
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.black54,
                          width: 1,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${_selectedCustomer!['phone']}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), // Mengurangi padding horizontal
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.black54,
                          width: 1,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft, // Menjaga teks tetap di kiri
                        child: Text(
                          "${_selectedCustomer!['address']}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
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
              const SizedBox(height: 20),
              if (_selectedFish != null)
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
              const SizedBox(height: 20),
              if (_selectedFishVariant != null)
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
              const SizedBox(height: 20),
              if (_selectedFishCount != null)
                TextField(
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
                ),
              const SizedBox(height: 20),
              if (_quantity != null)
                TextField(
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
                ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedCustomer != null &&
                        _selectedFish != null &&
                        _selectedFishVariant != null &&
                        _selectedFishCount != null &&
                        _quantity != null) {
                      _addOrder();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Mohon lengkapi semua data!"),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFd9e6ec),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    foregroundColor: Colors.black45,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),
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
              ElevatedButton(
                onPressed: () {
                  if (_orderList.isNotEmpty && _selectedCustomer != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConfirmationScreen(
                          customerData: _selectedCustomer!,
                          orderList: _orderList,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Pastikan ada pesanan dan customer terpilih!"),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFd9e6ec), // Warna latar belakang tombol
                  padding: const EdgeInsets.symmetric(vertical: 16.0), // Padding vertikal
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0), // Sudut tombol melengkung
                  ),
                  foregroundColor: Colors.black45, // Warna teks tombol
                  textStyle: const TextStyle(
                    fontSize: 18, // Ukuran font
                    fontWeight: FontWeight.bold, // Berat font
                    fontFamily: 'Montserrat', // Menetapkan font keluarga
                  ),
                ),
                child: const Text("Checkout Transaksi"),
              )
            ],
          ),
        ),
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
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      ),
    );
  }

  Widget _buildOrderTable() {
    if (_orderList.isEmpty) {
      return const Center(child: Text("Belum ada pesanan."));
    }

    return Column(
      children: _orderList.map((order) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            title: Text(order['fish']!),
            subtitle: Text("Varian: ${order['variant']} - Jumlah: ${order['quantity']}"),
            trailing: Text("Bobot: ${order['weight']}"),
          ),
        );
      }).toList(),
    );
  }

  void _addOrder() {
    setState(() {
      _orderList.add({
        'customer': _selectedCustomer!['name']!,
        'fish': _selectedFish!,
        'variant': _selectedFishVariant!,
        'weight': _selectedFishCount!,
        'quantity': _quantity!,
        'price': _price ?? "0", // Menyimpan harga jika diisi
      });
      _selectedFish = null;
      _selectedFishVariant = null;
      _selectedFishCount = null;
      _quantity = null;
      _price = null; // Reset harga setelah menambah pesanan
    });
  }

  void _processTransaction() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Transaksi selesai!")),
    );
    setState(() {
      _orderList.clear();
      _selectedCustomer = null; // Reset customer setelah transaksi selesai
    });
  }
}
