package com.example.ikanapps

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val AKUN_CHANNEL = "com.example.ikanapps/akun_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, AKUN_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getAccountInfo" -> {
                        // Contoh: Logika untuk mengirim data akun
                        val accountInfo = getAccountInfo()
                        result.success(accountInfo)
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }
    }

    private fun getAccountInfo(): Map<String, String> {
        // Logika untuk mendapatkan informasi akun. Contoh hardcoded:
        return mapOf(
            "id" to "12345",
            "username" to "user123",
            "email" to "user@example.com"
        )
    }
}
