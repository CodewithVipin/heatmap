// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:heat_map/model/trading_record.dart';
import 'package:heat_map/screens/profit_loss_heatmap.dart';
import 'package:heat_map/screens/summary_details.dart';
import 'package:heat_map/theme/app_colors.dart';
import 'package:hive/hive.dart';

class HeatmapScreen extends StatefulWidget {
  const HeatmapScreen({super.key});

  @override
  _HeatmapScreenState createState() => _HeatmapScreenState();
}

class _HeatmapScreenState extends State<HeatmapScreen> {
  final Box _tradingDataBox = Hive.box('tradingData');

  double _parseToDoubleSafe(dynamic raw, [double fallback = 0.0]) {
    if (raw == null) return fallback;
    if (raw is double) return raw;
    if (raw is int) return raw.toDouble();
    if (raw is num) return raw.toDouble();
    if (raw is String) return double.tryParse(raw) ?? fallback;
    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    // Collect only map entries (records)
    final entries = _tradingDataBox.toMap().entries.where(
      (e) => e.value is Map,
    );

    final keys = entries.map((e) => e.key).toList();
    final records = entries
        .map((e) => TradingRecord.fromMap(Map<String, dynamic>.from(e.value)))
        .toList();

    // Summaries
    final double totalProfit = records.fold(
      0.0,
      (sum, r) => sum + _parseToDoubleSafe(r.profitOrLoss),
    );
    final double totalInvestment = records.fold(
      0.0,
      (sum, r) => sum + _parseToDoubleSafe(r.investment),
    );
    final double avgProfit = records.isEmpty
        ? 0.0
        : totalProfit / records.length;
    final double avgProfitPercent = totalInvestment == 0
        ? 0.0
        : (totalProfit / totalInvestment) * 100;

    // Target parsing (0 means no target set)
    final dynamic rawTarget = _tradingDataBox.get('targetAmount');
    final double targetAmount = _parseToDoubleSafe(rawTarget, 0.0);
    final double coverTarget = targetAmount == 0.0
        ? 0.0
        : (totalProfit / targetAmount) * 100;

    // Achievement detection
    if (targetAmount > 0 && totalProfit >= targetAmount) {
      final shownFor = _tradingDataBox.get('targetAlertShownFor');
      if (shownFor == null ||
          _parseToDoubleSafe(shownFor, -1.0) != targetAmount) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (!mounted) return;
          await showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Target Achieved!"),
              content: const Text(
                "You successfully achieved your target — set a new one!",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK"),
                ),
              ],
            ),
          );

          // After dialog: delete the target and mark shown
          try {
            if (_tradingDataBox.containsKey('targetAmount')) {
              await _tradingDataBox.delete('targetAmount');
            }
            await _tradingDataBox.put('targetAlertShownFor', targetAmount);
          } catch (e) {
            // ignore errors quietly
          }

          if (mounted) setState(() {});
        });
      }
    }

    return Scaffold(
      backgroundColor: darkBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBarBackgroundColor,
        title: const Text("Profit/Loss Heatmap"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: records.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SummaryDetails(
                    coverTarget: coverTarget,
                    targetAmount: targetAmount == 0.0 ? 100000.0 : targetAmount,
                    totalProfit: totalProfit,
                    totalInvestment: totalInvestment,
                    avgProfit: avgProfit,
                    avgProfitPercent: avgProfitPercent,
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ProfitLossHeatmap(
                      records: records,
                      keys: keys,
                      onDelete: (key) {
                        setState(() {});
                      },
                    ),
                  ),
                ],
              )
            : Center(
                child: Text(
                  "No Analytics!",
                  style: TextStyle(fontSize: 18, color: darkTextColor),
                ),
              ),
      ),
      floatingActionButton: Visibility(
        visible: _tradingDataBox.toMap().entries.any((e) => e.value is Map),
        child: FloatingActionButton(
          backgroundColor: buttonColor,
          onPressed: () async {
            final hasRecords = _tradingDataBox.toMap().entries.any(
              (e) => e.value is Map,
            );
            if (!hasRecords) {
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
                  "Are you sure you want to delete all records? This action cannot be undone.",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );

            if (deleteConfirmed == true) {
              final keysToDelete = _tradingDataBox
                  .toMap()
                  .entries
                  .where((e) => e.value is Map)
                  .map((e) => e.key)
                  .toList();

              for (final key in keysToDelete) {
                await _tradingDataBox.delete(key);
              }

              // Clear the shown-for flag so next target can be tracked fresh
              if (_tradingDataBox.containsKey('targetAlertShownFor')) {
                await _tradingDataBox.delete('targetAlertShownFor');
              }

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
