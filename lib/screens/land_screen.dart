import 'package:flutter/material.dart';
import 'package:heat_map/screens/gauge_pcr.dart';
import 'package:heat_map/screens/record_entry_screen.dart';
import 'package:heat_map/theme/app_colors.dart';

class LandScreen extends StatelessWidget {
  const LandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBarBackgroundColor,
        title: const Text("Trading World!"),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// ------------------------------------
                /// 🔥 PREMIUM ANIMATED TRADING TEXT
                /// ------------------------------------
                TweenAnimationBuilder<double>(
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeInOut,
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, (1 - value) * 20),
                        child: child,
                      ),
                    );
                  },
                  child: const Text(
                    "Analyse • Trade • Grow",
                    style: TextStyle(
                      color: darkTextColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1800),
                  curve: Curves.easeOutQuad,
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.scale(scale: value, child: child),
                    );
                  },
                  child: const Text(
                    "Smart Option Trading Starts Here",
                    style: TextStyle(
                      color: darkTextColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                /// ------------------------------------
                /// MAIN CARD WITH BUTTONS
                /// ------------------------------------
                Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: darkTabColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),

                  child: Column(
                    children: [
                      /// Button 1
                      SizedBox(
                        width: double.infinity,
                        child: MaterialButton(
                          height: 48,
                          color: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DeepMarketInsight(),
                              ),
                            );
                          },
                          child: const Text(
                            'Gauge PCR',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: darkTextColor,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      /// Button 2
                      SizedBox(
                        width: double.infinity,
                        child: MaterialButton(
                          height: 48,
                          color: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RecordEntryScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Go To Record Screen',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: darkTextColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
