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
        val role: String
    )

    data class RegisterResponse(
        val isRegister: String
    )

    data class StokResponse(
        val isStok: String
    )


    data class CustomerResponse(
        val isCustomer: String
    )


    fun login(
        username: String,  // Parameter username
        password: String,  // Parameter password
        callback: (String, String?) -> Unit // Callback untuk mengembalikan status dan role
    ) {
        val call = apiRoutes.getAkun(username, password)  // Memanggil API login
        call.enqueue(object : retrofit2.Callback<LoginResponse> {
            override fun onResponse(
                call: Call<LoginResponse>,
                response: Response<LoginResponse>
            ) {
                if (response.isSuccessful) {  // Jika respon sukses
                    response.body()?.let { loginResponse ->
                        Log.d("HttpRequest", "Login status: ${loginResponse.isLogin}")
                        // Kirim status login dan role ke callback
                        callback("Login successful: ${loginResponse.isLogin}", loginResponse.role)
                    } ?: run {
                        Log.w("HttpRequest", "Empty response body.")
                        callback("Error: Empty response body", null)  // Menangani jika response kosong
                    }
                } else {
                    Log.e("HttpRequest", "Error: ${response.code()} ${response.message()}")
                    callback("Error: ${response.message()}", null)  // Menangani jika API mengembalikan error
                }
            }

            override fun onFailure(call: Call<LoginResponse>, t: Throwable) {
                Log.e("HttpRequest", "Network error: ${t.message}")
                callback("Error: ${t.message}", null)  // Menangani jika ada kesalahan jaringan
            }
        })
    }


    fun getStok(
        nama: String, // <- parameter username
        harga: String, // <- parameter password
        callback: (String) -> Unit // <- parameter callback. naha callback: (String) karena struktur data nu dipake LoginResponse bakal nga return tipe data string. tingali contoh na di white label
    ) {
        val call = apiRoutes.getStok(nama, harga)
        call.enqueue(object : retrofit2.Callback<StokResponse> {
            override fun onResponse(
                call: Call<StokResponse>,
                response: Response<StokResponse>
            ) {
                if (response.isSuccessful) { // <- respon sukses
                    response.body()?.let { stokResponse ->
                        Log.d("HttpRequest", "Stok status: ${stokResponse.isStok}")
                        callback(stokResponse.isStok) // pass respon api ka callback
                    } ?: run {
                        Log.w("HttpRequest", "Empty response body.")
                        callback("Error: Empty response body") // handle mun api teu nga return data
                    }
                } else {
                    Log.e("HttpRequest", "Error: ${response.code()} ${response.message()}")
                    callback("Error: ${response.message()}") // handle mun api nga return error
                }
            }

            override fun onFailure(call: Call<StokResponse>, t: Throwable) {
                Log.e("HttpRequest", "Network error: ${t.message}")
                callback("Error: ${t.message}")
            }
        })
    }

    fun getCustomer(
        nama: String,
        telepon: String,
        telepon2: String,// <- parameter username
        alamat: String,
        patokan: String,
        gps:String,// <- parameter password
        callback: (String) -> Unit // <- parameter callback. naha callback: (String) karena struktur data nu dipake LoginResponse bakal nga return tipe data string. tingali contoh na di white label
    ) {
        val call = apiRoutes.getCustomer(nama, telepon, telepon2, alamat, patokan, gps)
        call.enqueue(object : retrofit2.Callback<CustomerResponse> {
            override fun onResponse(
                call: Call<CustomerResponse>,
                response: Response<CustomerResponse>
            ) {
                if (response.isSuccessful) { // <- respon sukses
                    response.body()?.let { customerResponse ->
                        Log.d("HttpRequest", "Customer status: ${customerResponse.isCustomer}")
                        callback(customerResponse.isCustomer) // pass respon api ka callback
                    } ?: run {
                        Log.w("HttpRequest", "Empty response body.")
                        callback("Error: Empty response body") // handle mun api teu nga return data
                    }
                } else {
                    Log.e("HttpRequest", "Error: ${response.code()} ${response.message()}")
                    callback("Error: ${response.message()}") // handle mun api nga return error
                }
            }

            override fun onFailure(call: Call<CustomerResponse>, t: Throwable) {
                Log.e("HttpRequest", "Network error: ${t.message}")
                callback("Error: ${t.message}") // handle error internet
            }
        })
    }

}
