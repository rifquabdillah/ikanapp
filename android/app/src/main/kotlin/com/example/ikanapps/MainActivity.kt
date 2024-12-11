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
    private val ORDER_CHANNEL = "com.example.ikanapps/order_channel"
    private val USERS_CHANNEL = "com.example.ikanapps/users_channel"
    private val CUSTOMER_CHANNEL = "com.example.ikanapps/customer_channel"
    private val PRODUK_CHANNEL = "com.example.ikanapps/produk_channel"
    private val SUPPLIER_CHANNEL = "com.example.ikanapps/supplier_channel"
    private val VARIAN_CHANNEL = "com.example.ikanapps/varian_channel"
    private val BOBOT_CHANNEL = "com.example.ikanapps/bobot_channel"
    private val SHIPMENT_CHANNEL = "com.example.ikanapps/shipment_channel"
    private val PAYMENT_CHANNEL = "com.example.ikanapps/payment_channel"
    private val SAVE_ORDER_CHANNEL = "com.example.ikanapps/save_order_channel"
    private val GET_ORDER_CHANNEL = "com.example.ikanapps/get_order_channel"

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
                                    result.error(
                                        "LOGIN_FAILED",
                                        "Login failed, please check credentials",
                                        null
                                    )
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

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, USERS_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "fetchUser" -> {
                        httpRequest.getUser { response ->
                            try {
                                // Assuming response is already a List<Map<String, Any>>
                                if (response is List<*>) {
                                    val userList = response.filterIsInstance<Map<String, Any>>()
                                    if (userList.isNotEmpty()) {
                                        result.success(userList) // Return the list to Flutter
                                    } else {
                                        result.error("EMPTY_DATA", "No valid user data found", null)
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

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ORDER_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "fetchOrder" -> {
                        httpRequest.getOrder { response ->
                            try {
                                // Assuming response is already a List<Map<String, Any>>
                                if (response is List<*>) {
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
                                    result.error(
                                        "INVALID_RESPONSE",
                                        "Response is not a valid List<Map<String, Any>>",
                                        null
                                    )
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

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CUSTOMER_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "fetchCustomer" -> {
                        httpRequest.getCustomer { response ->
                            try {
                                // Assuming response is already a List<Map<String, Any>>
                                if (response is List<*>) {
                                    // Filter and map only items that are valid Map<String, Any>
                                    val customerList = response.filterIsInstance<Map<String, Any>>()

                                    if (customerList.isNotEmpty()) {
                                        result.success(customerList) // Return the list to Flutter
                                    } else {
                                        result.error("EMPTY_DATA", "No valid stok data found", null)
                                    }
                                } else {
                                    result.error(
                                        "INVALID_RESPONSE",
                                        "Response is not a valid List<Map<String, Any>>",
                                        null
                                    )
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


        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, VARIAN_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "fetchVarian" -> {
                        httpRequest.getVarian { response ->
                            try {
                                // Assuming response is already a List<Map<String, Any>>
                                if (response is List<*>) {
                                    // Filter and map only items that are valid Map<String, Any>
                                    val varianList = response.filterIsInstance<Map<String, Any>>()

                                    if (varianList.isNotEmpty()) {
                                        result.success(varianList) // Return the list to Flutter
                                    } else {
                                        result.error("EMPTY_DATA", "No valid stok data found", null)
                                    }
                                } else {
                                    result.error(
                                        "INVALID_RESPONSE",
                                        "Response is not a valid List<Map<String, Any>>",
                                        null
                                    )
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

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, BOBOT_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "fetchBobot" -> {
                        httpRequest.getBobot { response ->
                            try {
                                // Assuming response is already a List<Map<String, Any>>
                                if (response is List<*>) {
                                    // Filter and map only items that are valid Map<String, Any>
                                    val bobotList = response.filterIsInstance<Map<String, Any>>()

                                    if (bobotList.isNotEmpty()) {
                                        result.success(bobotList) // Return the list to Flutter
                                    } else {
                                        result.error("EMPTY_DATA", "No valid stok data found", null)
                                    }
                                } else {
                                    result.error(
                                        "INVALID_RESPONSE",
                                        "Response is not a valid List<Map<String, Any>>",
                                        null
                                    )
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


        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SAVE_ORDER_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "saveOrder" -> {
                        val customerData = call.argument<Map<String, String>>("customerData")
                        val orderList = call.argument<List<Map<String, String>>>("orderList")
                        Log.d("PARAMETER", "customerData: $customerData, orderList: $orderList")

                        if (customerData != null && orderList != null) {
                            httpRequest.saveOrder(customerData, orderList) { responseData ->
                                if (responseData.isNotEmpty()) {
                                    // Success case: Return data back to the Flutter side
                                    result.success(responseData)
                                } else {
                                    // Failure case: No data found or API returned an error
                                    result.error("EMPTY_RESPONSE", "No data returned from saveOrder", null)
                                }
                            }
                        } else {
                            result.error("MISSING_FIELDS", "Some fields are missing", null)
                        }
                    }

                    // Handle other methods here
                    "anotherMethod" -> {
                        // Implementation for another method
                        result.success("Handled anotherMethod")
                    }

                    else -> {
                        result.notImplemented() // Return this if the method is not recognized
                    }
                }
            }



        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, GET_ORDER_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getOrder" -> {
                        httpRequest.getOrder { response ->
                            try {
                                // Assuming response is already a List<Map<String, Any>>
                                if (response is List<*>) {
                                    // Filter and map only items that are valid Map<String, Any>
                                    val getOrderList = response.filterIsInstance<Map<String, Any>>()

                                    if (getOrderList.isNotEmpty()) {
                                        result.success(getOrderList) // Return the list to Flutter
                                    } else {
                                        result.error("EMPTY_DATA", "No valid stok data found", null)
                                    }
                                } else {
                                    result.error(
                                        "INVALID_RESPONSE",
                                        "Response is not a valid List<Map<String, Any>>",
                                        null
                                    )
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

                // Shipment Channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SHIPMENT_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "fetchShipment" -> {
                        httpRequest.getShipment { response ->
                            try {
                                // Assuming response is already a List<Map<String, Any>>
                                if (response is List<*>) {
                                    // Filter and map only items that are valid Map<String, Any>
                                    val shipmentList = response.filterIsInstance<Map<String, Any>>()

                                    if (shipmentList.isNotEmpty()) {
                                        result.success(shipmentList) // Return the list to Flutter
                                    } else {
                                        result.error("EMPTY_DATA", "No valid stok data found", null)
                                    }
                                } else {
                                    result.error(
                                        "INVALID_RESPONSE",
                                        "Response is not a valid List<Map<String, Any>>",
                                        null
                                    )
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


        // Payment Channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PAYMENT_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "fetchPayment" -> {
                        httpRequest.getPayment { response ->
                            try {
                                // Assuming response is already a List<Map<String, Any>>
                                if (response is List<*>) {
                                    // Filter and map only items that are valid Map<String, Any>
                                    val paymentList = response.filterIsInstance<Map<String, Any>>()

                                    if (paymentList.isNotEmpty()) {
                                        result.success(paymentList) // Return the list to Flutter
                                    } else {
                                        result.error("EMPTY_DATA", "No valid stok data found", null)
                                    }
                                } else {
                                    result.error(
                                        "INVALID_RESPONSE",
                                        "Response is not a valid List<Map<String, Any>>",
                                        null
                                    )
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
