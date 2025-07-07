import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saferoute/services/auth_service.dart';

class GoogleSvgButton extends StatelessWidget {
  final String expectedRole;

  const GoogleSvgButton({super.key, required this.expectedRole});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          final user = await AuthService().signInWithGoogle();
          if (user == null) return;

          final storedRole = await AuthService().getUserRole(user.uid);

          if (storedRole == expectedRole) {
            Navigator.pushReplacementNamed(context, '/dashboard');
          } else {
            await AuthService().signOut();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Role mismatch. Access denied."),
                backgroundColor: Colors.red,
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
          );
        }
      },
      child: SvgPicture.asset(
        'assets/icons/g_rectangle.svg',
        width: double.infinity, // full width if SVG supports it
        height: 48, // typical height
        fit: BoxFit.contain,
      ),
    );
  }
}
