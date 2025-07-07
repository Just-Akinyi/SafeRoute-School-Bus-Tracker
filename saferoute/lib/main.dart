import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:saferoute/screens/dashboard/dashboard_router.dart';
import 'firebase_options.dart';
import 'package:easy_localization/easy_localization.dart'; // 🌐 Added for localization
import 'package:saferoute/routes/route_names.dart';
import 'package:saferoute/screens/splash_screen.dart';
import 'package:saferoute/screens/role_selection_screen.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await EasyLocalization.ensureInitialized(); // 🌐 Init i18n
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

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'), // English
        Locale('sw'), // Swahili
        Locale('fr'), // French
        Locale('ar'), // Arabic
        Locale('hi'), // Hindi
        Locale('es'), // Spanish
        Locale('de'), // German
        Locale('zh'), // Chinese (Simplified)
      ],
      path: 'assets/lang', // 🌍 Path to your translation JSONs
      fallbackLocale: Locale('en'),
      child: const MyApp(),
    ),
  );
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
      // 🌍 Localization support
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      initialRoute: RouteNames.splash,
      routes: {
        RouteNames.splash: (_) => const SplashScreen(),
        RouteNames.roleSelection: (_) => const RoleSelectionScreen(),
        '/dashboard': (_) => const DashboardRouter(),
      },
    );
  }
}
