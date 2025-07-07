//unused cause they aren't signingup
// lib/screens/auth/email_verification_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saferoute/screens/dashboard/dashboard_router.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _checking = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoCheck();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoCheck() {
    _timer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _checkVerification(silent: true),
    );
  }

  Future<void> _checkVerification({bool silent = false}) async {
    setState(() => _checking = true);

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        if (!silent) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("No user found. Please log in again."),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      await user.reload(); // Refresh user info from Firebase
      final refreshedUser = FirebaseAuth.instance.currentUser;

      if (refreshedUser != null && refreshedUser.emailVerified) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Email verified! Redirecting..."),
            backgroundColor: Colors.green,
          ),
        );
        _timer?.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardRouter()),
        );
      } else if (!silent) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("❌ Email not verified yet. Please check your inbox."),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (!silent) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("⚠️ Error checking verification: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  Future<void> _resendEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("📩 Verification email resent!"),
          backgroundColor: Colors.blue,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("⚠️ Failed to resend email: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Email")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "📩 We've sent a verification link to your email.\n"
              "Please check your inbox and verify your account.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const Text(
              "Once you've verified, press the button or wait for auto-check.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            _checking
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton.icon(
                  onPressed: () => _checkVerification(),
                  icon: const Icon(Icons.verified),
                  label: const Text("I Have Verified"),
                ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: _resendEmail,
              icon: const Icon(Icons.refresh),
              label: const Text("Resend Verification Email"),
            ),
          ],
        ),
      ),
    );
  }
}
