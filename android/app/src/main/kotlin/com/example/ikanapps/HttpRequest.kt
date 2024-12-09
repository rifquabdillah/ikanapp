package com.example.ikanapps

import android.content.Context
import android.util.Log
import retrofit2.Call
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

class HttpRequest(private val context: Context) {

    private val baseUrl = "http://103.139.244.148:5001/"

    private val retrofit: Retrofit = Retrofit.Builder()
        .baseUrl(baseUrl)
        .addConverterFactory(GsonConverterFactory.create())
        .build()

    private val apiRoutes: ApiRoutes = retrofit.create(ApiRoutes::class.java)

    data class LoginResponse(
        val isLogin: String,
        val role: String
    )

    data class RegisterResponse(
        val isRegister: String
    )

    data class CustomerResponse(
        val data: List<Map<String, Any>> // The response contains a list of Fish objects.
    )

    data class StokResponse(
        val data: List<Map<String, Any>> // The response contains a list of Fish objects.
    )

    data class SupplierResponse(
        val data: List<Map<String, Any>> // The response contains a list of Fish objects.
    )

    data class VarianResponse(
        val data: List<Map<String, Any>> // The response contains a list of Fish objects.
    )

    data class ShipmentResponse(
        val data: List<Map<String, Any>> // The response contains a list of Fish objects.
    )

    data class PaymentResponse(
        val data: List<Map<String, Any>> // The response contains a list of Fish objects.
    )

    data class BobotResponse(
        val data: List<Map<String, Any>> // The response contains a list of Fish objects.
    )

    data class SaveOrderResponse(
        val data: List<Map<String, Any>> // The response contains a list of Fish objects.
    )

    data class GetOrderResponse(
        val data: List<Map<String, Any>> // The response contains a list of Fish objects.
    )

    fun login(
        username: String,
        password: String,
        callback: (String, String?) -> Unit
    ) {
        Log.d("HttpRequest", "Sending login request with username: $username")
        val call = apiRoutes.getAkun(username, password)
        call.enqueue(object : retrofit2.Callback<LoginResponse> {
            override fun onResponse(
                call: Call<LoginResponse>,
                response: Response<LoginResponse>
            ) {
                Log.d("HttpRequest", "Login response received")
                if (response.isSuccessful) {
                    response.body()?.let { loginResponse ->
                        Log.d("HttpRequest", "Login successful: ${loginResponse.isLogin}, Role: ${loginResponse.role}")
                        callback("Login successful: ${loginResponse.isLogin}", loginResponse.role)
                    } ?: run {
                        Log.w("HttpRequest", "Empty response body during login")
                        callback("Error: Empty response body", null)
                    }
                } else {
                    Log.e("HttpRequest", "Login error: ${response.code()} ${response.message()}")
                    callback("Error: ${response.message()}", null)
                }
            }

            override fun onFailure(call: Call<LoginResponse>, t: Throwable) {
                Log.e("HttpRequest", "Login failed: ${t.message}")
                callback("Error: ${t.message}", null)
            }
        })
    }

    // Ensure you're not accessing invalid indices by checking the list size
    fun getStok(callback: (List<Map<String, Any>>) -> Unit) {
        Log.d("HttpRequest", "Sending stok request")
        val call = apiRoutes.getStok() // Assuming this is the correct Retrofit call
        call.enqueue(object : retrofit2.Callback<StokResponse> {
            override fun onResponse(
                call: Call<StokResponse>,
                response: Response<StokResponse>
            ) {
                Log.d("HttpRequest", "Stok response received")

                if (response.isSuccessful) {
                    response.body()?.let { stokResponse ->
                        Log.d("HttpRequest", "Full response body: $stokResponse")

                        // Check if 'data' is null or empty
                        if (stokResponse.data != null && stokResponse.data.isNotEmpty()) {
                            // Return the data directly without transformation
                            callback(stokResponse.data)
                        } else {
                            Log.w("HttpRequest", "Data list is empty or null in response")
                            callback(emptyList()) // Return an empty list if no data is found
                        }
                    } ?: run {
                        Log.w("HttpRequest", "Response body is null")
                        callback(emptyList()) // Return empty list if response body is null
                    }
                } else {
                    Log.e("HttpRequest", "API error: ${response.code()} ${response.message()}")
                    callback(emptyList()) // Return empty list if the API call fails
                }
            }

            override fun onFailure(call: Call<StokResponse>, t: Throwable) {
                Log.e("HttpRequest", "Stok request failed: ${t.message}")
                callback(emptyList()) // Return empty list if the request fails
            }
        })
    }

