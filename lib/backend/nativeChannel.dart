import 'package:flutter/services.dart';

class NativeChannel {
  NativeChannel._privateConstructor();

  // Single instance of NativeChannel
  static final NativeChannel instance = NativeChannel._privateConstructor();

  static const AKUN_CHANNEL = MethodChannel('com.example.ikanapps/akun_channel');
  static const CUSTOMER_CHANNEL = MethodChannel('com.example.ikanapps/customer_channel');

  void initialize() {
    print('NativeChannel initialized');
  }

  // Fungsi untuk mengambil data produk atau user dari Native code
  Future<String> getAkun(String username, String password) async {
    try {
      final result = await AKUN_CHANNEL.invokeMethod('fetchProducts', {
        'username': username,
        'password': password,
      });

      // Pastikan hasilnya berupa String
      if (result is String) {
        return result; // Mengembalikan hasil berupa String
      } else {
        throw 'Expected a String but received: ${result.runtimeType}';
      }
    } on PlatformException catch (e) {
      print('Failed to get data: ${e.message}');
      throw 'Failed to get data: ${e.message}';
    }
  }



  Future<String> updateUserRole(String username, String role) async {
    try {
      final result = await AKUN_CHANNEL.invokeMethod('updateUserRole', {
        'username': username,
        'role': role,
      });

      if (result is String) {
        return result; // Mengembalikan hasil berupa String (misalnya pesan sukses)
      } else {
        throw 'Expected a String but received: ${result.runtimeType}';
      }
    } on PlatformException catch (e) {
      print('Failed to update user role: ${e.message}');
      throw 'Failed to update user role: ${e.message}';
    }
  }



  Future<String> getCustomers(String nama, String telepon,String telepon2, String alamat, String patokan, String gps) async {
    try {
      // Call the native method and get the result
      final result = await CUSTOMER_CHANNEL.invokeMethod('fetchCustomer', {
        'nama': nama,
        'telepon': telepon,
        'telepon2':telepon2,
        'alamat':alamat,
        'patokan':patokan,
        'gps' :gps
      });

      // Pastikan hasilnya berupa String
      if (result is String) {
        return result; // Mengembalikan hasil berupa String
      } else {
        throw 'Expected a String but received: ${result.runtimeType}';
      }
    } on PlatformException catch (e) {
      print('Failed to get data: ${e.message}');
      throw 'Failed to get data: ${e.message}';
    }
  }







}
