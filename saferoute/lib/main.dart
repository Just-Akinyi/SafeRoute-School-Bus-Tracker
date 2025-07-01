import 'package:flutter/material.dart';
import 'package:saferoute/screens/admin_login.dart';
import 'package:saferoute/screens/driver_login.dart';
import 'package:saferoute/screens/parent_login.dart';
import 'package:saferoute/screens/role_selection_screen.dart';
import 'package:saferoute/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeRoute',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const SplashScreen(), // ✅ Now properly referenced
      routes: {
        '/roleSelection': (context) => const RoleSelectionScreen(),
        '/parentLogin': (context) => const ParentLoginScreen(),
        '/driverLogin': (context) => const DriverLoginScreen(),
        '/adminLogin': (context) => const AdminLoginScreen(),
      },
    );
  }
}
