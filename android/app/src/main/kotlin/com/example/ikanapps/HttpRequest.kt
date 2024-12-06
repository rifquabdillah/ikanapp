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
        val nama: String,
        val telepon: String,
        val telepon2: String,
        val alamat: String,
        val patokan: String,
        val gps: String
    )

    data class StokResponse(
        val data: List<Fish> // The response contains a list of Fish objects.
    )

    data class Fish(
        val id: Int,   // Fish ID
        val nama: String  // Fish name
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
    fun getStok(callback: (String) -> Unit) {
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
                            // Convert the list of Fish objects to a list of maps
                            val stokList = stokResponse.data.map { fish ->
                                mapOf(
                                    "id" to fish.id,
                                    "nama" to fish.nama
                                )
                            }

                            Log.d("HttpRequest", "Processed stok list as maps: $stokList")

                            // Pass the list of maps to the callback
                            callback("Success: $stokList")
                        } else {
                            Log.w("HttpRequest", "Data list is empty or null in response")
                            callback("Error: No valid stok data found")
                        }
                    } ?: run {
                        Log.w("HttpRequest", "Response body is null")
                        callback("Error: Empty response body")
                    }
                } else {
                    Log.e("HttpRequest", "API error: ${response.code()} ${response.message()}")
                    callback("Error: ${response.message()}")
                }
            }

            override fun onFailure(call: Call<StokResponse>, t: Throwable) {
                Log.e("HttpRequest", "Stok request failed: ${t.message}")
                callback("Error: ${t.message}")
            }
        })
    }






}
