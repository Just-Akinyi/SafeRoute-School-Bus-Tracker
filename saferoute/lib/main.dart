import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:saferoute/routes/route_names.dart';
import 'package:saferoute/screens/splash_screen.dart';
import 'package:saferoute/screens/role_selection_screen.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await dotenv.load();
  print("🟡 Flutter binding done");

  try {
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      print("🟡 Firebase initializing...");
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print("✅ Firebase initialized.");
    } else {
      print("🚫 Firebase not supported on this platform.");
    }
  } catch (e, stack) {
    print("❌ Firebase error: $e");
    print(stack);
  }

  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeRoute',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: RouteNames.splash,
      routes: {
        RouteNames.splash: (_) => const SplashScreen(),
        RouteNames.roleSelection: (_) => const RoleSelectionScreen(),
      },
    );
  }
}
