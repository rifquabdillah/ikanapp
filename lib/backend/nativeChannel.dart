import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:ikanapps/screen/orderScreen.dart';

class NativeChannel {
  NativeChannel._privateConstructor();

  // Single instance of NativeChannel
  static final NativeChannel instance = NativeChannel._privateConstructor();
  static const AKUN_CHANNEL = MethodChannel('com.example.ikanapps/akun_channel');
  static const CUSTOMER_CHANNEL = MethodChannel('com.example.ikanapps/customer_channel');
  static const PRODUK_CHANNEL = MethodChannel('com.example.ikanapps/produk_channel');
  static const USERS_CHANNEL = MethodChannel('com.example.ikanapps/users_channel');
  static const SUPPLIER_CHANNEL = MethodChannel('com.example.ikanapps/supplier_channel');
  static const VARIAN_CHANNEL = MethodChannel('com.example.ikanapps/varian_channel');

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

  Future<List<Map<String, dynamic>>> fetchCustomer() async {
    try {
      // Invoke the platform channel to fetch stock data
      final result = await CUSTOMER_CHANNEL.invokeMethod('fetchCustomer');

      // Parse the result into a list of maps
      if (result is List) {
        return List<Map<String, dynamic>>.from(result.map((item) {
          if (item is Map) {
            return Map<String, dynamic>.from(item);
          } else {
            throw FormatException("Invalid item format in result");
          }
        }));
      } else {
        throw FormatException("Expected a list, but got: ${result.runtimeType}");
      }
    } catch (e) {
      // Handle exceptions and errors
      print("Error fetching stock data: $e");
      return [];
    }
  }
  // Fungsi untuk mendapatkan data stok
  Future<Map<String, dynamic>> getStok(String nama,String varian,String ukuran, String harga) async {
    try {
      final result = await PRODUK_CHANNEL.invokeMethod('getStock', {
        'nama': nama,
        'varian': varian,
        'ukuran' : ukuran,
        'harga': harga,
      });

      // Pastikan hasilnya berupa String JSON
      if (result is String) {
        return jsonDecode(result); // Parsing JSON menjadi Map
      } else {
        throw 'Expected a JSON string but received: ${result.runtimeType}';
      }
    } on PlatformException catch (e) {
      print('Failed to fetch stok: ${e.message}');
      throw 'Failed to fetch stok: ${e.message}';
    }
  }

  Future<List<Map<String, dynamic>>> fetchStok() async {
    try {
      // Invoke the platform channel to fetch stock data
      final result = await PRODUK_CHANNEL.invokeMethod('fetchStok');

      // Parse the result into a list of maps
      if (result is List) {
        return List<Map<String, dynamic>>.from(result.map((item) {
          if (item is Map) {
            return Map<String, dynamic>.from(item);
          } else {
            throw FormatException("Invalid item format in result");
          }
        }));
      } else {
        throw FormatException("Expected a list, but got: ${result.runtimeType}");
      }
    } catch (e) {
      // Handle exceptions and errors
      print("Error fetching stock data: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchSupplier() async {
    try {
      // Invoke the platform channel to fetch stock data
      final result = await SUPPLIER_CHANNEL.invokeMethod('fetchSupplier');

      // Parse the result into a list of maps
      if (result is List) {
        return List<Map<String, dynamic>>.from(result.map((item) {
          if (item is Map) {
            return Map<String, dynamic>.from(item);
          } else {
            throw FormatException("Invalid item format in result");
          }
        }));
      } else {
        throw FormatException("Expected a list, but got: ${result.runtimeType}");
      }
    } catch (e) {
      // Handle exceptions and errors
      print("Error fetching stock data: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchVarian() async {
    try {
      // Invoke the platform channel to fetch stock data
      final result = await VARIAN_CHANNEL.invokeMethod('fetchVarian');

      // Parse the result into a list of maps
      if (result is List) {
        return List<Map<String, dynamic>>.from(result.map((item) {
          if (item is Map) {
            return Map<String, dynamic>.from(item);
          } else {
            throw FormatException("Invalid item format in result");
          }
        }));
      } else {
        throw FormatException("Expected a list, but got: ${result.runtimeType}");
      }
    } catch (e) {
      // Handle exceptions and errors
      print("Error fetching stock data: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchUser() async {
    try {
      // Invoke the platform channel to fetch stock data
      final result = await USERS_CHANNEL.invokeMethod('fetchUser');

      // Parse the result into a list of maps
      if (result is List) {
        List<Map<String, dynamic>> userList = [];
        for (var item in result) {
          if (item is Map) {
            userList.add(Map<String, dynamic>.from(item));
          } else {
            throw FormatException("Invalid item format in result");
          }
        }
        return userList;
      } else {
        throw FormatException("Expected a list, but got: ${result.runtimeType}");
      }
    } catch (e) {
      // Handle exceptions and errors
      print("Error fetching stock data: $e");
      return [];
    }
  }


}
