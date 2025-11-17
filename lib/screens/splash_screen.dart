// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:heat_map/screens/land_screen.dart';
import 'package:heat_map/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> fadeIn;
  late Animation<Offset> slideUp;

  @override
  void initState() {
    super.initState();

    // Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    fadeIn = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    slideUp = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Start animation
    _controller.forward();

    // Navigate after delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LandScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Coffee Gradient Background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF3E2723), // Deep coffee
              Color(0xFF1A120D), // Dark roast
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Center(
          child: FadeTransition(
            opacity: fadeIn,
            child: SlideTransition(
              position: slideUp,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App Title
                  Text(
                    "Option Trading App",
                    style: TextStyle(
                      color: darkTextColor,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.7,
                      shadows: [
                        Shadow(color: Colors.grey.shade300, blurRadius: 10),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Tagline (optional)
                  Text(
                    "Powered by Vipin Maurya",
                    style: TextStyle(
                      color: Colors.grey.shade200,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
