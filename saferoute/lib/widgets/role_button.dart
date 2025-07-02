import 'package:flutter/material.dart';

class RoleButton extends StatelessWidget {
  final String role;
  final IconData icon;
  final VoidCallback onPressed;

  const RoleButton({
    super.key,
    required this.role,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 28),
      label: Text(role, style: const TextStyle(fontSize: 20)),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        backgroundColor: Colors.orange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
    );
  }
}
