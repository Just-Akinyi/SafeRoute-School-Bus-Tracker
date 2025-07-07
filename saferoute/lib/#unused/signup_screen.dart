//unused for parent driver,admin
// lib/screens/auth/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ✅ Needed for FirebaseAuthException
import 'package:saferoute/services/auth_service.dart';
import 'package:saferoute/screens/auth/email_verification_screen.dart';

class SignupScreen extends StatefulWidget {
  final String role;
  const SignupScreen({super.key, required this.role});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  late BuildContext scaffoldContext;

  final _authService = AuthService();

  void _signup() async {
    setState(() => _isLoading = true);
    try {
      final user = await _authService.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        widget.role,
      );

      if (user != null) {
        if (!mounted) return;

        // ✅ Show success message
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          const SnackBar(
            content: Text("✅ Signup successful! Check your email to verify."),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        await Future.delayed(const Duration(seconds: 1));

        // ✅ Go instantly to verification screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const EmailVerificationScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String errorMessage = e.message ?? "Signup failed. Please try again.";

      if (e.code == 'email-already-in-use') {
        errorMessage = "That email is already registered. Try logging in.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Please enter a valid email address.";
      } else if (e.code == 'weak-password') {
        errorMessage = "Password is too weak. Try something stronger.";
      }

      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        SnackBar(
          content: Text("⚠️ $errorMessage"),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        SnackBar(
          content: Text("⚠️ Unexpected error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Signup")),
      body: Builder(
        builder: (context) {
          scaffoldContext = context;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Signing up as: ${widget.role}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _signup,
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Sign Up"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
