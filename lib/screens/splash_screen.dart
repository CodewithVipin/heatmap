// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:heat_map/screens/land_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LandScreen()));
    });

    return Scaffold(
      backgroundColor: ThemeData.dark().scaffoldBackgroundColor,
      body: Center(
        child: Text("Option Trading App",
            style: TextStyle(
                color: Colors.grey, fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