    fun getSupplier(callback: (List<Map<String, Any>>) -> Unit) {
        Log.d("HttpRequest", "Sending stok request")
        val call = apiRoutes.getSupplier() // Assuming this is the correct Retrofit call
        call.enqueue(object : retrofit2.Callback<SupplierResponse> {
            override fun onResponse(
                call: Call<SupplierResponse>,
                response: Response<SupplierResponse>
            ) {
                Log.d("HttpRequest", "Stok response received")

                if (response.isSuccessful) {
                    response.body()?.let { supplierResponse ->
                        Log.d("HttpRequest", "Full response body: $supplierResponse")

                        // Check if 'data' is null or empty
                        if (supplierResponse.data != null && supplierResponse.data.isNotEmpty()) {
                            // Return the data directly without transformation
                            callback(supplierResponse.data)
                        } else {
                            Log.w("HttpRequest", "Data list is empty or null in response")
                            callback(emptyList()) // Return an empty list if no data is found
                        }
                    } ?: run {
                        Log.w("HttpRequest", "Response body is null")
                        callback(emptyList()) // Return empty list if response body is null
                    }
                } else {
                    Log.e("HttpRequest", "API error: ${response.code()} ${response.message()}")
                    callback(emptyList()) // Return empty list if the API call fails
                }
            }

            override fun onFailure(call: Call<SupplierResponse>, t: Throwable) {
                Log.e("HttpRequest", "Stok request failed: ${t.message}")
                callback(emptyList()) // Return empty list if the request fails
            }
        })
    }

    fun getCustomer(callback: (List<Map<String, Any>>) -> Unit) {
        Log.d("HttpRequest", "Sending stok request")
        val call = apiRoutes.getCustomer() // Assuming this is the correct Retrofit call
        call.enqueue(object : retrofit2.Callback<CustomerResponse> {
            override fun onResponse(
                call: Call<CustomerResponse>,
                response: Response<CustomerResponse>
            ) {
                Log.d("HttpRequest", "Customer response received")

                if (response.isSuccessful) {
                    response.body()?.let { customerResponse ->
                        Log.d("HttpRequest", "Full response body: $customerResponse")

                        // Check if 'data' is null or empty
                        if (customerResponse.data != null && customerResponse.data.isNotEmpty()) {
                            // Return the data directly without transformation
                            callback(customerResponse.data)
                        } else {
                            Log.w("HttpRequest", "Data list is empty or null in response")
                            callback(emptyList()) // Return an empty list if no data is found
                        }
                    } ?: run {
                        Log.w("HttpRequest", "Response body is null")
                        callback(emptyList()) // Return empty list if response body is null
                    }
                } else {
                    Log.e("HttpRequest", "API error: ${response.code()} ${response.message()}")
                    callback(emptyList()) // Return empty list if the API call fails
                }
            }

            override fun onFailure(call: Call<CustomerResponse>, t: Throwable) {
                Log.e("HttpRequest", "Customer request failed: ${t.message}")
                callback(emptyList()) // Return empty list if the request fails
            }
        })
    }

    fun getVarian(callback: (List<Map<String, Any>>) -> Unit) {
        Log.d("HttpRequest", "Sending stok request")
        val call = apiRoutes.getVarian() // Assuming this is the correct Retrofit call
        call.enqueue(object : retrofit2.Callback<VarianResponse> {
            override fun onResponse(
                call: Call<VarianResponse>,
                response: Response<VarianResponse>
            ) {
                Log.d("HttpRequest", "Stok response received")

                if (response.isSuccessful) {
                    response.body()?.let { varianResponse ->
                        Log.d("HttpRequest", "Full response body: $varianResponse")

                        // Check if 'data' is null or empty
                        if (varianResponse.data != null && varianResponse.data.isNotEmpty()) {
                            // Return the data directly without transformation
                            callback(varianResponse.data)
                        } else {
                            Log.w("HttpRequest", "Data list is empty or null in response")
                            callback(emptyList()) // Return an empty list if no data is found
                        }
                    } ?: run {
                        Log.w("HttpRequest", "Response body is null")
                        callback(emptyList()) // Return empty list if response body is null
                    }
                } else {
                    Log.e("HttpRequest", "API error: ${response.code()} ${response.message()}")
                    callback(emptyList()) // Return empty list if the API call fails
                }
            }

            override fun onFailure(call: Call<VarianResponse>, t: Throwable) {
                Log.e("HttpRequest", "Stok request failed: ${t.message}")
                callback(emptyList()) // Return empty list if the request fails
            }
        })
    }

