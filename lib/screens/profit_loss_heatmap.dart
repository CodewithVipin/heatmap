// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:heat_map/model/trading_record.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

// Widget to display profit/loss heatmap grid
class ProfitLossHeatmap extends StatelessWidget {
  final Function onDelete; // Add a callback parameter
  final List<TradingRecord> records;

  const ProfitLossHeatmap({
    super.key,
    required this.records,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(5),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
      ),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        final profitLossPercent = record.investment == 0
            ? 0.0
            : (record.profitOrLoss / record.investment) * 100;

        return InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Colors.grey.shade800,
                title: const Text(
                  "Details",
                  style: TextStyle(color: Colors.white),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Date: ${DateFormat('d MMMM, yyyy').format(record.date)}",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Investment: ${record.investment.toStringAsFixed(2)} Rs.",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Profit/Loss: ${record.profitOrLoss.toStringAsFixed(2)} Rs.",
                      style: TextStyle(
                        color: record.profitOrLoss >= 0
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Profit/Loss %: ${profitLossPercent.toStringAsFixed(2)}%",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      "Close",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await Hive.box('tradingData').deleteAt(index);
                      onDelete(); // Trigger refresh in the parent widget
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Record deleted.")),
                      );
                    },
                    child: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25)),
              color: record.profitOrLoss >= 0
                  ? Colors.teal
                  : Colors.deepOrange.shade400,
            ),
            margin: const EdgeInsets.all(4.0),
            child: Center(
              child: Text(
                "${record.profitOrLoss >= 0 ? '+' : ''}${record.profitOrLoss.toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
        );
      },
    );
  }
}
