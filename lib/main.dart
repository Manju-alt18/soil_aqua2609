import 'package:flutter/material.dart';
import '/app_theme.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const SoilSenseApp());
}

class SoilSenseApp extends StatelessWidget {
  const SoilSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SoilSense',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const LoginScreen(),
    );
  }
}