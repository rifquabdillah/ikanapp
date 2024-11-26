import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> orderList;
  final Map<String, String> customerData; // Parameter untuk data pelanggan

  const OrderHistoryScreen({Key? key, required this.orderList, required this.customerData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Daftar Orderan"),
        centerTitle: true,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Menampilkan daftar orderan
              if (orderList.isNotEmpty)
                Column(
                  children: orderList.map((order) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        elevation: 2,
                        color: const Color(0xffFAF9F6),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Sebelah Kiri: Nama Customer, Jenis Ikan, Varian Ikan, Status Pengiriman
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Nama Customer
                                    Text(
                                      customerData['name'] ?? 'Unknown', // Menampilkan nama customer dari customerData
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // Nama Ikan
                                    Text(
                                      order['fish'] ?? 'Unknown', // Nama ikan
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // Varian Ikan
                                    Text(
                                      order['variant'] ?? 'No variant', // Varian ikan
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // Status Pengiriman
                                    Row(
                                      children: [
                                        const Text(
                                          'Pengiriman: ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          _getShipmentStatus(order['shipment'] ?? 'Proses'),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w400,
                                            color: _getShipmentColor(order['shipment'] ?? ''),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Sebelah Kanan: Jumlah yang dibeli
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Jumlah: ${order['quantity'] ?? '0'}', // Jumlah ikan
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Bobot: ${order['weight'] ?? '0'}', // Bobot ikan
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xffECB709),
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )
              else
                const Center(child: Text("Tidak ada order yang tersedia.")),
            ],
          ),
        ),
      ),
    );
  }

  // Membuat row informasi
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

  // Menentukan warna untuk status pengiriman
  Color _getShipmentColor(String shipment) {
    switch (shipment.toLowerCase()) {
      case 'open':
        return Colors.green;
      case 'proses':
        return Colors.grey;
      case 'kirim':
        return Colors.orange;
      case 'diterima':
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  // Menentukan status pengiriman berdasarkan value
  String _getShipmentStatus(String shipment) {
    switch (shipment.toLowerCase()) {
      case 'open':
        return 'Open';
      case 'proses':
        return 'Proses';
      case 'kirim':
        return 'Kirim';
      case 'diterima':
        return 'Diterima';
      default:
        return 'Status tidak diketahui';
    }
  }
}
