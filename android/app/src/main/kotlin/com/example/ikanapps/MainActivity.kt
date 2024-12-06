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
    private val SUPPLIER_CHANNEL = "com.example.ikanapps/supplier_channel"

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
                            try {
                                // Assuming response is already a List<Map<String, Any>>
                                if (response is List<*>) {
                                    // Filter and map only items that are valid Map<String, Any>
                                    val stokList = response.filterIsInstance<Map<String, Any>>()

                                    if (stokList.isNotEmpty()) {
                                        result.success(stokList) // Return the list to Flutter
                                    } else {
                                        result.error("EMPTY_DATA", "No valid stok data found", null)
                                    }
                                } else {
                                    result.error("INVALID_RESPONSE", "Response is not a valid List<Map<String, Any>>", null)
                                }
                            } catch (e: Exception) {
                                Log.e("HttpRequest", "Error processing response", e)
                                result.error("ERROR", "Failed to process response", null)
                            }
                        }
                    }
                    else -> result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SUPPLIER_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "fetchSupplier" -> {
                        httpRequest.getSupplier { response ->
                            try {
                                // Assuming response is already a List<Map<String, Any>>
                                if (response is List<*>) {
                                    // Filter and map only items that are valid Map<String, Any>
                                    val supplierList = response.filterIsInstance<Map<String, Any>>()

                                    if (supplierList.isNotEmpty()) {
                                        result.success(supplierList) // Return the list to Flutter
                                    } else {
                                        result.error("EMPTY_DATA", "No valid stok data found", null)
                                    }
                                } else {
                                    result.error("INVALID_RESPONSE", "Response is not a valid List<Map<String, Any>>", null)
                                }
                            } catch (e: Exception) {
                                Log.e("HttpRequest", "Error processing response", e)
                                result.error("ERROR", "Failed to process response", null)
                            }
                        }
                    }
                    else -> result.notImplemented()
                }
            }






    }
}
