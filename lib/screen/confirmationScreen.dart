import 'package:flutter/material.dart';
import 'package:ikanapps/backend/nativeChannel.dart';
import 'package:intl/intl.dart';

class ConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic> customerData;
  final String totalHarga;
  final String tanggalTransaksi;

  ConfirmationScreen({
    required this.customerData,
    required this.totalHarga,
    required this.tanggalTransaksi,
  });

  Future<List> saveOrder() async {
    try {
      // Simulating the fetched data
      List<Map<String, dynamic>> orderData = [
        {'id': 1, 'nama': 'Mas', 'quantity': 100, 'shipment': 'Open', 'payment': 'Belum Lunas', 'bobot': '1 kg 1 ekor', 'hargaKg': 20000.0},
        {'id': 2, 'nama': 'Lele', 'quantity': 100, 'shipment': 'Proses', 'payment': 'Lunas', 'bobot': '1 kg 2 ekor', 'hargaKg': 25000.0},
        {'id': 3205, 'nama': 'Nila', 'quantity': 100, 'shipment': 'Kirim', 'payment': 'Selesai', 'bobot': '1 kg 1 ekor', 'hargaKg': 30000.0},
      ];

      // Calculate total price
      double totalHarga = 0.0;
      for (var order in orderData) {
        // Use null-aware operators and default values
        double jumlahPesanan = (order['quantity'] ?? 0).toDouble();
        double hargaKg = (order['hargaKg'] ?? 0.0).toDouble();
        totalHarga += jumlahPesanan * hargaKg;
      }

      // Format totalHarga as Rupiah
      String formattedTotalHarga = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(totalHarga);

      // Print formatted total price
      print('Total Harga: $formattedTotalHarga');

      // Now, pass this data to saveOrder via NativeChannel
      print("Saving order...");
      var produkData = await NativeChannel.instance.saveOrder(
        customerData: customerData,  // Assuming customerData is already correctly initialized
        orderList: orderData,         // Pass the structured order data
        totalHarga: totalHarga.toString(),      // Pass the total price
        tanggalTransaksi: tanggalTransaksi, // Pass the transaction date
      );

      print("Order saved successfully: $produkData");
      return produkData as List;
    } catch (e) {
      print("Error saving order: $e");
      return [];  // Return empty list on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Confirmation'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 10.0, // Increased shadow for a modern look
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Rounded corners
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Customer Information Section
                  Text(
                    'Customer Details:',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal, // Trendy teal color
                    ),
                  ),
                  const Divider(),
                  _buildCustomerInfo(),  // Build customer info with dynamic handling

                  const SizedBox(height: 20),

                  // Transaction Details Section (individually displayed parameters)
                  Text(
                    'Transaction Details:',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const Divider(),
                  _buildTransactionInfo(),

                  // Send Data Button
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      var result = await saveOrder();
                      if (result.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Order successfully saved!')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to save order.')),
                        );
                      }
                    },
                    child: const Text('Send Data'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.teal, foregroundColor: Colors.white,// Matching the button with the theme
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded button
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Customer info widget to avoid code repetition
  Widget _buildCustomerInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCustomerRow('Nama Customer:', customerData['Nama Customer']),
        _buildItemsInfo(),  // Display items dynamically
      ],
    );
  }

  // Helper widget for customer row
  Widget _buildCustomerRow(String label, dynamic value) {
    Color paymentStatusColor = Colors.black87; // Default color
    Color shipmentStatusColor = Colors.black87; // Default color

    // Check if it's payment or shipment label and update the respective colors
    if (label == 'Payment:') {
      paymentStatusColor = _getPaymentColor(value);
    } else if (label == 'Shipment:') {
      shipmentStatusColor = _getShipmentColor(value);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Text(
            value?.toString() ?? 'Unknown',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: "Montserrat",
              color: label == 'Payment:' ? paymentStatusColor : shipmentStatusColor,
            ),
          ),
        ],
      ),
    );
  }


  // Display items information dynamically
  Widget _buildItemsInfo() {
    var items = customerData['items'];

    // Debugging: Print the content of 'items'
    print('Items: $items');

    if (items is List) {
      // Only process if it's a list
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map<Widget>((item) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCustomerRow('Item:', item['fish']),
              _buildCustomerRow('Variant:', item['variant']),
              _buildCustomerRow('Quantity:', item['quantity']),
              _buildCustomerRow('Jumlah:', item['jumlahPesanan']),
              _buildCustomerRow('Harga per Kg:', item['hargaKg']),

              // Payment: Check status and color accordingly
              _buildCustomerRow(
                'Payment:',
                item['payment'],
              ),
              // Shipment: Check status and color accordingly
              _buildCustomerRow(
                'Shipment:',
                item['shipment'],
              ),
              const Divider(),
            ],
          );
        }).toList(),
      );
    } else {
      // If it's not a list, show a fallback message
      return const Text('No items available');
    }
  }

  // Function to determine the payment status color
  Color _getPaymentColor(String paymentStatus) {
    if (paymentStatus == 'Belum Lunas') {
      return Colors.red;  // Red for "Belum Lunas"
    } else if (paymentStatus == 'Lunas' || paymentStatus == 'Selesai') {
      return Colors.green; // Green for "Lunas" and "Selesai"
    } else {
      return Colors.black87;  // Default color
    }
  }

  // Function to determine the shipment status color
  Color _getShipmentColor(String shipmentStatus) {
    if (shipmentStatus == 'Open') {
      return Colors.blue;  // Blue for "Open"
    } else if (shipmentStatus == 'Proses') {
      return Colors.orange;  // Orange for "Proses"
    } else if (shipmentStatus == 'Diterima') {
      return Colors.green;  // Green for "Diterima"
    } else {
      return Colors.black87;  // Default color
    }
  }

  // Transaction info widget to avoid code repetition
  Widget _buildTransactionInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTransactionRow('Total Harga:', totalHarga),  // Display totalHarga here
        _buildTransactionRow('Tanggal:', tanggalTransaksi),
      ],
    );
  }

  // Helper widget for transaction row
  Widget _buildTransactionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
