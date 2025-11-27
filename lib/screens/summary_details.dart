// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class SummaryDetails extends StatelessWidget {
  final double targetAmount;
  final double totalInvestment;
  final double avgProfit;
  final double avgProfitPercent;
  final double totalProfit;
  final double coverTarget;

  const SummaryDetails({
    super.key,
    required this.coverTarget,
    required this.targetAmount,
    required this.totalInvestment,
    required this.totalProfit,
    required this.avgProfit,
    required this.avgProfitPercent,
  });

  Color get profitColor => totalProfit >= 0
      ? Colors.greenAccent.shade400
      : Colors.deepOrangeAccent.shade200;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12, width: 0.6),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ------------------------------
          // TARGET AMOUNT + COVER %
          // ------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _label("Target Amount"),

              Text(
                "₹${targetAmount.toStringAsFixed(2)}",
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Cover % pill chip
              _pillChip("${coverTarget.toStringAsFixed(1)}%", profitColor),
            ],
          ),

          const Divider(color: Colors.white12, height: 24),

          // ------------------------------
          // TOTAL INVESTMENT
          // ------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _label("Total Investment"),
              Text(
                "₹${totalInvestment.toStringAsFixed(2)}",
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // ------------------------------
          // P/L % SECTION
          // ------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _titleChip("P/L Percentage"),

              _pillChip("${avgProfitPercent.toStringAsFixed(2)}%", profitColor),
            ],
          ),

          const Divider(color: Colors.white12, height: 26),

          // ------------------------------
          // TOTAL PROFIT/LOSS
          // ------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total P/L",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              _pillChip("₹${totalProfit.toStringAsFixed(2)}", profitColor),
            ],
          ),
        ],
      ),
    );
  }

  // ------------------------------
  // REUSABLE UI COMPONENTS
  // ------------------------------

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.grey.shade400,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _titleChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey.shade300,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _pillChip(String text, Color borderColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: borderColor,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}
