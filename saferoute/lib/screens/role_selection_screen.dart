// File: lib/screens/role_selection_screen.dart
import 'package:flutter/material.dart';
import '../widgets/role_button.dart';
import '../routes/route_names.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Select Your Role"),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            RoleButton(
              role: "Parent",
              icon: Icons.person,
              routeName: RouteNames.parentLogin,
            ),
            SizedBox(height: 20),
            RoleButton(
              role: "Driver",
              icon: Icons.directions_bus,
              routeName: RouteNames.driverLogin,
            ),
            SizedBox(height: 20),
            RoleButton(
              role: "Admin",
              icon: Icons.admin_panel_settings,
              routeName: RouteNames.adminLogin,
            ),
          ],
        ),
      ),
    );
  }
}
