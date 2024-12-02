import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatelessWidget {
  final Map<String, String> customerData;
  final List<Map<String, String>> orderList;

  const OrderHistoryScreen({
    Key? key,
    required this.customerData,
    required this.orderList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String shipmentStatus = orderList.isNotEmpty
        ? orderList.first['shipmentStatus'] ?? 'Unknown'
        : 'Unknown';
    String paymentStatus = orderList.isNotEmpty
        ? orderList.first['paymentStatus'] ?? 'Unknown'
        : 'Unknown';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Riwayat Order"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          customerData['name'] ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        Text(
                          " ${customerData['orderId'] ?? 'Unknown'}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${customerData['address'] ?? 'Unknown'}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...orderList.map((order) {
                      return ExpansionTile(
                        title: Row(
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
                        children: [
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
                                "${order['Bobot']}",
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
                          const Divider(color: Colors.grey),
                          const SizedBox(height: 8),
                        ],
                      );
                    }).toList(),

                    const Divider(color: Colors.grey),
                    const SizedBox(height: 8),

                    // Status pengiriman dan pembayaran hanya ditampilkan sekali
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Shipment Status: ",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        Text(
                          shipmentStatus,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Payment Status: ",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        Text(
                          paymentStatus,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 8),

                    // Total harga
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Harga: ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        Text(
                          "Rp.${NumberFormat('###0', 'id_ID').format(orderList.fold(0.0, (total, order) {
                            final price = double.tryParse(order['price'] ?? '0') ?? 0.0;
                            final quantity = double.tryParse(order['quantity'] ?? '0') ?? 0.0;
                            return total + (price * quantity);
                          }))} ",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Data dummy yang digunakan dalam List<Map<String, String>> sebagai contoh
const Map<String, String> customerData = {
  'name': 'Rifqu',
  'orderId': 'ORD-1635776112345-879',
  'address': 'Jl. Ligar Nanjung No.113A',
};

const List<Map<String, String>> orderList = [
  {
    'fish': 'Ikan Tuna',
    'variant': 'Fresh',
    'quantity': '2',
    'Bobot': '1 kg 2 ekor',
    'price': '50000',
    'shipmentStatus': 'Shipped',
    'paymentStatus': 'Belum Lunas',
  },
  {
    'fish': 'Ikan Salmon',
    'variant': 'Frozen',
    'quantity': '1',
    'Bobot': '1 kg 2 ekor',
    'price': '80000',
    'shipmentStatus': 'Pending',
    'paymentStatus': 'Belum Lunas',
  },
  {
    'fish': 'Ikan Gurami',
    'variant': 'Live',
    'quantity': '3',
    'Bobot': '1 kg 2 ekor',
    'price': '60000',
    'shipmentStatus': 'Shipped',
    'paymentStatus': 'Belum Lunas',
  },
  {
    'fish': 'Ikan Kerapu',
    'variant': 'Fresh',
    'quantity': '1',
    'Bobot': '0.8 Kg',
    'price': '70000',
    'shipmentStatus': 'Pending',
    'paymentStatus': 'Belum Lunas',
  },
];
