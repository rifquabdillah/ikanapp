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
                            httpRequest.login(username, password) { response ->
                                if (response != null) {
                                    result.success(response)  // Mengirimkan response ke Flutter
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

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, STOK_CHANNEL)
            .setMethodCallHandler { call, result ->

                val nama = call.argument<String>("nama")
                val harga = call.argument<String>("harga")

                Log.e("STOK_CHANNEL", "Received Jenis Ikan: $nama, harga: $harga")

                when (call.method) {
                    "fetchStok" -> {
                        httpRequest.getStok(nama!!, harga!!) { response ->
                            result.success(response)
                        }
                    } else -> result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CUSTOMER_CHANNEL)
            .setMethodCallHandler { call, result ->

                // Mendapatkan parameter untuk nama, telepon, telepon2, alamat, patokan, gps
                val nama = call.argument<String>("nama")
                val telepon = call.argument<String>("telepon")
                val telepon2 = call.argument<String>("telepon2")
                val alamat = call.argument<String>("alamat")
                val patokan = call.argument<String>("patokan")
                val gps = call.argument<String>("gps")

                // Cek apakah semua parameter yang diperlukan tidak null
                if (nama != null && telepon != null && telepon2 != null && alamat != null && patokan != null && gps != null) {
                    when (call.method) {
                        "fetchCustomer" -> { // Nama metode yang dipanggil dari Flutter
                            httpRequest.getCustomer(nama, telepon, telepon2, alamat, patokan, gps) { response ->
                                result.success(response) // Mengirimkan response ke Flutter
                            }
                        }
                        else -> result.notImplemented() // Jika method tidak dikenali
                    }
                } else {
                    result.error("INVALID_PARAMETERS", "Some parameters are null", null) // Menangani jika parameter null
                }
            }

    }
}
