// lib/screens/dashboard/parent_dashboard.dart
import 'package:flutter/material.dart';
import '../../widgets/logout_util.dart'; // if you moved it here

class ParentDashboard extends StatelessWidget {
  const ParentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parent Dashboard"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            // onPressed: () => handleLogout(context),
            onPressed: () => confirmLogout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: const Center(child: Text("Welcome, Parent!")),
    );
  }
}
