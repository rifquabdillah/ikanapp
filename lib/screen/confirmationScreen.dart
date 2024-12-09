import 'package:flutter/material.dart';
import 'package:ikanapps/backend/nativeChannel.dart';

class ConfirmationScreen extends StatelessWidget {
  final Map<String, String> customerData;
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
        {'id': 1.0, 'nama': 'Mas', 'quantity': 100, 'shipment': 'Open', 'payment': 'Belum Lunas', 'bobot': '1 kg 1 ekor'},
        {'id': 2.0, 'nama': 'Lele', 'quantity': 100, 'shipment': 'Proses', 'payment': 'Lunas', 'bobot': '1 kg 2 ekor'},
        {'id': 3205.0, 'nama': 'Nila', 'quantity': 100, 'shipment': 'Kirim', 'payment': 'Selesai', 'bobot': '1 kg 1 ekor'}
      ];

      // Now, pass this data to saveOrder via NativeChannel
      print("Saving order...");
      var produkData = await NativeChannel.instance.saveOrder(
        customerData: customerData,  // Assuming customerData is already correctly initialized
        orderList: orderData,         // Pass the structured order data
        totalHarga: totalHarga,       // Pass the total price
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
        title: const Text('Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Customer Information Section
                  Text(
                    'Customer Details:',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Divider(),
                  Text('Nama Customer: ${customerData['Nama Customer']}'),
                  Text('Item: ${customerData['item']}'),
                  Text('variant: ${customerData['variant']}'),
                  Text('quantity: ${customerData['quantity']}'),
                  Text('price: ${customerData['price']}'),
                  Text('shipment: ${customerData['shipment']}'),
                  Text('payment: ${customerData['payment']}'),
                  const SizedBox(height: 10),

                  // Transaction Details Section (individually displayed parameters)
                  Text(
                    'Transaction Details:',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Divider(),
                  Text('Total Harga: $totalHarga'),
                  Text('Tanggal Transaksi: $tanggalTransaksi'),

                  // Send Data Button
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // Trigger the saveOrder function
                      var result = await saveOrder();
                      if (result.isNotEmpty) {
                        // Show a success message or navigate to another screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Order successfully saved!')),
                        );
                      } else {
                        // Show an error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to save order.')),
                        );
                      }
                    },
                    child: const Text('Send Data'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50), // Full width button
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
}
