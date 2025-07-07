import 'package:flutter/material.dart';
import 'package:saferoute/screens/unknown_role_screen.dart';
import 'package:saferoute/services/auth_service.dart';
import 'package:saferoute/screens/dashboard/admin_dashboard.dart';
import 'package:saferoute/screens/dashboard/driver_dashboard.dart';
import 'package:saferoute/screens/dashboard/parent_dashboard.dart';

class DashboardRouter extends StatelessWidget {
  const DashboardRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final user = auth.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return FutureBuilder<String?>(
      future: auth.getUserRole(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text("Failed to load user role.")),
          );
        }

        final role = snapshot.data!;

        // ✅ Optional debug log
        if (!['Admin', 'Driver', 'Parent'].contains(role)) {
          print("❌ Unknown role '$role' for UID: ${user.uid}");
        }

        // ✅ Role-based routing
        switch (role) {
          case 'Admin':
            return const AdminDashboard();
          case 'Driver':
            return const DriverDashboard();
          case 'Parent':
            return const ParentDashboard();
          default:
            return const UnknownRoleScreen();
        }
      },
    );
  }
}
