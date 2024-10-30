import 'package:flutter/material.dart';
import 'package:heat_map/model/trading_record.dart';
import 'package:heat_map/screens/heat_map_screen.dart';
import 'package:hive/hive.dart';

class RecordEntryScreen extends StatelessWidget {
  final _profitLossController = TextEditingController();
  final _reasonController = TextEditingController();
  final _investmentController = TextEditingController();

  RecordEntryScreen({super.key});

  void _saveRecord(BuildContext context) {
    final profitLoss = double.tryParse(_profitLossController.text) ?? 0.0;
    final reason = _reasonController.text;
    final investment = double.tryParse(_investmentController.text) ?? 0.0;
    final date = DateTime.now();

    final record = TradingRecord(
      profitOrLoss: profitLoss,
      reason: reason,
      investment: investment,
      date: date,
    );

    Hive.box('tradingData').add(record.toMap());

    _profitLossController.clear();
    _reasonController.clear();
    _investmentController.clear();

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Record Saved!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Record Profit/Loss")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _profitLossController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: "Profit/Loss Amount"),
            ),
            TextField(
              controller: _reasonController,
              decoration: const InputDecoration(labelText: "Reason"),
            ),
            TextField(
              controller: _investmentController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Investment Amount"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _saveRecord(context),
              child: const Text("Save Record"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => HeatmapScreen()));
              },
              child: const Text("View Heatmap"),
            ),
          ],
        ),
      ),
    );
  }
}
