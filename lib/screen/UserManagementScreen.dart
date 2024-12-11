import 'package:flutter/material.dart';
import 'package:ikanapps/backend/nativeChannel.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  late Future<List<Map<String, dynamic>>> _futureUser;
  final List<Map<String, dynamic>> _userList = [];
  String? _selectedUser;
  Map<String, dynamic>? _selectedUserDetails;

  @override
  void initState() {
    super.initState();
    _futureUser = fetchUser();
  }

  Future<List<Map<String, dynamic>>> fetchUser() async {
    try {
      print("Fetching customer data...");
      var produkData = await NativeChannel.instance.fetchUser();
      print("Data fetched: $produkData");
      if (produkData is List) {
        return produkData.map((user) => Map<String, dynamic>.from(user)).toList();
      } else {
        throw Exception("Invalid data format");
      }
    } catch (e) {
      print("Error fetching customer data: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manajemen User"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _futureUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Terjadi kesalahan: ${snapshot.error}"),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Belum ada data user."));
            }

            if (_userList.isEmpty) {
              _userList.addAll(snapshot.data!);
              print("User list: $_userList");
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Daftar User",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // Dropdown untuk memilih user
                DropdownButtonFormField<String>(
                  value: _selectedUser,
                  hint: const Text("Pilih User"),
                  items: _userList.map((user) {
                    return DropdownMenuItem<String>(
                      value: '${user['id']} - ${user['nama']}',
                      child: Text('${user['id']} - ${user['nama']}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedUser = value;
                      _selectedUserDetails = _userList.firstWhere(
                            (user) => '${user['id']} - ${user['nama']}' == value,
                      );
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Menampilkan detail user yang dipilih
                if (_selectedUserDetails != null) ...[
                  _buildDetailContainer(
                    "ID User",
                    _selectedUserDetails?['id']?.toString() ?? '-',
                  ),
                  _buildDetailContainer(
                    "Nama",
                    _selectedUserDetails?['nama'] ?? '-',
                  ),
                  _buildDetailContainer(
                    "Telepon",
                    _selectedUserDetails?['telepon'] ?? '-',
                  ),
                  _buildDetailContainer(
                    "Username",
                    _selectedUserDetails?['username'] ?? '-',
                  ),
                  _buildDetailContainer(
                    "Email",
                    _selectedUserDetails?['email'] ?? '-',
                  ),
                  _buildDetailContainer(
                    "Role",
                    _selectedUserDetails?['role'] ?? '-',
                  ),
                  _buildDetailContainer(
                    "Alamat",
                    _selectedUserDetails?['alamat'] ?? '-',
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

Widget _buildDetailContainer(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    ),
  );
}
