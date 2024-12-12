import 'package:flutter/material.dart';
import 'package:ikanapps/backend/nativeChannel.dart';

class PaymentShipmentPage extends StatefulWidget {
  @override
  _PaymentShipmentPageState createState() => _PaymentShipmentPageState();
}

class _PaymentShipmentPageState extends State<PaymentShipmentPage> {
  List<Map<String, dynamic>> orders = [];  // Stores fetched orders

  // Dropdown options for payment and shipment
  List<String> paymentOptions = ['0', '1', '2'];  // Modify as needed
  List<String> shipmentOptions = ['0', '1'];  // Modify as needed

  // Variables to store selected values
  String? selectedPayment;
  String? selectedShipment;

  // Function to fetch order data
  Future<void> fetchGetOrder() async {
    try {
      print("Fetching order data...");
      var produkData = await NativeChannel.instance.fetchGetOrder();  // Fetch orders from the native channel
      print("Data fetched: $produkData");

      setState(() {
        orders = List<Map<String, dynamic>>.from(produkData); // Save data to orders
      });
    } catch (e) {
      print("Error fetching order data: $e");
      setState(() {
        orders = [];  // Set empty if there's an error
      });
    }
  }

  // Base color for styling
  final Color baseColor = Color(0xFF07a0c3);

  // Function to build a card with order data
  Widget _buildCard(int index) {
    final order = orders[index];

    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 5,
      color: baseColor, // Apply the tint of the base color as the card background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Order ID, Name, and other details
            Text('Order ID: ${order['id']}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text('Jumlah Pesanan: ${order['jumlahPesanan']}', style: TextStyle(color: Colors.white)),
            Text('Harga/Kg: ${order['hargaKg']}', style: TextStyle(color: Colors.white)),
            Text('Total Penerimaan: ${order['totalPenerimaan']}', style: TextStyle(color: Colors.white)),
            SizedBox(height: 16), // Spacer between order details and dropdowns

            // Row for Payment and Shipment Dropdowns
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Payment Dropdown
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Payment:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      DropdownButton<String>(
                        value: selectedPayment ?? order['payment'],  // Default value from the fetched data
                        hint: Text('Select Payment', style: TextStyle(color: Colors.white)),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedPayment = newValue;
                          });
                        },
                        items: paymentOptions.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: TextStyle(color: Colors.black)),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                // Shipment Dropdown
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Shipment:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      DropdownButton<String>(
                        value: selectedShipment ?? order['shipment'],  // Default value from the fetched data
                        hint: Text('Select Shipment', style: TextStyle(color: Colors.white)),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedShipment = newValue;
                          });
                        },
                        items: shipmentOptions.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: TextStyle(color: Colors.black)),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchGetOrder(); // Fetch orders when the page is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment and Shipment'),
        backgroundColor: baseColor, // Apply the base color to the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: orders.isEmpty
            ? Center(child: CircularProgressIndicator()) // Show loading while data is being fetched
            : ListView.builder(
          itemCount: orders.length, // Display based on the number of orders
          itemBuilder: (context, index) {
            return _buildCard(index); // Build card for each order
          },
        ),
      ),
    );
  }
}
