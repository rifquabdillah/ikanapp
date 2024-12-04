import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import untuk MethodChannel
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
  String nama = '';      // Nama pengguna

  bool isLoading = true; // Status loading

  // Fungsi untuk mengambil data pengguna dari backend
  Future<void> _getUserData(String username, String password) async {
    try {
      final platform = MethodChannel('AKUN_CHANNEL');  // Membuat channel
      final response = await platform.invokeMethod('fetchProducts', {
        'username': username,
        'password': password,
      });
      print('Response from Android: $response');

      // Misalnya response adalah String JSON yang perlu diparsing
      if (response != null && response.isNotEmpty) {
        final Map<String, dynamic> userData = _parseUserData(response);
        setState(() {
          this.username = username;
          this.nama = userData['nama'] ?? 'Unknown';
          this.alamat = userData['alamat'] ?? 'Unknown';
          this.email = userData['email'] ?? 'Unknown';
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
    String username = 'yourUsername'; // Ganti dengan username yang sesuai
    String password = 'yourPassword'; // Ganti dengan password yang sesuai

    // Panggil fungsi untuk mendapatkan data pengguna berdasarkan username dan password
    _getUserData(username, password);
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
                          'Email: $email',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Address: $alamat',
                          style: const TextStyle(fontSize: 16),
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
