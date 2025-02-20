import 'package:flutter/material.dart';
import 'package:heat_map/screens/gauge_pcr.dart';
import 'package:heat_map/screens/record_entry_screen.dart';

class LandScreen extends StatelessWidget {
  const LandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeData.dark().scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
        title: Text("Trading World!"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: MaterialButton(
                height: 48,
                minWidth: double.infinity,
                color: Colors.grey.shade600,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeepMarketInsight()));
                },
                child: Text(
                  'Gauge PCR',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
              child: MaterialButton(
                height: 48,
                minWidth: double.infinity,
                color: Colors.grey.shade600,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecordEntryScreen()));
                },
                child: Text(
                  'Go To Record Screen',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
