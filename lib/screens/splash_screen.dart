// ignore_for_file: use_build_context_synchronously, deprecated_member_use

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

    // Animation Controller (Perfect Timing)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    fadeIn = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    slideUp = Tween<Offset>(
      begin: const Offset(0, 0.22),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    // Start animation
    _controller.forward();

    // Navigate with smooth fade transition after animation ends
    Future.delayed(const Duration(milliseconds: 1600), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, animation, _) {
            return FadeTransition(
              opacity: animation,
              child: const LandScreen(),
            );
          },
        ),
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
      body: Container(
        // Premium Coffee Gradient Background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4E342E), // Rich Coffee
              Color(0xFF1A120D), // Dark Roast
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: fadeIn,
              child: SlideTransition(
                position: slideUp,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// 🔥 Smooth Hero Title (Matches LandScreen)
                    Hero(
                      tag: "trading_header",
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          "Option Trading App",
                          style: TextStyle(
                            color: darkTextColor,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      "Powered by Vipin Maurya",
                      style: TextStyle(
                        color: Colors.grey.shade200,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
