import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'phone_login_screen.dart';
import '../role_selection_screen.dart';

class AuthScreen extends StatefulWidget {
  final String role;
  const AuthScreen({super.key, required this.role});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // final _authService = AuthService(); // help to log out

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Future<void> _handleBack() async {
  //   await _authService.signOut(); // 🔒 Logout user
  //   if (mounted) {
  //     Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
  //       (route) => false, // remove all previous routes
  //     );
  //   }
  // }

  // void _handleBack() {
  //   Navigator.pop(context);
  // }

  void _handleBack() {
    try {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("⚠️ Error navigating back: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("${widget.role} Authentication")),
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: "Login"), Tab(text: "Phone Login")],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleBack,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [LoginScreen(role: widget.role), const PhoneLoginScreen()],
      ),
    );
  }
}
