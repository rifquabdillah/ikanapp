package com.example.ikanapps

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    private val AKUN_CHANNEL = "com.example.ikanapps/akun_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, AKUN_CHANNEL)
            .setMethodCallHandler { call, result ->

            }
    }
}
