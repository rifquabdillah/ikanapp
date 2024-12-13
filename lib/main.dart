import 'package:flutter/material.dart';// Impor StockProvider
import 'package:ikanapps/backend/nativeChannel.dart';
import 'package:ikanapps/provider/StockProvider.dart';
import 'package:ikanapps/model/Stock.dart';
import 'package:ikanapps/screen/dashboardScreen.dart';
import 'package:ikanapps/screen/login.dart';
import 'package:ikanapps/screen/splashScreen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NativeChannel.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StockProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'POS Ikan',
        theme: ThemeData(
          fontFamily: 'Montserrat',
          primarySwatch: Colors.blue,
        ),
        home:  LoginScreen(),
      ),
    );
  }
}
