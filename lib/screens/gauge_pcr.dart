// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';

class DeepMarketInsight extends StatefulWidget {
  const DeepMarketInsight({super.key});

  @override
  _DeepMarketInsightState createState() => _DeepMarketInsightState();
}

class _DeepMarketInsightState extends State<DeepMarketInsight> {
  void Function()? onPressed;
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
        SnackBar(
          content: Text(
              "Enter valid numbers. Call and Put OI Change should be greater than zero."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      pcr = putOi / callOi; // Calculate PCR
      marketMood = _determineMarketMood(callOi, putOi);
    });
  }

  String _determineMarketMood(double callOi, double putOi) {
    double difference = (putOi - callOi).abs();
    double threshold = 0.5 * (callOi < putOi ? callOi : putOi);

    // Strict Condition: Only show Buy Call or Buy Put if PCR is <= 0.5 or >= 2
    if (pcr! <= 0.5 || pcr! >= 2.0) {
      if (difference > threshold) {
        // Still applying 50% OI difference rule
        if (putOi > callOi) {
          moodColor = Colors.green;
          return "Bullish (Buy Call)";
        } else {
          moodColor = Colors.red;
          return "Bearish (Buy Put)";
        }
      }
    }

    // Otherwise, show Neutral
    moodColor = Colors.grey;
    return "Neutral / Wait for Confirmation";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title:
            Text("Deep Market Insight", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(callOiController, "Enter Call OI Change", () {
                setState(() {
                  callOiController.clear();
                });
              }),
              SizedBox(height: 10),
              _buildTextField(putOiController, "Enter Put OI Change", () {
                setState(() {
                  putOiController.clear();
                });
              }),
              SizedBox(height: 20),
              _buildGradientButton(),
              SizedBox(height: 30),
              _buildResultCard(),
              SizedBox(height: 30),
              Visibility(
                visible: moodColor != Colors.grey,
                child: Center(
                    child: Text(
                  "Vipin! Only Grab 10 Points!",
                  style: TextStyle(fontSize: 18),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      void Function()? onPressed) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        suffix: IconButton(onPressed: onPressed, icon: Icon(Icons.close)),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildGradientButton() {
    return GestureDetector(
      onTap: calculatePCR,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.teal, Colors.greenAccent]),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            "Analyze Market",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: moodColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: moodColor, width: 1.5),
        boxShadow: [
          BoxShadow(color: moodColor.withOpacity(0.5), blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Market Mood",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(height: 8),
          Text(marketMood,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: moodColor)),
          if (pcr != null) ...[
            SizedBox(height: 8),
            Text(
              "PCR: ${pcr!.toStringAsFixed(2)}",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }
}
