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
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(title: const Text("Profit/Loss Heatmap")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                  color: Colors.grey.shade700,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Investment: ",
                            style: TextStyle(color: Colors.grey.shade300),
                          ),
                          Text(
                            "${totalInvestment.toStringAsFixed(2)} Rs.",
                            style: TextStyle(color: Colors.grey.shade300),
                          ),
                        ],
                      ),
                    ),
                  )),
              Card(
                  color: Colors.amber.shade300,
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Average Profit/Loss: "),
                          Text("${avgProfit.toStringAsFixed(2)} Rs."),
                        ],
                      ),
                    ),
                  )),
              Card(
                  color: Colors.green,
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Average Profit :"),
                          Text(" ${avgProfitPercent.toStringAsFixed(2)} %")
                        ],
                      ),
                    ),
                  )),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: GridView.builder(
                    padding: EdgeInsets.all(5),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: record.profitOrLoss >= 0
                              ? Colors.green
                              : Colors.red,
                        ),
                        margin: const EdgeInsets.all(4.0),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
