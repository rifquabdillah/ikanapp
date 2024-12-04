import 'package:flutter/material.dart';
import 'dashboardScreen.dart'; // Ganti dengan layar utama Anda

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(Duration(seconds: 5)); // Durasi splash screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen(username: '', role: '',)), // Layar utama
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe9f0f8), // Warna latar belakang
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/menjala-rct-normal.png', // Ganti dengan path logo Anda
              height: 100,
            ),
            SizedBox(height: 20),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2464a2)),
            ),
          ],
        ),
      ),
    );
  }
}
