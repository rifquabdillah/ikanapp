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


    // Ensure you're not accessing invalid indices by checking the list size
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



}