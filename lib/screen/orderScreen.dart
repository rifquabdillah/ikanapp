import 'package:flutter/material.dart';
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
    {"name": "Customer 1", "phone": "08123456789", "address": "Jl. Graha Alam Raya Bandung  No. 1"},
    {"name": "Customer 2", "phone": "08198765432", "address": "Jl. Graha Alam Raya Bandung No. 2"},
    {"name": "Customer 3", "phone": "08122334455", "address": "Jl. Graha Alam Raya Bandung No. 3"},
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
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black54),
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
        border: const OutlineInputBorder(),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF2464a2),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      foregroundColor: Color(0xffd3e0ec),
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

  void _processTransaction() {
    final stockProvider = Provider.of<StockProvider>(context, listen: false);
    for (var order in _orderList) {
      final fishName = order['fish']!;
      final quantity = int.tryParse(order['quantity']!) ?? 0;
      stockProvider.reduceStock(fishName, quantity);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Transaksi selesai!")),
    );
    setState(() {
      _orderList.clear();
      _selectedCustomer = null;
    });
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
}

class DropdownField<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String label;
  final bool isEnabled;
  final ValueChanged<T?>? onChanged;
  final String Function(T) itemLabel;

  const DropdownField({
    required this.value,
    required this.items,
    required this.label,
    this.onChanged,
    required this.itemLabel,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      child: DropdownButton<T>(
        isExpanded: true,
        value: value,
        items: items
            .map((item) => DropdownMenuItem<T>(
          value: item,
          child: Text(itemLabel(item)),
        ))
            .toList(),
        onChanged: isEnabled ? onChanged : null,
        underline: const SizedBox(),
        isDense: true,
      ),
    );
  }
}
