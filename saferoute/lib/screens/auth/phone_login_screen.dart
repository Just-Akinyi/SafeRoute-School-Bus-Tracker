import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saferoute/services/auth_service.dart';
import 'package:saferoute/screens/dashboard/dashboard_router.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _authService = AuthService();
  String? _verificationId;

  void _sendCode() async {
    try {
      await _authService.signInWithPhone(
        _phoneController.text.trim(),
        (PhoneAuthCredential credential) async {
          try {
            final user = await _authService.signInWithCredential(credential);
            if (user != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const DashboardRouter()),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Auto-verification failed: $e")),
            );
          }
        },
        (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? "Phone verification failed")),
          );
        },
        (String verificationId, int? resendToken) {
          setState(() => _verificationId = verificationId);
        },
        (String verificationId) {
          setState(() => _verificationId = verificationId);
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send code: ${e.toString()}")),
      );
    }
  }

  void _verifyCode() async {
    if (_verificationId == null || _codeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the verification code")),
      );
      return;
    }

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _codeController.text.trim(),
      );

      final user = await _authService.signInWithCredential(credential);

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardRouter()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error verifying code: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Phone Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: "Phone (+254...)"),
              keyboardType: TextInputType.phone,
            ),
            ElevatedButton(
              onPressed: _sendCode,
              child: const Text("Send Code"),
            ),
            if (_verificationId != null) ...[
              TextField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: "Enter Code"),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: _verifyCode,
                child: const Text("Verify & Login"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
