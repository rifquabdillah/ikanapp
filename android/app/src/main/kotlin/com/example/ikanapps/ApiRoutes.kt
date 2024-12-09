package com.example.ikanapps

import retrofit2.Call
import retrofit2.http.GET
import retrofit2.http.Query


// ieu interface jang nyimpen kabeh tujuan atau endpoint api na
interface ApiRoutes {
    // tujuan atau endpont api jang login
    @GET("login")
    fun getAkun(
        // @Query("ieu kudu sarua jeung parameter nu di api golang")
        @Query("username") username: String?, // <- username = nama variabel na - String? = tipe data na mun aya tipe data akhir na make tanda tanya berarti bisa null
        @Query("password") password: String?,
    ): Call<HttpRequest.LoginResponse> // <- HttpRequest.LoginResponse = struktur data nu bakal di hasilkeun ti api na


    @GET("register")
    fun getRegister(
        // @Query("ieu kudu sarua jeung parameter nu di api golang")
        @Query("nama") nama: String?, // <- username = nama variabel na - String? = tipe data na mun aya tipe data akhir na make tanda tanya berarti bisa null
        @Query("telepon") telepon: String?,
        @Query("alamat") alamat: String?, // <- username = nama variabel na - String? = tipe data na mun aya tipe data akhir na make tanda tanya berarti bisa null
        @Query("username") username: String?, // <- username = nama variabel na - String? = tipe data na mun aya tipe data akhir na make tanda tanya berarti bisa null
        @Query("password") password: String?,
        password1: String,
    ): Call<HttpRequest.RegisterResponse> // <- HttpRequest.LoginResponse = struktur data nu bakal di hasilkeun ti api na

    @GET("customer")
    fun getCustomer(
    ): Call<HttpRequest.CustomerResponse>


    @GET("get-stok")
    fun getStok(
    ): Call<HttpRequest.StokResponse> // <- HttpRequest.LoginResponse = struktur data nu bakal di hasilkeun ti api na

    @GET("supplier")
    fun getSupplier(
    ): Call<HttpRequest.SupplierResponse>

    @GET("varian")
    fun getVarian(
    ): Call<HttpRequest.VarianResponse>

    @GET("shipment")
    fun getShipment(
    ): Call<HttpRequest.ShipmentResponse>

    @GET("payment")
    fun getPayment(
    ): Call<HttpRequest.PaymentResponse>

    @GET("bobot")
    fun getBobot(
    ): Call<HttpRequest.BobotResponse>

    @GET("save")
    fun saveOrder(
    ): Call<HttpRequest.SaveOrderResponse>

    @GET("get-order")
    fun getOrder(
    ): Call<HttpRequest.GetOrderResponse>
}
