import 'package:flutter/services.dart';

class NativeChannel {

  NativeChannel._privateConstructor();

  // Single instance of NativeChannel
  static final NativeChannel instance = NativeChannel._privateConstructor();

  static const AKUN_CHANNEL = MethodChannel('com.example.ikanapps/akun_channel');

  void initialize() {
    print('NativeChannel initialized');

  }



}