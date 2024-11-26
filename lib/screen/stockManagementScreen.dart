import 'package:flutter/material.dart';

class StockManagementScreen extends StatelessWidget {
  const StockManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manajemen Stok")),
      body: Center(child: const Text("Halaman untuk manajemen stok ikan.")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Tambahkan stok baru
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
