import 'package:flutter/services.dart';

class NativeChannel {
  NativeChannel._privateConstructor();

  // Single instance of NativeChannel
  static final NativeChannel instance = NativeChannel._privateConstructor();

  static const AKUN_CHANNEL = MethodChannel('com.example.ikanapps/akun_channel');

  void initialize() {
    print('NativeChannel initialized');
  }

  Future<String> getProducts(String username, String password) async {
    try {
      // Call the native method and get the result
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



}
