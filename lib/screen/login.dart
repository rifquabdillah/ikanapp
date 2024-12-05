import 'package:flutter/material.dart';
import 'package:ikanapps/backend/nativeChannel.dart';
import 'package:ikanapps/screen/dashboardScreen.dart';
import 'register.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String username = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/menjala-sq-normal.png', height: 150), // Logo aplikasi
              SizedBox(height: 30),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  hintText: 'Enter your username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  final username = usernameController.text.trim();
                  final password = passwordController.text.trim();

                  if (username.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter username and password')),
                    );
                    return;
                  }

                  try {
                    final response = await NativeChannel.instance.getAkun(username, password);
                    print('Login Success: $response');

                    // Menyimpan username setelah login berhasil
                    setState(() {
                      this.username = username;
                    });

                    // Navigasi ke halaman dashboard
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DashboardScreen(username: this.username, role: '', ), // kirimkan username yang benar
                      ),
                    );
                  } catch (error) {
                    print('Login Failed: $error');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Login Failed: $error')),
                    );
                  }
                },
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50), // Mengatur ukuran tombol agar memenuhi lebar
                  backgroundColor: Colors.blue, // Warna latar belakang tombol
                  foregroundColor: Colors.white, // Warna teks tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Menambahkan sudut melengkung
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15), // Mengatur padding vertikal tombol
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Mengatur ukuran dan ketebalan teks
                ),
              ),

              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: Text('Belum punya akun? Daftar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
