package com.example.ikanapps

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.example.ikanapps.HttpRequest

class MainActivity : FlutterActivity() {
    private val httpRequest = HttpRequest(this)
    private val AKUN_CHANNEL = "com.example.ikanapps/akun_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, AKUN_CHANNEL)
            .setMethodCallHandler { call, result ->

                val username = call.argument<String>("username")
                val password = call.argument<String>("password")
                val nama = call.argument<String>("nama")
                val telepon = call.argument<String>("telepon")
                val alamat = call.argument<String>("alamat")// Untuk register
                val email = call.argument<String>("email")

                if (username != null && password != null) {
                    when (call.method) {
                        "fetchProducts" -> { // Login method
                            // Memanggil fungsi login
                            httpRequest.login(username, password) { response ->
                                result.success(response) // Mengirimkan response login ke Flutter
                            }
                        }
                        "fetchRegister" -> { // Register method
                            // Memastikan email ada untuk register
                            if (username != null && password != null && nama != null && telepon != null && alamat != null && email != null) {
                                httpRequest.register(username, password, nama, telepon, alamat, email) { response ->
                                    result.success(response) // Mengirimkan response register ke Flutter
                                }
                            } else {
                                result.error("INVALID_PARAMETERS", "Email is required for registration", null)
                            }
                        }
                        else -> result.notImplemented() // Jika metode tidak dikenali
                    }
                } else {
                    result.error("INVALID_PARAMETERS", "Username or password is null", null) // Jika parameter kosong
                }
            }
    }
}

}
