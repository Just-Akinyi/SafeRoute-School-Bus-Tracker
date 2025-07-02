import 'package:flutter/material.dart';
import 'package:saferoute/screens/role_selection_screen.dart';
import 'package:saferoute/services/auth_service.dart';

Future<void> handleLogout(BuildContext context) async {
  try {
    await AuthService().signOut();

    // Navigate to role selection screen and clear backstack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
      (route) => false,
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("⚠️ Logout failed: ${e.toString()}"),
        backgroundColor: Colors.red,
      ),
    );
  }
}

void confirmLogout(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context), // Close the dialog
            ),
            ElevatedButton(
              child: const Text("Logout"),
              onPressed: () async {
                Navigator.pop(context); // Close the dialog first
                try {
                  await handleLogout(context); // Then perform logout
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("⚠️ Error logging out: ${e.toString()}"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        ),
  );
}
