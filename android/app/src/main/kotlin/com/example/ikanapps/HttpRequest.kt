package com.example.ikanapps

import android.content.Context
import android.util.Log
import retrofit2.Call
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.Callback

class HttpRequest(private val context: Context) {

    private val baseUrl = "http://103.139.244.148:5002/" // <- http://103.139.244.148 = ip server atau vps - 5001 = port api na

    /* ieu builder ngarana, builder fungsi na jang nyieun objek meh bisa dipake tiap library beda beda
    tingali we dokumentasi tiap library nu ku maneh pake pasti beda cara nga build objek na
    intina objek ieu isina adalah;
    url api =  http://ip server:port/
    addConverterFactory = jang nga bungkus data na jadi json
     */
    private val retrofit: Retrofit = Retrofit.Builder()
        .baseUrl(baseUrl)
        .addConverterFactory(GsonConverterFactory.create())
        .build()

    private val apiRoutes: ApiRoutes = retrofit.create(ApiRoutes::class.java) // call interface ApiRoutes



    // struktur data respon api login
    data class LoginResponse(
        val isLogin: String
    )

    data class RegisterResponse(
        val isRegister: String
    )

    fun login(
        username: String, // <- parameter username
        password: String, // <- parameter password
        callback: (String) -> Unit // <- parameter callback. naha callback: (String) karena struktur data nu dipake LoginResponse bakal nga return tipe data string. tingali contoh na di white label
    ) {
        val call = apiRoutes.getProducts(username, password)
        call.enqueue(object : retrofit2.Callback<LoginResponse> {
            override fun onResponse(
                call: Call<LoginResponse>,
                response: Response<LoginResponse>
            ) {
                if (response.isSuccessful) { // <- respon sukses
                    response.body()?.let { loginResponse ->
                        Log.d("HttpRequest", "Login status: ${loginResponse.isLogin}")
                        callback(loginResponse.isLogin) // pass respon api ka callback
                    } ?: run {
                        Log.w("HttpRequest", "Empty response body.")
                        callback("Error: Empty response body") // handle mun api teu nga return data
                    }
                } else {
                    Log.e("HttpRequest", "Error: ${response.code()} ${response.message()}")
                    callback("Error: ${response.message()}") // handle mun api nga return error
                }
            }

            override fun onFailure(call: Call<LoginResponse>, t: Throwable) {
                Log.e("HttpRequest", "Network error: ${t.message}")
                callback("Error: ${t.message}") // handle error internet
            }
        })
    }

    fun register(
        nama: String,
        telepon: String,
        alamat: String,
        email: String,
        username: String, // <- parameter username
        password: String, // <- parameter password
        callback: (String) -> Unit // <- parameter callback. naha callback: (String) karena struktur data nu dipake LoginResponse bakal nga return tipe data string. tingali contoh na di white label
    ) {
        val call = apiRoutes.getRegister(nama,telepon,alamat,email, username, password)
        call.enqueue(object : retrofit2.Callback<RegisterResponse> {
            override fun onResponse(
                call: Call<RegisterResponse>,
                response: Response<RegisterResponse>
            ) {
                if (response.isSuccessful) { // <- respon sukses
                    response.body()?.let { registerResponse ->
                        Log.d("HttpRequest", "Register status: ${registerResponse.isRegister}")
                        callback(registerResponse.isLogin) // pass respon api ka callback
                    } ?: run {
                        Log.w("HttpRequest", "Empty response body.")
                        callback("Error: Empty response body") // handle mun api teu nga return data
                    }
                } else {
                    Log.e("HttpRequest", "Error: ${response.code()} ${response.message()}")
                    callback("Error: ${response.message()}") // handle mun api nga return error
                }
            }

            override fun onFailure(call: Call<LoginResponse>, t: Throwable) {
                Log.e("HttpRequest", "Network error: ${t.message}")
                callback("Error: ${t.message}") // handle error internet
            }
        })
    }
}
