// lib/screens/unknown_role_screen.dart
import 'package:flutter/material.dart';
import 'package:saferoute/widgets/logout_util.dart'; // 👈 where handleLogout() lives

class UnknownRoleScreen extends StatelessWidget {
  const UnknownRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Unknown Role")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80, color: Colors.red),
              const SizedBox(height: 24),
              const Text(
                "Oops! Your account doesn't have a valid role assigned.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              const Text(
                "Please contact support or an administrator to fix your role assignment.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => handleLogout(context),
                icon: const Icon(Icons.logout),
                label: const Text("Log Out"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
