import 'package:flutter/material.dart';
import 'package:ikanapps/screen/UserManagementScreen.dart';
import 'package:ikanapps/screen/orderHistory.dart';
import 'package:ikanapps/screen/pembelian.dart';
import 'orderScreen.dart';
import 'stockManagementScreen.dart';
import 'reportScreen.dart';
import 'package:ikanapps/backend/nativeChannel.dart';

class DashboardScreen extends StatefulWidget {
  final String username; // Username passed from the login screen

  const DashboardScreen({Key? key, required this.username, required String role}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late String userRole; // Add a field for user role

  @override
  void initState() {
    super.initState();
    userRole = 'user'; // Default role before fetching from DB
    _fetchUserRole(); // Fetch role from the database
  }

  // Simulate a function to fetch the user role from an API or database
  Future<void> _fetchUserRole() async {
    try {
      // Simulate an API call or database query that retrieves the user role
      // Replace this with actual database/API logic
      // Example: userRole = await Database.getUserRole(widget.username);

      // Simulating a delay for fetching data (replace with actual logic)
      await Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          userRole = 'admin'; // Replace this with actual role fetched from the database
        });
      });
    } catch (e) {
      // Handle any errors or issues during fetching the role
      print("Error fetching user role: $e");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFe9f0f8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1d5082),
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150'), // Gambar profil
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.username.isNotEmpty ? widget.username : "Username Not Available",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'CooperMdBT',
                    fontSize: 20,
                  ),
                ),
                // Displaying role dynamically
                Text(
                  userRole.isNotEmpty ? userRole : "Role Not Available",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontFamily: 'CooperMdBT',
                  ),
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
      drawer: _buildDrawer(context), // Drawer
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
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
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
                            fontFamily: 'CooperMdBT',
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
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xffe3f2f7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                          Text(
                            "${customerData['name'] ?? 'Unknown'}",
                            style: const TextStyle(fontSize: 14, color: Colors.black87, fontFamily: 'Montserrat', fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 0),
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
                                          style: const TextStyle(fontSize: 14, fontFamily: 'Montserrat'),
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
                                          style: const TextStyle(fontSize: 14, fontFamily: 'Montserrat'),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            )
                          else
                            const Text(
                              "No orders yet",
                              style: TextStyle(fontSize: 14, color: Colors.black87, fontFamily: 'Montserrat'),
                            ),
                          const SizedBox(height: 8),
                          if (orderList.isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
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
      return Colors.green;
    } else if (status == 'Pending') {
      return Colors.orange;
    } else {
      return Colors.grey;
    }
  }

  Color _getPaymentStatusColor(String? status) {
    if (status == 'Paid') {
      return Colors.green;
    } else if (status == 'Belum Lunas') {
      return const Color(0xffc70000);
    } else {
      return Colors.grey;
    }
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF2365a2)),
            accountName: Text(
              widget.username.isNotEmpty ? widget.username : "Username Not Available",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'CooperMdBT',
              ),
            ),
            accountEmail: const Text(
              "admin@ikanapps.com",
              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black54, fontFamily: 'CooperMdBT'),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: NetworkImage("https://via.placeholder.com/150"),
            ),
            otherAccountsPictures: [
              IconButton(
                icon: const Icon(Icons.exit_to_app, color: Colors.white),
                onPressed: () {
                  _logout(context); // Logic for logout
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text("Order", style: TextStyle(fontFamily: 'CooperMdBT')),
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.add_shopping_cart),
                title: const Text('Order'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Order History'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderHistoryScreen(customerData: {}, orderList: [],)));
                },
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text("Pembelian", style: TextStyle(fontFamily: 'CooperMdBT')),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PembelianScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.report),
            title: const Text("Report", style: TextStyle(fontFamily: 'CooperMdBT')),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportScreen()));
            },
          ),
          // Show admin options if the user is an admin
          if (userRole == 'admin') ...[
            ListTile(
              leading: const Icon(Icons.manage_accounts),
              title: const Text("Pekerja", style: TextStyle(fontFamily: 'CooperMdBT')),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const UserManagementScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_box),
              title: const Text("Manage Stock", style: TextStyle(fontFamily: 'CooperMdBT')),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const StockManagementScreen()));
              },
            ),
          ],
          // Show owner options if the user is an owner
          if (userRole == 'owner') ...[
            ListTile(
              leading: const Icon(Icons.manage_accounts),
              title: const Text("Pekerja", style: TextStyle(fontFamily: 'CooperMdBT')),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const UserManagementScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_box),
              title: const Text("Manage Stock", style: TextStyle(fontFamily: 'CooperMdBT')),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const StockManagementScreen()));
              },
            ),
          ],
        ],
      ),
    );
  }
  Widget _buildReportCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            title,
            style: const TextStyle(color: Colors.black, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

  // Logout function (example)
  void _logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login'); // Implement your logout logic here
  }

