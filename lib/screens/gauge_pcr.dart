// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:heat_map/theme/app_colors.dart';
import 'package:heat_map/widgets/theme_toggle_icon.dart';

class DeepMarketInsight extends StatefulWidget {
  const DeepMarketInsight({super.key});

  @override
  _DeepMarketInsightState createState() => _DeepMarketInsightState();
}

class _DeepMarketInsightState extends State<DeepMarketInsight> {
  final TextEditingController callOiController = TextEditingController();
  final TextEditingController putOiController = TextEditingController();

  double? pcr;
  String marketMood = "Neutral / Wait for Confirmation";
  Color moodColor = Colors.grey;

  void calculatePCR() {
    double? callOi = double.tryParse(callOiController.text);
    double? putOi = double.tryParse(putOiController.text);

    if (callOi == null || putOi == null || callOi == 0 || putOi == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Enter valid numbers. Values should be greater than zero.",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      pcr = putOi / callOi;
      marketMood = _determineMarketMood(callOi, putOi);
    });
  }

  String _determineMarketMood(double callOi, double putOi) {
    double difference = (putOi - callOi).abs();
    double threshold = 0.5 * (callOi < putOi ? callOi : putOi);

    if (pcr! <= 0.5 || pcr! >= 2.0) {
      if (difference > threshold) {
        if (putOi > callOi) {
          moodColor = Colors.green;
          return "Bullish (Buy Call)";
        } else {
          moodColor = Colors.red;
          return "Bearish (Buy Put)";
        }
      }
    }

    moodColor = Colors.grey;
    return "Neutral / Wait for Confirmation";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackgroundColor,

      // ⭐ PREMIUM COFFEE APPBAR
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6D4C41), Color(0xFF4A3128)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(22),
              bottomRight: Radius.circular(22),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 18,
                offset: Offset(0, 6),
              ),
            ],
          ),

          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),

                  // Title
                  const Text(
                    "Deep Market Insight",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),

                  // Theme toggle
                  const ThemeToggleIcon(),
                ],
              ),
            ),
          ),
        ),
      ),

      // ⭐ BODY
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _modernInputField(
              controller: callOiController,
              hint: "Enter Call OI Change",
            ),

            const SizedBox(height: 15),

            _modernInputField(
              controller: putOiController,
              hint: "Enter Put OI Change",
            ),

            const SizedBox(height: 30),

            _gradientButton(),

            const SizedBox(height: 35),

            _resultCard(),

            const SizedBox(height: 20),

            Visibility(
              visible: moodColor != Colors.grey,
              child: Center(
                child: Text(
                  "Vipin! Grab Only 10 Points! 😎",
                  style: TextStyle(
                    fontSize: 18,
                    color: darkTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ⭐ Modern Coffee Input Field
  Widget _modernInputField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),

      decoration: InputDecoration(
        filled: true,
        fillColor: darkTabColor.withOpacity(0.9),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),

        suffixIcon: IconButton(
          icon: const Icon(Icons.close, color: Colors.white70),
          onPressed: () => controller.clear(),
        ),

        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white12),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.tealAccent),
        ),
      ),
    );
  }

  // ⭐ Gradient Button
  Widget _gradientButton() {
    return GestureDetector(
      onTap: calculatePCR,

      child: Container(
        height: 55,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.tealAccent, Colors.green],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.greenAccent.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: const Center(
          child: Text(
            "Analyze Market",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  // ⭐ Market Result Card
  Widget _resultCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: moodColor.withOpacity(0.18),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: moodColor, width: 1.4),
        boxShadow: [
          BoxShadow(
            color: moodColor.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        children: [
          Text(
            "Market Mood",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: darkTextColor,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            marketMood,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: darkTextColor,
            ),
          ),

          if (pcr != null) ...[
            const SizedBox(height: 8),
            Text(
              "PCR: ${pcr!.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: darkTextColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
