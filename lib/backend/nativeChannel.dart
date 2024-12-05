import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:ikanapps/screen/orderScreen.dart';

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


  Future<Map<String, Customer>> getCustomers(String nama, String telepon, String telepon2, String alamat, String patokan, String gps) async {
    try {
      final result = await NativeChannel.instance.getCustomers(
          nama, telepon, telepon2, alamat, patokan, gps
      );

      // Pastikan hasilnya berupa string JSON
      if (result is String) {
        // Decode JSON menjadi Map
        final Map<String, dynamic> rawData = json.decode(result as String);
        return rawData.map((key, value) {
          return MapEntry(key, Customer.fromJson(value));
        });
      } else {
        throw 'Expected a String but received: ${result.runtimeType}';
      }
    } on PlatformException catch (e) {
      print('Failed to get data: ${e.message}');
      throw 'Failed to get data: ${e.message}';
    }
  }









}
