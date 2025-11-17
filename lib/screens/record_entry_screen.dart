// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:heat_map/model/trading_record.dart';
import 'package:heat_map/screens/heat_map_screen.dart';
import 'package:heat_map/theme/app_colors.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class RecordEntryScreen extends StatefulWidget {
  const RecordEntryScreen({super.key});

  @override
  _RecordEntryScreenState createState() => _RecordEntryScreenState();
}

class _RecordEntryScreenState extends State<RecordEntryScreen> {
  final _profitLossController = TextEditingController();
  final _investmentController = TextEditingController();
  final _targetController = TextEditingController();

  DateTime? _selectedDate;
  bool _hasTarget = false;

  final Box _box = Hive.box('tradingData');

  @override
  void initState() {
    super.initState();
    _loadTargetAmount();

    // listen so UI updates if target changed elsewhere
    _box.watch().listen((event) {
      if (event.key == 'targetAmount' && mounted) {
        _loadTargetAmount();
      }
    });
  }

  // LOAD TARGET
  void _loadTargetAmount() {
    final dynamic raw = _box.get('targetAmount');

    if (raw != null) {
      _hasTarget = true;
      if (raw is int) {
        _targetController.text = raw.toString();
      } else if (raw is double) {
        _targetController.text = raw.toStringAsFixed(0);
      } else {
        _targetController.text = raw.toString();
      }
    } else {
      _hasTarget = false;
      _targetController.clear();
    }

    if (mounted) setState(() {});
  }

  // SAVE TARGET
  void _saveTargetAmount() {
    final value = double.tryParse(_targetController.text);
    if (value == null || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid target amount.")),
      );
      return;
    }

    _box.put('targetAmount', value);

    // Reset alert marker so next time can trigger
    if (_box.containsKey('targetAlertShownFor')) {
      _box.delete('targetAlertShownFor');
    }

    _hasTarget = true;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Target updated to ₹${value.toStringAsFixed(0)}")),
    );

    if (mounted) setState(() {});
  }

  // REMOVE TARGET
  void _removeTarget() {
    if (_box.containsKey('targetAmount')) {
      _box.delete('targetAmount');
    }
    _hasTarget = false;
    _targetController.clear();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Target Removed")));

    if (mounted) setState(() {});
  }

  bool _validateFields() {
    if (_profitLossController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a profit/loss amount.")),
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
    if (!_validateFields()) return;

    final profitLoss = double.tryParse(_profitLossController.text) ?? 0.0;
    final investment = double.tryParse(_investmentController.text) ?? 0.0;
    final date = _selectedDate ?? DateTime.now();

    final record = TradingRecord(
      profitOrLoss: profitLoss,
      investment: investment,
      date: date,
    );

    _box.add(record.toMap());

    _profitLossController.clear();
    _investmentController.clear();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Record Saved!")));
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  // ----- UI helpers (modern minimal styles) -----
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: darkTextColor),
      filled: true,
      fillColor: darkTabColor,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: buttonColor),
      ),
    );
  }

  Widget _buildActionButton(String text, VoidCallback onTap) {
    return SizedBox(
      height: 48,
      width: 160,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadowColor: Colors.black45,
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(
            color: darkButtonTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _targetCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: darkTabColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade700,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _hasTarget
                  ? "Target: ₹${_targetController.text}"
                  : "No target set",
              style: TextStyle(
                color: darkTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (_hasTarget)
            TextButton(
              onPressed: _removeTarget,
              child: const Text(
                "Remove Target",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dynamic rawTarget = _box.get('targetAmount');
    _hasTarget = rawTarget != null;

    return Scaffold(
      backgroundColor: darkBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBarBackgroundColor,
        elevation: 0,
        title: const Text("Record Profit/Loss"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Target area (card)
              _targetCard(),
              const SizedBox(height: 14),

              // If there's no target show inline set-target row
              if (!_hasTarget) ...[
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _targetController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: darkTextColor),
                        decoration: _inputDecoration("Set Target Amount (₹)"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: Icon(Icons.save, color: buttonColor),
                      onPressed: _saveTargetAmount,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],

              const Divider(color: Colors.white12, height: 26),

              // Date row
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? "No date selected"
                          : "Date: ${DateFormat('d MMMM, yyyy').format(_selectedDate!)}",
                      style: TextStyle(color: darkTextColor),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _pickDate(context),
                    child: Text(
                      "Pick Date",
                      style: TextStyle(color: buttonColor),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Profit / Loss input
              TextField(
                style: TextStyle(color: darkTextColor),
                controller: _profitLossController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Profit/Loss Amount"),
              ),

              const SizedBox(height: 12),

              // Investment input
              TextField(
                controller: _investmentController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: darkTextColor),
                decoration: _inputDecoration("Investment Amount"),
              ),

              const SizedBox(height: 22),

              // Buttons row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildActionButton("Save Record", () => _saveRecord(context)),
                  _buildActionButton("View Heatmap", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HeatmapScreen()),
                    );
                  }),
                ],
              ),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}
