import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ikanapps/backend/nativeChannel.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  String username = '';  // Username pengguna
  String email = '';     // Email pengguna
  String alamat = '';    // Alamat pengguna
  String role = 'user';  // Role default pengguna
  String nama = '';      // Nama pengguna

  bool isLoading = true; // Status loading

  // Daftar role yang bisa dipilih
  final List<String> roles = ['user', 'admin', 'owner'];

  // Fungsi untuk mengambil data pengguna dari backend
  Future<void> _getUserData(String username, String password, String email, String alamat) async {
    try {
      // Panggil API dengan username dan password untuk mendapatkan data pengguna
      final response = await NativeChannel.instance.getProducts(username, password);
      print('User Data Success: $response');

      // Misalnya response adalah String JSON yang perlu diparsing
      if (response.isNotEmpty) {
        final Map<String, dynamic> userData = _parseUserData(response);
        setState(() {
          this.username = username;
          this.nama = userData['nama'] ?? 'Unknown';
          this.alamat = userData['alamat'] ?? 'Unknown';
          this.email = userData['email'] ?? 'Unknown';
          this.role = userData['role'] ?? 'user';
          isLoading = false; // Hentikan loading setelah data selesai
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        isLoading = false; // Hentikan loading jika terjadi error
      });
    }
  }

  Map<String, dynamic> _parseUserData(String response) {
    try {
      // Jika response adalah JSON string, kita coba decode
      return Map<String, dynamic>.from(jsonDecode(response));
    } catch (e) {
      print('Error parsing user data: $e');
      return {};
    }
  }

  @override
  void initState() {
    super.initState();
    // Ambil username dan password dari sumber lain, misalnya hardcode atau parameter.
    String username = 'tester'; // Ganti dengan username yang sesuai
    String password = 'password123'; // Ganti dengan password yang sesuai
    String email = 'email@.com'; // Ganti dengan password yang sesuai
    String alamat = 'jalan';
    // Panggil fungsi untuk mendapatkan data pengguna berdasarkan username dan password
    _getUserData(username, password, email, alamat);
  }

  // Fungsi untuk menyimpan perubahan role
  void _saveUserRole() {
    print('Role updated to: $role');
    // Kirim request ke server untuk memperbarui data pengguna
    NativeChannel.instance.updateUserRole(username, role);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Menampilkan progress indicator ketika data masih dalam proses pengambilan
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (username.isNotEmpty)
              // Membungkus semua informasi dalam satu Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Data pengguna
                        Text(
                          'Name: $nama',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Username: $username',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Email: $email',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Address: $alamat',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        // Dropdown untuk memilih role
                        Text(
                          'Role: $role',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: role,
                          decoration: const InputDecoration(labelText: 'Select Role'),
                          items: roles.map((String role) {
                            return DropdownMenuItem<String>(
                              value: role,
                              child: Text(role),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              role = newValue!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        // Tombol simpan untuk menyimpan perubahan role
                        ElevatedButton(
                          onPressed: _saveUserRole,
                          child: const Text('Save Changes'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
