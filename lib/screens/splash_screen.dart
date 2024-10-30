// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:heat_map/screens/record_entry_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => RecordEntryScreen()));
    });

    return const Scaffold(
      body: Center(
        child: Text("Option Trading App",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    );
  }
}