    fun getBobot(callback: (List<Map<String, Any>>) -> Unit) {
        Log.d("HttpRequest", "Sending stok request")
        val call = apiRoutes.getBobot() // Assuming this is the correct Retrofit call
        call.enqueue(object : retrofit2.Callback<BobotResponse> {
            override fun onResponse(
                call: Call<BobotResponse>,
                response: Response<BobotResponse>
            ) {
                Log.d("HttpRequest", "Stok response received")

                if (response.isSuccessful) {
                    response.body()?.let { bobotResponse ->
                        Log.d("HttpRequest", "Full response body: $bobotResponse")

                        // Check if 'data' is null or empty
                        if (bobotResponse.data != null && bobotResponse.data.isNotEmpty()) {
                            // Return the data directly without transformation
                            callback(bobotResponse.data)
                        } else {
                            Log.w("HttpRequest", "Data list is empty or null in response")
                            callback(emptyList()) // Return an empty list if no data is found
                        }
                    } ?: run {
                        Log.w("HttpRequest", "Response body is null")
                        callback(emptyList()) // Return empty list if response body is null
                    }
                } else {
                    Log.e("HttpRequest", "API error: ${response.code()} ${response.message()}")
                    callback(emptyList()) // Return empty list if the API call fails
                }
            }

            override fun onFailure(call: Call<BobotResponse>, t: Throwable) {
                Log.e("HttpRequest", "Stok request failed: ${t.message}")
                callback(emptyList()) // Return empty list if the request fails
            }
        })
    }

    fun saveOrder(
        id: String,
        kodeCustomer: String,
        kodeProduk: String,
        jumlahPesanan: String,
        hargaKg: String,
        shipment: String,
        payment: String,
        totalPenerimaan: String,
        callback: (List<Map<String, Any>>) -> Unit
    ) {
        Log.d("HttpRequest", "Sending order request")

        // Create the request body as a map
        val orderData = mapOf(
            "id" to id,
            "kodeCustomer" to kodeCustomer,
            "kodeProduk" to kodeProduk,
            "jumlahPesanan" to jumlahPesanan,
            "hargaKg" to hargaKg,
            "shipment" to shipment,
            "payment" to payment,
            "totalPenerimaan" to totalPenerimaan
        )

        // Assuming apiRoutes.saveOrder() is a Retrofit method that expects a map of order data
        val call = apiRoutes.saveOrder(orderData) // Pass the order data as parameter

        call.enqueue(object : retrofit2.Callback<SaveOrderResponse> {
            override fun onResponse(
                call: Call<SaveOrderResponse>,
                response: Response<SaveOrderResponse>
            ) {
                Log.d("HttpRequest", "Order response received")

                if (response.isSuccessful) {
                    response.body()?.let { saveOrderResponse ->
                        Log.d("HttpRequest", "Full response body: $saveOrderResponse")

                        // Check if 'data' is null or empty
                        if (saveOrderResponse.data != null && saveOrderResponse.data.isNotEmpty()) {
                            // Return the data directly if it's not null or empty
                            callback(saveOrderResponse.data)
                        } else {
                            Log.w("HttpRequest", "Data list is empty or null in response")
                            callback(emptyList()) // Return an empty list if no data is found
                        }
                    } ?: run {
                        Log.w("HttpRequest", "Response body is null")
                        callback(emptyList()) // Return empty list if response body is null
                    }
                } else {
                    Log.e("HttpRequest", "API error: ${response.code()} ${response.message()}")
                    callback(emptyList()) // Return empty list if the API call fails
                }
            }

            override fun onFailure(call: Call<SaveOrderResponse>, t: Throwable) {
                Log.e("HttpRequest", "Order request failed: ${t.message}")
                callback(emptyList()) // Return empty list if the request fails
            }
        })
    }

