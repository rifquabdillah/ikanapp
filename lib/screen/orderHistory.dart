import 'package:flutter/material.dart';
import 'package:ikanapps/backend/nativeChannel.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  late Future<List<Map<String, dynamic>>> _orderFuture;

  @override
  void initState() {
    super.initState();
    _orderFuture = getOrder();
  }

  Future<List<Map<String, dynamic>>> getOrder() async {
    try {
      print("Fetching customer data...");
      var produkData = await NativeChannel.instance.getOrder();
      print("Data fetched: $produkData");
      return produkData;
    } catch (e) {
      print("Error fetching customer data: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Penerimaan Order"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(  // Handle future and snapshot
        future: _orderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No orders found"));
          } else {
            final orderList = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: orderList.length,
                itemBuilder: (context, index) {
                  final order = orderList[index];
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Kode Produk: ${order['kodeProduk'] ?? 'Unknown'}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${order['jumlahPesanan'] ?? '0'} Kg",
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "Aging: ${order['aging'] ?? '0'}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            "Harga Kg: Rp.${NumberFormat('#,##0', 'id_ID').format(double.tryParse(order['hargaKg'] ?? '0.00') ?? 0.0)}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            "Total Penerimaan: Rp.${NumberFormat('#,##0', 'id_ID').format(double.tryParse(order['totalPenerimaan'] ?? '0.00') ?? 0.0)}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.teal,
                            ),
                          ),
                          const Divider(color: Colors.grey),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Shipment: ${order['shipment'] ?? 'Unknown'}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                "Payment: ${order['payment'] ?? 'Unknown'}",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
