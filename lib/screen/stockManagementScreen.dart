import 'package:flutter/material.dart';

class StockManagementScreen extends StatefulWidget {
  const StockManagementScreen({Key? key}) : super(key: key);

  @override
  _StockManagementScreenState createState() => _StockManagementScreenState();
}

class _StockManagementScreenState extends State<StockManagementScreen> {
  final List<Map<String, dynamic>> _stockList = [
    {"fish": "Ikan Lele", "quantity": 100},
    {"fish": "Ikan Nila", "quantity": 50},
    {"fish": "Ikan Gurame", "quantity": 30},
  ];

  void _addStock(String fishName, int quantity) {
    setState(() {
      final index = _stockList.indexWhere((stock) => stock['fish'] == fishName);
      if (index >= 0) {
        _stockList[index]['quantity'] += quantity;
      } else {
        _stockList.add({"fish": fishName, "quantity": quantity});
      }
    });
  }

  void _reduceStock(String fishName, int quantity) {
    setState(() {
      final index = _stockList.indexWhere((stock) => stock['fish'] == fishName);
      if (index >= 0) {
        _stockList[index]['quantity'] -= quantity;
        if (_stockList[index]['quantity'] < 0) {
          _stockList[index]['quantity'] = 0;
        }
      }
    });
  }

  void _showAddStockDialog() {
    String? fishName;
    int? quantity;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Tambah Stok"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Nama Ikan"),
                onChanged: (value) {
                  fishName = value.trim();
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Jumlah (Kg)"),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  quantity = int.tryParse(value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                if (fishName != null && fishName!.isNotEmpty && quantity != null && quantity! > 0) {
                  _addStock(fishName!, quantity!);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Masukkan data yang valid!")),
                  );
                }
              },
              child: const Text("Tambah"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manajemen Stok"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Daftar Stok",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _stockList.isNotEmpty
                  ? ListView.builder(
                itemCount: _stockList.length,
                itemBuilder: (context, index) {
                  final stock = _stockList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        stock['fish'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        "${stock['quantity']} Kg",
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              )
                  : const Center(
                child: Text("Belum ada data stok."),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddStockDialog,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }
}
