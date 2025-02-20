// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:heat_map/model/trading_record.dart';
import 'package:heat_map/screens/profit_loss_heatmap.dart';
import 'package:heat_map/screens/summary_details.dart';
import 'package:hive/hive.dart';

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

    double targetAmount = 100000;
    double coverTarget = (totalProfit / targetAmount) * 100;

    return Scaffold(
      backgroundColor: ThemeData.dark().scaffoldBackgroundColor,
      appBar: AppBar(
          backgroundColor: Colors.grey.shade800,
          title: const Text("Profit/Loss Heatmap")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _tradingDataBox.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SummaryDetails(
                    coverTarget: coverTarget,
                    targetAmount: targetAmount,
                    totalProfit: totalProfit,
                    totalInvestment: totalInvestment,
                    avgProfit: avgProfit,
                    avgProfitPercent: avgProfitPercent,
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                      child: ProfitLossHeatmap(
                    records: records,
                    onDelete: () => setState(() {}),
                  )),
                ],
              )
            : Center(
                child: Text(
                  "No Analytics!",
                  style: TextStyle(fontSize: 18),
                ),
              ),
      ),
      floatingActionButton: Visibility(
        visible: _tradingDataBox.isNotEmpty,
        child: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 190, 127, 127),
          onPressed: () async {
            if (_tradingDataBox.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Nothing to delete!")),
              );
              return;
            }

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
                    child: const Text("Delete",
                        style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );

            if (deleteConfirmed == true) {
              await _tradingDataBox.clear();
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("All records deleted.")),
              );
            }
          },
          child: const Icon(Icons.delete),
        ),
      ),
    );
  }
}
