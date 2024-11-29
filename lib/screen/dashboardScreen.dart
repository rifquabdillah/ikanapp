import 'package:flutter/material.dart';
import 'package:ikanapps/screen/orderHistory.dart';
import 'package:ikanapps/screen/pembelian.dart';
import 'orderScreen.dart';
import 'stockManagementScreen.dart';
import 'reportScreen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFd9e6ec),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150'), // Gambar profil
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Rifqu",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                  ),
                ),
                Text(
                  "Admin",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.sync, color: Colors.blue),
              onPressed: () {
                // Tambahkan aksi refresh di sini
              },
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.black), // Warna ikon menu
      ),
      drawer: _buildDrawer(context), // Tambahkan Drawer di sini
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian laporan hari ini dengan section report di dalamnya
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                // Margin bawah untuk pemisahan
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2), // Shadow position
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Today Reports",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Aksi untuk tombol "View"
                          },
                          child: const Text("View"),
                        ),
                      ],
                    ),
                    // Menambahkan section report ke dalam Container yang sama
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildReportCard("Stock", "150 Kg", Icons.inventory,
                            const Color(0xffd6e8f6)),
                        _buildReportCard(
                            "Pesanan", "30 Pesanan", Icons.assignment_turned_in,
                            const Color(0xffe6e2f0)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildReportCard(
                            "Kekurangan Stok", "50 items", Icons.warning,
                            const Color(0xffd8e5eb)),
                        _buildReportCard(
                            "Penghasilan", "\$410.61", Icons.attach_money,
                            const Color(0xffebeef5)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Material(
                elevation: 4, // Menambahkan elevasi dengan shadow
                borderRadius: BorderRadius.circular(12), // Membuat sudut membulat pada elevasi
                color: Colors.transparent, // Membuat background material transparan agar latar belakang Container yang tampil
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xffe3f2f7), // Warna latar belakang
                    borderRadius: BorderRadius.circular(12), // Membuat radius pada background
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Menampilkan informasi Pesanan atau Riwayat Order
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Latest Orders",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Menampilkan nama pelanggan
                          Text(
                            "${customerData['name'] ?? 'Unknown'}",
                            style: const TextStyle(fontSize: 14, color: Colors.black87, fontFamily: 'Montserrat', fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 0),
                          // Menampilkan semua ikan yang dibeli dalam format "ikan lele, ikan nila"
                          if (orderList.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Pesanan :",
                                  style: TextStyle(fontSize: 14, color: Colors.black87, fontFamily: 'Montserrat', fontWeight: FontWeight.w600),
                                ),
                                Row(
                                  children: [
                                    for (int i = 0; i < orderList.length ~/ 2; i++)
                                      Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: Text(
                                          orderList[i]['fish'] ?? 'Unknown Fish',
                                          style: const TextStyle(fontSize: 14, fontFamily: 'Montserrat',),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    for (int i = orderList.length ~/ 2; i < orderList.length; i++)
                                      Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: Text(
                                          orderList[i]['fish'] ?? 'Unknown Fish',
                                          style: const TextStyle(fontSize: 14, fontFamily: 'Montserrat',),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            )
                          else
                            const Text(
                              "No orders yet",
                              style: TextStyle(fontSize: 14, color: Colors.black87, fontFamily: 'Montserrat',),
                            ),
                          const SizedBox(height: 8),
                          // Menampilkan status pengiriman dan pembayaran untuk pesanan pertama
                          if (orderList.isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Status Pengiriman
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: _getShipmentStatusColor(orderList.first['shipmentStatus']).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    orderList.first['shipmentStatus'] ?? 'Unknown',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _getShipmentStatusColor(orderList.first['shipmentStatus']),
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Status Pembayaran
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: _getPaymentStatusColor(orderList.first['paymentStatus']).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    orderList.first['paymentStatus'] ?? 'Unknown',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _getPaymentStatusColor(orderList.first['paymentStatus']),
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      // Navigasi ke OrderHistoryScreen
                      IconButton(
                        icon: const Icon(Icons.history, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OrderHistoryScreen(
                                customerData: customerData,
                                orderList: orderList,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Color _getShipmentStatusColor(String? status) {
    if (status == 'Shipped') {
      return Colors.green;  // Warna hijau untuk status "Shipped"
    } else if (status == 'Pending') {
      return Colors.orange;  // Warna orange untuk status "Pending"
    } else {
      return Colors.grey;  // Warna abu-abu untuk status lainnya (misalnya "Unknown")
    }
  }

  Color _getPaymentStatusColor(String? status) {
    if (status == 'Paid') {
      return Colors.green;  // Warna hijau untuk status "Paid"
    } else if (status == 'Belum Lunas') {
      return Color(0xffc70000);  // Warna merah untuk status "Unpaid"
    } else {
      return Colors.grey;  // Warna abu-abu untuk status lainnya (misalnya "Unknown")
    }
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFFd9e6ec)),
            accountName: const Text(
              "Admin",
              style: TextStyle(fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 16),
            ),
            accountEmail: const Text(
              "rifqu@gmail.com",
              style: TextStyle(fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 16),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.network(
                  "https://via.placeholder.com/150", // Gambar profil
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
          ),

          // Menambahkan semua item menu ke dalam drawer
          Expanded(
            child: ListView.builder(
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                return _buildDrawerItem(
                  context: context,
                  icon: _menuItems[index]['icon'],
                  title: _menuItems[index]['title'],
                  onTap: () {
                    if (_menuItems[index]['title'] == "Order") {
                      // Navigasi ke TransactionScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TransactionScreen(),
                        ),
                      );
                    } else if (_menuItems[index]['title'] == "Pembelian") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PembelianScreen(
                          ),
                        ),
                      );
                    } else if (_menuItems[index]['title'] == "Order History") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrderHistoryScreen(
                            customerData: customerData,
                            orderList: orderList,
                          ),
                        ),
                      );
                    }else if (_menuItems[index]['title'] == "Report") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReportScreen(
                          ),
                        ),
                      );
                    }else if (_menuItems[index]['title'] == "Stok") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StockManagementScreen(
                          ),
                        ),
                      );
                    }
                    // Tambahkan kondisi lain sesuai kebutuhan
                  },
                );
              },
            ),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.logout,
            title: "Log Out",
            onTap: () {
              // Aksi untuk Log Out
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      onTap: onTap,
    );
  }

  Widget _buildReportCard(String title, String amount, IconData icon,
      Color color) {
    return Container(
      width: 150,
      // Mengatur lebar tetap untuk semua kartu
      height: 130,
      // Mengatur tinggi tetap untuk semua kartu
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      // Margin antar kartu
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: Colors.black54),
          const SizedBox(height: 0),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 0),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 14, // Menyamakan ukuran font
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

  final List<Map<String, dynamic>> _menuItems = [
  {"title": "Pembelian", "icon": Icons.production_quantity_limits, "color": Colors.teal.shade300},
  {"title": "Transaksi", "icon": Icons.monetization_on_outlined, "color": Colors.green.shade300},
  {"title": "Order", "icon": Icons.sell, "color": Colors.red.shade300},
  {"title": "Order History", "icon": Icons.shopping_bag, "color": Colors.purple.shade300},
  {"title": "Report", "icon": Icons.bar_chart, "color": Colors.blueGrey.shade300},
  {"title": "Stok", "icon": Icons.warehouse, "color": Colors.cyan.shade300},
  {"title": "Peoples", "icon": Icons.people, "color": Colors.deepPurple.shade300},
];