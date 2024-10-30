import 'package:flutter/material.dart';
import 'package:heat_map/model/trading_record.dart';
import 'package:hive/hive.dart';

class HeatmapScreen extends StatelessWidget {
  final Box _tradingDataBox = Hive.box('tradingData');

  HeatmapScreen({super.key});

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
      appBar: AppBar(title: const Text("Profit/Loss Heatmap")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Total Investment: \$${totalInvestment.toStringAsFixed(2)}"),
            Text("Average Profit/Loss: \$${avgProfit.toStringAsFixed(2)}"),
            Text("Average Profit %: ${avgProfitPercent.toStringAsFixed(2)}%"),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5),
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final record = records[index];
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    color: record.profitOrLoss >= 0 ? Colors.green : Colors.red,
                    child: Center(
                      child: Text(
                        "${record.profitOrLoss >= 0 ? '+' : ''}${record.profitOrLoss.toStringAsFixed(2)}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
