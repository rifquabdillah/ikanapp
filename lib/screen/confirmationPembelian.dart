import 'package:flutter/material.dart';

class ConfirmationPembelianScreen extends StatelessWidget {
  final Map<String, dynamic> params;
  final Map<String, dynamic> customerData;
  final List<dynamic> orderList;

  const ConfirmationPembelianScreen({
    Key? key,
    required this.params,
    required this.customerData,
    required this.orderList,
  }) : super(key: key);

  Widget _buildTransactionDetails() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Transaction Details",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 8.0),
          ...params.entries.map((entry) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                entry.key,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14.0,
                ),
              ),
              Text(
                entry.value.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Konfirmasi Pembelian"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer Data Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Customer Information",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ...customerData.entries.map((entry) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        entry.value.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Transaction Details Section
            _buildTransactionDetails(),

            const SizedBox(height: 16.0),

            // Order List Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order List",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ...orderList.map((order) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        order['item'],
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        order['price'].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),

            const SizedBox(height: 24.0),

            // Confirm Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add confirmation logic here
                  print("Confirmed transaction with params: $params");
                },
                child: const Text("Confirm Transaction"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
