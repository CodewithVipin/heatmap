// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:heat_map/model/trading_record.dart';
import 'package:heat_map/theme/app_colors.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class ProfitLossHeatmap extends StatelessWidget {
  final Function(dynamic hiveKey) onDelete;
  final List<TradingRecord> records;
  final List<dynamic> keys;

  const ProfitLossHeatmap({
    super.key,
    required this.records,
    required this.keys,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        final hiveKey = keys[index];

        final profitLossPercent = record.investment == 0
            ? 0.0
            : (record.profitOrLoss / record.investment) * 100;

        final bool isProfit = record.profitOrLoss >= 0;

        return GestureDetector(
          onTap: () =>
              _showDetailsDialog(context, record, hiveKey, profitLossPercent),

          child: Container(
            decoration: BoxDecoration(
              color: isProfit
                  ? Colors.green.withOpacity(0.15)
                  : Colors.red.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),

              border: Border.all(
                color: isProfit
                    ? Colors.greenAccent.shade400
                    : Colors.redAccent.shade200,
                width: 0.8,
              ),

              boxShadow: [
                BoxShadow(
                  color: isProfit
                      ? Colors.greenAccent.withOpacity(0.2)
                      : Colors.redAccent.withOpacity(0.2),
                  blurRadius: 50,
                  spreadRadius: -20,
                ),
              ],
            ),

            child: Center(
              child: Text(
                "${isProfit ? '+' : ''}${record.profitOrLoss.toStringAsFixed(2)}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w200,
                  color: isProfit
                      ? Colors.greenAccent.shade200
                      : Colors.redAccent.shade200,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // -------------------------- DIALOG --------------------------
  void _showDetailsDialog(
    BuildContext context,
    TradingRecord record,
    dynamic hiveKey,
    double percent,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A1F1A), // premium dark coffee
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Record Details",
          style: TextStyle(color: darkTextColor, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow("Date", DateFormat('d MMMM, yyyy').format(record.date)),
            _detailRow(
              "Investment",
              "${record.investment.toStringAsFixed(2)} Rs.",
            ),
            _detailRow(
              "Profit/Loss",
              "${record.profitOrLoss >= 0 ? '+' : ''}${record.profitOrLoss.toStringAsFixed(2)} Rs.",
              color: record.profitOrLoss >= 0 ? Colors.green : Colors.red,
            ),
            _detailRow("P/L %", "${percent.toStringAsFixed(2)}%"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () async {
              await Hive.box('tradingData').delete(hiveKey);
              onDelete(hiveKey);
              Navigator.of(context).pop();

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Record deleted.")));
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------- DETAIL ROW WIDGET --------------------------
  Widget _detailRow(String title, String value, {Color color = darkTextColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
