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

// Widget to display summary details at the top
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        10,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white, width: 0.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Target Amount",
                style: TextStyle(
                    color: Colors.grey.shade400, fontWeight: FontWeight.w400),
              ),
              Text("${targetAmount.toStringAsFixed(2)} Rs.",
                  style: TextStyle(
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.bold)),
              Container(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                      color:
                          totalProfit >= 0 ? Colors.green : Colors.deepOrange),
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "${coverTarget.toStringAsFixed(2)}%",
                  style: TextStyle(
                      color: totalProfit > 0 ? Colors.green : Colors.deepOrange,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Investment",
                  style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w400)),
              Text("${totalInvestment.toStringAsFixed(2)} Rs.",
                  style: TextStyle(
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "P/L Percentage",
                  style: TextStyle(
                      color: Colors.grey.shade400, fontWeight: FontWeight.w400),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      color:
                          totalProfit >= 0 ? Colors.green : Colors.deepOrange),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.shade800,
                      ),
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Text(
                        textAlign: TextAlign.center,
                        "${avgProfitPercent.toStringAsFixed(2)} %",
                        style: TextStyle(
                            fontWeight: FontWeight.w200,
                            fontSize: 10,
                            color: totalProfit >= 0
                                ? Colors.green
                                : Colors.deepOrange),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Divider(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total P/L",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                Text(
                  "${totalProfit.toStringAsFixed(2)} Rs.",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          totalProfit > 0 ? Colors.green : Colors.deepOrange),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget to display profit/loss heatmap grid
class ProfitLossHeatmap extends StatelessWidget {
  final Function onDelete; // Add a callback parameter
  final List<TradingRecord> records;

  const ProfitLossHeatmap(
      {super.key, required this.records, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(5),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
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
                title: const Text("Details",
                    style: TextStyle(color: Colors.white)),
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
                    child: const Text("Close",
                        style: TextStyle(color: Colors.blue)),
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
                    child: const Text("Delete",
                        style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
              ),
              color: record.profitOrLoss >= 0
                  ? Colors.teal
                  : Colors.deepOrange.shade400,
            ),
            margin: const EdgeInsets.all(4.0),
            child: Center(
              child: Text(
                "${record.profitOrLoss >= 0 ? '+' : ''}${record.profitOrLoss.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
