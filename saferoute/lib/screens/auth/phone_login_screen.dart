import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:country_code_picker/country_code_picker.dart';
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
  String _selectedCountryCode = '+254';

  bool _isSendingCode = false;
  bool _isVerifyingCode = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localeCountryCode = Localizations.localeOf(context).countryCode;
    // Auto-set based on device locale
    final defaultCountry = CountryCode.fromCountryCode(
      localeCountryCode ?? 'KE',
    );
    _selectedCountryCode = defaultCountry.dialCode ?? '+254';
  }

  void _sendCode() async {
    setState(() => _isSendingCode = true);
    try {
      await _authService.signInWithPhone(
        '$_selectedCountryCode${_phoneController.text.trim()}',
        (PhoneAuthCredential credential) async {
          try {
            final user = await _authService.signInWithCredential(credential);
            if (user != null && mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const DashboardRouter()),
              );
            }
          } catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Auto-verification failed: $e")),
            );
          }
        },
        (FirebaseAuthException e) {
          if (!mounted) return;
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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send code: ${e.toString()}")),
      );
    } finally {
      if (mounted) setState(() => _isSendingCode = false);
    }
  }

  void _verifyCode() async {
    if (_verificationId == null || _codeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the verification code")),
      );
      return;
    }

    setState(() => _isVerifyingCode = true);
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _codeController.text.trim(),
      );

      final user = await _authService.signInWithCredential(credential);

      if (user != null && mounted) {
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
    } finally {
      if (mounted) setState(() => _isVerifyingCode = false);
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
            // 📱 Phone input with country code picker
            Row(
              children: [
                CountryCodePicker(
                  onChanged: (code) {
                    setState(
                      () => _selectedCountryCode = code.dialCode ?? '+254',
                    );
                  },
                  initialSelection: _selectedCountryCode.replaceAll("+", ""),
                  favorite: ['+254', 'KE'],
                  showFlag: true,
                ),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            _isSendingCode
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                  onPressed: _sendCode,
                  icon: const Icon(Icons.send),
                  label: const Text("Send Code"),
                ),

            if (_verificationId != null) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: "Enter Code"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              _isVerifyingCode
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                    onPressed: _verifyCode,
                    icon: const Icon(Icons.verified_user),
                    label: const Text("Verify & Login"),
                  ),
            ],
          ],
        ),
      ),
    );
  }
}
