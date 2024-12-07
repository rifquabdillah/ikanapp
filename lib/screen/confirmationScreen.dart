import 'dart:math';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:intl/intl.dart'; // Import intl

class ConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic> customerData; // Change to Map<String, dynamic>
  final List<Map<String, String>> orderList;

  const ConfirmationScreen({
    Key? key,
    required this.customerData,
    required this.orderList,
  }) : super(key: key);

  // Function to generate order ID automatically
  String _generateOrderId() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;  // Use timestamp for uniqueness
    final randomSuffix = random.nextInt(1000);  // Adding random suffix
    return 'MJL-${timestamp.toString()}-${randomSuffix.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    final orderId = _generateOrderId();

    String shipmentStatus = orderList.isNotEmpty && orderList.first['shipmentStatus'] != null
        ? orderList.first['shipmentStatus']!
        : 'Unknown';
    String paymentStatus = orderList.isNotEmpty && orderList.first['paymentStatus'] != null
        ? orderList.first['paymentStatus']!
        : 'Unknown';

    final updatedCustomerData = Map<String, dynamic>.from(customerData)
      ..['orderId'] = orderId;  // Add orderId to customerData

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
              _buildCustomerInfo(updatedCustomerData),
              const SizedBox(height: 20),
              _buildSectionTitle("Daftar Pesanan"),
              if (orderList.isNotEmpty) _buildOrderList(shipmentStatus, paymentStatus),
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
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
      ),
    );
  }

  Widget _buildCustomerInfo(Map<String, dynamic> customerData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow("ID Order", customerData['orderId']),
        _buildInfoRow("Nama", customerData['customerName']),
        _buildInfoRow("Telepon", customerData['telepon']),
        _buildInfoRow("Telepon", customerData['telepon2']),
        _buildInfoRow("Alamat", customerData['alamat']),
        _buildInfoRow("Patokan", customerData['patokan']),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
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
            value?.toString() ?? "-",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(String shipmentStatus, String paymentStatus) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            ...orderList.map((order) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order['fish'] ?? "Unknown Fish",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        Text(
                          "${order['quantity']} Kg",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${order['variant'] ?? 'None'}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "${order['weight'] ?? 'Unknown'}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Rp.${NumberFormat('###0', 'id_ID').format(double.tryParse(order['price'] ?? '0.00') ?? 0.0)}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            const Divider(color: Colors.grey),
            const SizedBox(height: 8),
            // Total Harga
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Harga:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
                Text(
                  "Rp.${NumberFormat('###0', 'id_ID').format(orderList.fold(0.0, (total, order) {
                    final price = double.tryParse(order['price'] ?? '0') ?? 0.0;
                    final quantity = double.tryParse(order['quantity'] ?? '1') ?? 1;
                    return total + (price * quantity);
                  }))}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          backgroundColor: Colors.teal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        onPressed: () async {
          // Show loading dialog
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );

          // Simulate delay (like network request)
          await Future.delayed(const Duration(seconds: 2));

          // Dismiss loading dialog
          Navigator.pop(context);

          // Show QuickAlert success dialog
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: 'Order Berhasil',
            text: 'Pesanan telah berhasil dilakukan',
            confirmBtnText: 'OK',
            onConfirmBtnTap: () {
              Navigator.pop(context); // Close the QuickAlert dialog
              // Navigate to the OrderHistoryScreen
              Navigator.pushReplacementNamed(context, '/orderHistoryScreen');
            },
          );
        },
        child: const Text(
          'Order',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontFamily: 'Montserrat',
          ),
        ),
      ),
    );
  }
}
