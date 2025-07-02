import 'dart:async';
import 'package:flutter/material.dart';
import 'package:saferoute/routes/route_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _fadeController.forward();

    initializeApp();
  }

  Future<void> initializeApp() async {
    // await FirebaseService.initialize(); // already in main.dart

    // await Future.delayed(const Duration(seconds: 2));
    await Future.delayed(const Duration(seconds: 2)); // only animation delay
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(RouteNames.roleSelection);
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Transform(
                  alignment: Alignment.center,
                  transform:
                      Matrix4.identity()
                        ..rotateX(0.1)
                        ..rotateY(0.1),
                  child: RotationTransition(
                    turns: _rotationController,
                    child: CustomPaint(
                      size: const Size(150, 150),
                      painter: CircularLoaderPainter(),
                    ),
                  ),
                ),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 150,
                    height: 150,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SlideTransition(
              position: _slideAnimation,
              child: ShaderMask(
                shaderCallback:
                    (bounds) => const LinearGradient(
                      colors: [Colors.deepOrange, Colors.amber],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                child: const Text(
                  "SafeRoute",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircularLoaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 8.0;
    final radius = (size.width - strokeWidth) / 2;
    final center = size.center(Offset.zero);

    final glowPaint =
        Paint()
          ..strokeWidth = strokeWidth + 4
          ..style = PaintingStyle.stroke
          // ..color = Colors.orange.withOpacity(0.3)
          ..color = Colors.orange.withValues(alpha: 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(center, radius, glowPaint);

    final arcPaint =
        Paint()
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..shader = SweepGradient(
            colors: [Colors.deepOrange, Colors.amber],
            startAngle: 0,
            endAngle: 2 * 3.14,
          ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      1.5 * 3.14,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
