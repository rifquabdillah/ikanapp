import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(  // Membungkus dengan SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/menjala-sq-normal.png', height: 100), // Your app logo
                SizedBox(height: 15),

                // Nama Field
                TextField(
                  controller: namaController,
                  decoration: InputDecoration(
                    labelText: 'Nama',
                    hintText: 'Enter your Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 15),

                // Alamat Field
                TextField(
                  controller: alamatController,
                  decoration: InputDecoration(
                    labelText: 'Alamat',
                    hintText: 'Enter your Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.home),
                  ),
                ),
                SizedBox(height: 15),

                // Telepon Field
                TextField(
                  controller: teleponController,
                  decoration: InputDecoration(
                    labelText: 'Telepon',
                    hintText: 'Enter your Phone number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                SizedBox(height: 15),

                // Email Field
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                SizedBox(height: 15),

                // Username Field
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Choose a username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 15),

                // Password Field
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Choose a password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                SizedBox(height: 15),

                // Confirm Password Field
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Confirm your password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                SizedBox(height: 30),

                // Register Button
                ElevatedButton(
                  onPressed: () {
                    // Handle registration logic here
                    if (passwordController.text != confirmPasswordController.text) {
                      // Show error if passwords do not match
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Passwords do not match!")),
                      );
                    } else {
                      // Proceed with registration logic, such as sending data to server
                      // You can call an API to register the user here
                    }
                  },
                  child: Text('Register'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20),

                // Login redirect link
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to Login screen
                  },
                  child: Text('Already have an account? Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
