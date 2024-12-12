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
  static const ORDER_CHANNEL = MethodChannel('com.example.ikanapps/order_channel');
  static const BOBOT_CHANNEL = MethodChannel('com.example.ikanapps/bobot_channel');
  static const SAVE_ORDER_CHANNEL = MethodChannel('com.example.ikanapps/save_order_channel');
  static const GET_ORDER_CHANNEL = MethodChannel('com.example.ikanapps/get_order_channel');
  static const SHIPMENT_CHANNEL = MethodChannel('com.example.ikanapps/shipment_channel');
  static const PAYMENT_CHANNEL = MethodChannel('com.example.ikanapps/payment_channel');


  void initialize() {
    print('NativeChannel initialized');
  }

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

  Future<List<Map<String, dynamic>>> fetchBobot() async {
    try {
      // Invoke the platform channel to fetch stock data
      final result = await BOBOT_CHANNEL.invokeMethod('fetchBobot');

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
      print("Error fetching user data: $e");
      return [];
    }
  }

  Future<String> saveOrder({
    required Map<String, dynamic> body,
  }) async {
    try {

      // Pass raw objects to the method channel, not JSON strings
      final result = await SAVE_ORDER_CHANNEL.invokeMethod('saveOrder', {
        'body': body,
      });

      // Check if the result is a String (success response)
      if (result is String) {
        return result;
      } else {
        throw Exception("Unexpected result type: ${result.runtimeType}");
      }
    } on PlatformException catch (e) {
      // Handle errors related to method channel
      print('Failed to save order: ${e.message}');
      throw Exception('Failed to save order: ${e.message}');
    } catch (e) {
      // Handle other errors
      print('Error saving order: $e');
      throw Exception('Error saving order: $e');
    }
  }



  Future<List<Map<String, dynamic>>> fetchOrder() async {
    try {
      // Invoke the platform channel to fetch stock data
      final result = await ORDER_CHANNEL.invokeMethod('fetchOrder');

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

  Future<List<Map<String, dynamic>>> saveStock(stock) async {
    try {
      // Invoke the platform channel to fetch stock data
      final result = await PRODUK_CHANNEL.invokeMethod('saveStock');

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

  Future<List<Map<String, dynamic>>> fetchShipment() async {
    try {
      // Invoke the platform channel to fetch stock data
      final result = await SHIPMENT_CHANNEL.invokeMethod('fetchShipment');

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

  Future<List<Map<String, dynamic>>> fetchPayment() async {
    try {
      // Invoke the platform channel to fetch stock data
      final result = await PAYMENT_CHANNEL.invokeMethod('fetchPayment');

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

  Future<List<Map<String, dynamic>>> fetchGetOrder() async {
    try {
      final result = await GET_ORDER_CHANNEL.invokeMethod('fetchGetOrder');

      // Make sure the result is a List of Maps
      if (result is List) {
        // Assuming the result is a list of maps (key-value pairs)
        return List<Map<String, dynamic>>.from(result);
      } else {
        throw 'Expected a List<Map<String, dynamic>> but received: ${result.runtimeType}';
      }
    } on PlatformException catch (e) {
      print('Failed to get orders: ${e.message}');
      throw 'Failed to get orders: ${e.message}';
    }
  }
}







