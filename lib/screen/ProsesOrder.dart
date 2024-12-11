import 'package:flutter/material.dart';

class PaymentShipmentPage extends StatefulWidget {
  @override
  _PaymentShipmentPageState createState() => _PaymentShipmentPageState();
}

class _PaymentShipmentPageState extends State<PaymentShipmentPage> {
  // Sample data for payment and shipment options
  final List<String> paymentOptions = ['Credit Card', 'Cash', 'PayPal'];
  final List<String> shipmentOptions = ['Standard Shipping', 'Express Shipping', 'Next Day Delivery'];

  // Selected values for each dropdown
  String? selectedPayment;
  String? selectedShipment;

  // Sample order data
  final String orderId = "123456";
  final String orderName = "Fresh Fish Order";
  final String orderAddress = "123 Ocean Drive, Beach City";

  // Base color for styling
  final Color baseColor = Color(0xFF07a0c3);

  // Function to build a card with dropdowns
  Widget _buildCard(int index) {
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
            // Display Order ID, Name, and Address
            Text('Order ID: $orderId', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text('Order Name: $orderName', style: TextStyle(color: Colors.white)),
            Text('Order Address: $orderAddress', style: TextStyle(color: Colors.white)),
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
                        value: selectedPayment,
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
                        value: selectedShipment,
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment and Shipment'),
        backgroundColor: baseColor, // Apply the base color to the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: ListView.builder(
          itemCount: 5, // Number of cards to display
          itemBuilder: (context, index) {
            return _buildCard(index);
          },
        ),
      ),
    );
  }
}

