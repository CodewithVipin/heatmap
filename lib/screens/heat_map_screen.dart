// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:heat_map/model/trading_record.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class HeatmapScreen extends StatefulWidget {
  const HeatmapScreen({super.key});

  @override
  _HeatmapScreenState createState() => _HeatmapScreenState();
}

class _HeatmapScreenState extends State<HeatmapScreen> {
  final Box _tradingDataBox = Hive.box('tradingData');

  @override
  Widget build(BuildContext context) {
    List<TradingRecord> records = _tradingDataBox.values
        .map((e) => TradingRecord.fromMap(Map<String, dynamic>.from(e)))
        .toList();

    double totalProfit =
        records.fold(0.0, (sum, record) => sum + record.profitOrLoss);
    double totalInvestment =
        records.fold(0.0, (sum, record) => sum + record.investment);
    double avgProfit = records.isEmpty ? 0.0 : totalProfit / records.length;
    double avgProfitPercent =
        totalInvestment == 0 ? 0.0 : (totalProfit / totalInvestment) * 100;

    return Scaffold(
      backgroundColor: ThemeData.dark().scaffoldBackgroundColor,
      appBar: AppBar(
          backgroundColor: Colors.grey.shade800,
          title: const Text("Profit/Loss Heatmap")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.grey.shade800,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Investment: ",
                        style: TextStyle(
                            color: Colors.grey.shade300,
                            fontWeight: FontWeight.bold)),
                    Text("${totalInvestment.toStringAsFixed(2)} Rs.",
                        style: TextStyle(
                            color: Colors.grey.shade300,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.grey.shade700,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Average Profit/Loss: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${avgProfit.toStringAsFixed(2)} Rs.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.grey.shade500,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Average Profit %:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      " ${avgProfitPercent.toStringAsFixed(2)} %",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(5),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5),
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final record = records[index];
                  final profitLossPercent = record.investment == 0
                      ? 0.0
                      : (record.profitOrLoss / record.investment) * 100;

                  return InkWell(
                    onTap: () {
                      // Show details dialog on tap
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.grey.shade800,
                          title: const Text("Details",
                              style: TextStyle(color: Colors.white)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Date: ${DateFormat('d MMMM, yyyy - hh:mm a').format(record.date)}",
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
                          ],
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: record.profitOrLoss >= 0
                            ? const Color.fromARGB(255, 125, 147, 104)
                            : const Color.fromARGB(255, 190, 127, 127),
                      ),
                      margin: const EdgeInsets.all(5.0),
                      child: Center(
                        child: Text(
                          "${record.profitOrLoss >= 0 ? '+' : ''}${record.profitOrLoss.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 190, 127, 127),
        onPressed: () async {
          if (_tradingDataBox.isEmpty) {
            // Show snackbar if there are no records
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Nothing to delete!")),
            );
            return;
          }

          // Confirmation dialog before deleting
          final deleteConfirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Delete All Records"),
              content: const Text(
                  "Are you sure you want to delete all records? This action cannot be undone."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child:
                      const Text("Delete", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );

          // If deletion is confirmed, proceed to clear the box and update the UI
          if (deleteConfirmed == true) {
            await _tradingDataBox.clear(); // Clear all records in the box
            setState(() {}); // Rebuild the UI immediately
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("All records deleted.")),
            );
          }
        },
        child: const Icon(Icons.delete),
      ),
    );
  }
}
