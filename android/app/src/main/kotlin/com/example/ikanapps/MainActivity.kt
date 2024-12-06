package com.example.ikanapps

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log
import com.example.ikanapps.HttpRequest

class MainActivity : FlutterActivity() {
    private val httpRequest = HttpRequest(this)
    private val AKUN_CHANNEL = "com.example.ikanapps/akun_channel"
    private val STOK_CHANNEL = "com.example.ikanapps/stok_channel"
    private val CUSTOMER_CHANNEL = "com.example.ikanapps/customer_channel"
    private val PRODUK_CHANNEL = "com.example.ikanapps/produk_channel"
    private val USERS_CHANNEL = "com.example.ikanapps/users_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, AKUN_CHANNEL)
            .setMethodCallHandler { call, result ->
                // Mendapatkan parameter yang diperlukan
                val username = call.argument<String>("username")
                val password = call.argument<String>("password")

                // Cek apakah username dan password tidak null
                if (username != null && password != null) {
                    when (call.method) {
                        "fetchProducts" -> {  // Proses login
                            // Menangani login dengan httpRequest.login yang menerima nama dan alamat
                            httpRequest.login(username, password) { loginStatus, role ->
                                if (loginStatus.contains("successful")) {  // Cek jika login berhasil
                                    // Mengirimkan response sukses dan role ke Flutter
                                    result.success("Login successful: $loginStatus, Role: $role")
                                } else {
                                    result.error("LOGIN_FAILED", "Login failed, please check credentials", null)
                                }
                            }
                        }
                        else -> result.notImplemented()  // Jika method tidak dikenali
                    }
                } else {
                    result.error("INVALID_PARAMETERS", "One or more parameters are null", null)
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PRODUK_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "fetchStok" -> {
                        httpRequest.getStok { response ->
                            if (response.startsWith("Success:")) {
                                try {
                                    // Parse the response string and return a structured list to Flutter
                                    val stokList = response.removePrefix("Success: ")
                                        .split(", ")
                                        .mapNotNull { item ->
                                            try {
                                                val parts = item.split(", ")
                                                val id = parts[0].removePrefix("id: ").toInt()
                                                val nama = parts[1].removePrefix("nama: ")
                                                mapOf("id" to id, "nama" to nama)
                                            } catch (e: Exception) {
                                                Log.e("HttpRequest", "Error parsing item: $item", e)
                                                null // Ignore the invalid item
                                            }
                                        }

                                    if (stokList.isNotEmpty()) {
                                        result.success(stokList) // Return the list to Flutter
                                    } else {
                                        result.error("EMPTY_DATA", "No valid stok data found", null)
                                    }
                                } catch (e: Exception) {
                                    Log.e("HttpRequest", "Error processing response", e)
                                    result.error("ERROR", "Failed to parse response", null)
                                }
                            } else {
                                // Return error message to Flutter
                                result.error("ERROR", response, null)
                            }
                        }
                    }
                    else -> result.notImplemented()
                }
            }






    }
}
