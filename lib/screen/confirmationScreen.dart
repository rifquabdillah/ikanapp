import 'package:flutter/material.dart';
import 'detailOrder.dart';

class ConfirmationScreen extends StatelessWidget {
  final Map<String, String> customerData;
  final List<Map<String, String>> orderList;

  const ConfirmationScreen({
    Key? key,
    required this.customerData,
    required this.orderList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Konfirmasi Order"),
        centerTitle: true,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Informasi Pelanggan"),
              _buildCustomerInfo(),
              const SizedBox(height: 20),
              _buildSectionTitle("Daftar Pesanan"),
              if (orderList.isNotEmpty) _buildOrderList(),
              if (orderList.isEmpty)
                const Center(child: Text("Belum ada pesanan.")),
              const SizedBox(height: 20),
              _buildConfirmButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
      ),
    );
  }

  Widget _buildCustomerInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow("Nama", customerData['nama']),
        _buildInfoRow("Telepon", customerData['phone']),
        _buildInfoRow("Alamat", customerData['address']),
      ],
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label:",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value ?? "-",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList() {
    return Column(
      children: orderList.map((order) {
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Menambahkan nama customer di sini
                Text(
                  customerData['nama'] ?? 'Nama tidak tersedia', // Menampilkan nama customer
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                // Nama Ikan
                Text(
                  order['fish']!,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            subtitle: Text(
              "Varian: ${order['variant']} - Jumlah: ${order['quantity']}",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            trailing: Text(
              "Bobot: ${order['weight']}",
              style: TextStyle(color: Colors.teal),
            ),
          ),
        );
      }).toList(),
    );
  }


  Widget _buildConfirmButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          // Navigasi ke halaman OrderHistory setelah konfirmasi
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderHistoryScreen(
                orderList: orderList, customerData: {}, // Mengirimkan daftar order yang ada
              ),
            ),
          );
        },
        child: const Text(
          "Order",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
