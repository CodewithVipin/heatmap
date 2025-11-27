// ignore_for_file: deprecated_member_use

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
                // ------------------------------------------------------
                // ⭐ ZERO Flicker Premium Hero Header
                // ------------------------------------------------------
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    decoration: BoxDecoration(
                      // 🔥 PREMIUM DUAL-TONE GLOW EFFECT
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.08),
                          blurRadius: 12,
                          spreadRadius: 1,
                          offset: const Offset(-4, -4), // upper soft glow
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.35),
                          blurRadius: 18,
                          spreadRadius: 6,
                          offset: const Offset(4, 6), // bottom shadow depth
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(12)),

                      border: Border.all(
                        color: Colors.white.withOpacity(0.12),
                        width: 1.2,
                      ),
                    ),
                    child: Material(
                      color: darkTabColor,
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: const [
                            SizedBox(height: 5),
                            Text(
                              "Analyse • Trade • Grow",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: darkTextColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Smart Option Trading Starts Here",
                              textAlign: TextAlign
                                  .center, // ← stops micro overflow jump
                              style: TextStyle(
                                color: darkTextColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // ------------------------------------------------------
                // MAIN CARD
                // ------------------------------------------------------
                Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: darkTabColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),

                  child: Column(
                    children: [
                      // ---------------- PCR SCREEN -----------------
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
                                builder: (_) => const DeepMarketInsight(),
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

                      const SizedBox(height: 20),

                      // ---------------- RECORD SCREEN -----------------
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
                                builder: (_) => const RecordEntryScreen(),
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
