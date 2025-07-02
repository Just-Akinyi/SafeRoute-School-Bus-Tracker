import 'package:flutter/material.dart';
import 'auth/auth_screen.dart';
import '../widgets/role_button.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  void _navigateToAuth(BuildContext context, String role) {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => AuthScreen(role: role)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("⚠️ Failed to open $role login: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false, // ⛔️ Hides back button
        title: const Center(child: Text("Select Your Role")),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoleButton(
              role: "Parent",
              icon: Icons.person,
              onPressed: () => _navigateToAuth(context, "Parent"),
            ),
            const SizedBox(height: 20),
            RoleButton(
              role: "Driver",
              icon: Icons.directions_bus,
              onPressed: () => _navigateToAuth(context, "Driver"),
            ),
            const SizedBox(height: 20),
            RoleButton(
              role: "Admin",
              icon: Icons.admin_panel_settings,
              onPressed: () => _navigateToAuth(context, "Admin"),
            ),
          ],
        ),
      ),
    );
  }
}