    fun getOrder(callback: (List<Map<String, Any>>) -> Unit) {
        Log.d("HttpRequest", "Sending stok request")
        val call = apiRoutes.getOrder() // Assuming this is the correct Retrofit call
        call.enqueue(object : retrofit2.Callback<GetOrderResponse> {
            override fun onResponse(
                call: Call<GetOrderResponse>,
                response: Response<GetOrderResponse>
            ) {
                Log.d("HttpRequest", "Stok response received")

                if (response.isSuccessful) {
                    response.body()?.let { getOrderResponse ->
                        Log.d("HttpRequest", "Full response body: $getOrderResponse")

                        // Check if 'data' is null or empty
                        if (getOrderResponse.data != null && getOrderResponse.data.isNotEmpty()) {
                            // Return the data directly without transformation
                            callback(getOrderResponse.data)
                        } else {
                            Log.w("HttpRequest", "Data list is empty or null in response")
                            callback(emptyList()) // Return an empty list if no data is found
                        }
                    } ?: run {
                        Log.w("HttpRequest", "Response body is null")
                        callback(emptyList()) // Return empty list if response body is null
                    }
                } else {
                    Log.e("HttpRequest", "API error: ${response.code()} ${response.message()}")
                    callback(emptyList()) // Return empty list if the API call fails
                }
            }

            override fun onFailure(call: Call<GetOrderResponse>, t: Throwable) {
                Log.e("HttpRequest", "Stok request failed: ${t.message}")
                callback(emptyList()) // Return empty list if the request fails
            }
        })
    }

    fun getShipment(callback: (List<Map<String, Any>>) -> Unit) {
        Log.d("HttpRequest", "Sending stok request")
        val call = apiRoutes.getShipment() // Assuming this is the correct Retrofit call
        call.enqueue(object : retrofit2.Callback<ShipmentResponse> {
            override fun onResponse(
                call: Call<ShipmentResponse>,
                response: Response<ShipmentResponse>
            ) {
                Log.d("HttpRequest", "Stok response received")

                if (response.isSuccessful) {
                    response.body()?.let { shipmentResponse ->
                        Log.d("HttpRequest", "Full response body: $shipmentResponse")

                        // Check if 'data' is null or empty
                        if (shipmentResponse.data != null && shipmentResponse.data.isNotEmpty()) {
                            // Return the data directly without transformation
                            callback(shipmentResponse.data)
                        } else {
                            Log.w("HttpRequest", "Data list is empty or null in response")
                            callback(emptyList()) // Return an empty list if no data is found
                        }
                    } ?: run {
                        Log.w("HttpRequest", "Response body is null")
                        callback(emptyList()) // Return empty list if response body is null
                    }
                } else {
                    Log.e("HttpRequest", "API error: ${response.code()} ${response.message()}")
                    callback(emptyList()) // Return empty list if the API call fails
                }
            }

            override fun onFailure(call: Call<ShipmentResponse>, t: Throwable) {
                Log.e("HttpRequest", "Stok request failed: ${t.message}")
                callback(emptyList()) // Return empty list if the request fails
            }
        })
    }

    fun getPayment(callback: (List<Map<String, Any>>) -> Unit) {
        Log.d("HttpRequest", "Sending stok request")
        val call = apiRoutes.getPayment() // Assuming this is the correct Retrofit call
        call.enqueue(object : retrofit2.Callback<PaymentResponse> {
            override fun onResponse(
                call: Call<PaymentResponse>,
                response: Response<PaymentResponse>
            ) {
                Log.d("HttpRequest", "Stok response received")

                if (response.isSuccessful) {
                    response.body()?.let { paymentResponse ->
                        Log.d("HttpRequest", "Full response body: $paymentResponse")

                        // Check if 'data' is null or empty
                        if (paymentResponse.data != null && paymentResponse.data.isNotEmpty()) {
                            // Return the data directly without transformation
                            callback(paymentResponse.data)
                        } else {
                            Log.w("HttpRequest", "Data list is empty or null in response")
                            callback(emptyList()) // Return an empty list if no data is found
                        }
                    } ?: run {
                        Log.w("HttpRequest", "Response body is null")
                        callback(emptyList()) // Return empty list if response body is null
                    }
                } else {
                    Log.e("HttpRequest", "API error: ${response.code()} ${response.message()}")
                    callback(emptyList()) // Return empty list if the API call fails
                }
            }

            override fun onFailure(call: Call<PaymentResponse>, t: Throwable) {
                Log.e("HttpRequest", "Stok request failed: ${t.message}")
                callback(emptyList()) // Return empty list if the request fails
            }
        })
    }



}