import 'package:flutter/material.dart';
import 'package:ikanapps/backend/nativeChannel.dart';

class StockManagementScreen extends StatefulWidget {
  const StockManagementScreen({Key? key}) : super(key: key);

  @override
  _StockManagementScreenState createState() => _StockManagementScreenState();
}

class _StockManagementScreenState extends State<StockManagementScreen> {
  late Future<List<Map<String, dynamic>>> _futureStock;
  List<Map<String, dynamic>> _stockList = [];

  @override
  void initState() {
    super.initState();
    _futureStock = fetchStock();
  }

  Future<List<Map<String, dynamic>>> fetchStock() async {
    try {
      var produkData = await NativeChannel.instance.fetchStok();
      return produkData.map((stock) {
        return {
          "nama": stock['nama'],
          "quantity": int.tryParse(stock['quantity'].toString()) ?? 0,
        };
      }).toList();
    } catch (e) {
      debugPrint("Error fetching stock data: $e");
      return [];
    }
  }



  void _editStock(int index, String newName, int newQuantity) {
    setState(() {
      _stockList[index]['nama'] = newName;
      _stockList[index]['quantity'] = newQuantity;
    });
  }

  void _showStockDialog({
    required String title,
    String? initialName,
    int? initialQuantity,
    required void Function(String, int) onSubmit,
  }) {
    final nameController = TextEditingController(text: initialName ?? '');
    final quantityController =
    TextEditingController(text: initialQuantity?.toString() ?? '');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nama Ikan"),
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: "Jumlah (Kg)"),
                keyboardType: TextInputType.number,
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
                final name = nameController.text.trim();
                final quantity = int.tryParse(quantityController.text.trim());
                if (name.isNotEmpty && quantity != null && quantity > 0) {
                  onSubmit(name, quantity);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Masukkan data yang valid!")),
                  );
                }
              },
              child: const Text("Simpan"),
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
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _futureStock,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Terjadi kesalahan: ${snapshot.error}"),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Belum ada data stok."));
            }

            _stockList = snapshot.data!; // Simpan data ke state lokal
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Daftar Stok",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: _stockList.length,
                    itemBuilder: (context, index) {
                      final stock = _stockList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(
                            stock['nama'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(
                            "${stock['quantity']} Kg",
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () => _showStockDialog(
                            title: "Edit Stok",
                            initialName: stock['nama'],
                            initialQuantity: stock['quantity'],
                            onSubmit: (newName, newQuantity) =>
                                _editStock(index, newName, newQuantity),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
