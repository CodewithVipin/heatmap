// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:heat_map/model/trading_record.dart';
import 'package:heat_map/screens/heat_map_screen.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class RecordEntryScreen extends StatefulWidget {
  const RecordEntryScreen({super.key});

  @override
  _RecordEntryScreenState createState() => _RecordEntryScreenState();
}

class _RecordEntryScreenState extends State<RecordEntryScreen> {
  final _profitLossController = TextEditingController();
  final _reasonController = TextEditingController();
  final _investmentController = TextEditingController();
  DateTime? _selectedDate;

  // This function validates each field
  bool _validateFields() {
    if (_profitLossController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a profit/loss amount.")),
      );
      return false;
    }
    if (_reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a reason.")),
      );
      return false;
    }
    if (_investmentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter an investment amount.")),
      );
      return false;
    }
    return true;
  }

  void _saveRecord(BuildContext context) {
    // Run validation before saving
    if (!_validateFields()) return;

    final profitLoss = double.tryParse(_profitLossController.text) ?? 0.0;
    final reason = _reasonController.text;
    final investment = double.tryParse(_investmentController.text) ?? 0.0;

    // Use the selected date or fallback to current date and time
    final date = _selectedDate ?? DateTime.now();

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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Record Saved!")),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Record Profit/Loss")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? "No date selected"
                        : "Date: ${DateFormat('d MMMM, yyyy').format(_selectedDate!)}",
                  ),
                ),
                TextButton(
                  onPressed: () => _pickDate(context),
                  child: const Text("Pick Date"),
                ),
              ],
            ),
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
