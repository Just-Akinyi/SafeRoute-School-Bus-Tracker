import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // 🌐 Required for .tr() and setLocale
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
        title: Text("select_role".tr()), // 🌍 Translated title
        backgroundColor: Colors.orange,
        actions: [
          Builder(
            // ✅ Wrap in Builder to access EasyLocalization context
            builder:
                (context) => PopupMenuButton<Locale>(
                  icon: const Icon(Icons.language),
                  onSelected: (locale) {
                    context.setLocale(locale); // ✅ Locale switch now works
                  },
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(
                          value: const Locale('en'),
                          child: Text('english'.tr()), // 🔤 Translated label
                        ),
                        PopupMenuItem(
                          value: const Locale('sw'),
                          child: Text('swahili'.tr()), // 🔤 Translated label
                        ),
                        PopupMenuItem(
                          value: const Locale('fr'),
                          child: const Text("Français"),
                        ),
                        PopupMenuItem(
                          value: const Locale('ar'),
                          child: const Text("العربية"),
                        ),
                        PopupMenuItem(
                          value: const Locale('hi'),
                          child: const Text("हिन्दी"),
                        ),
                        PopupMenuItem(
                          value: const Locale('es'),
                          child: const Text("Español"),
                        ),
                        PopupMenuItem(
                          value: const Locale('de'),
                          child: const Text("Deutsch"),
                        ),
                        PopupMenuItem(
                          value: const Locale('zh'),
                          child: const Text("中文"),
                        ),
                      ],
                ),
          ),
        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoleButton(
              role:
                  "Parent", // 👈 You can translate this later with .tr() if needed
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
