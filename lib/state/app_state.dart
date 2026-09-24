import 'package:flutter/material.dart';
import '../services/sensor_service.dart';

class AppState extends ChangeNotifier {
  final SensorService _sensor = SensorService.instance;

  // ---- Auth ----
  bool isLoggedIn = false;

  // ---- Theme ----
  ThemeMode themeMode = ThemeMode.dark;

  int colorSeedIndex = 0;

  static const List<Color> colorOptions = [
    Color(0xFF00BFA5),
    Color(0xFF2979FF),
    Color(0xFF7C4DFF),
    Color(0xFFFF6D00),
    Color(0xFF00C853),
  ];

  Color get seedColor => colorOptions[colorSeedIndex];

  // ---- Live sensor data ----
  int moisturePercent = 55;
  bool connected = true;
  bool circuitOn = true;

  // ---- Login ----
  void login() {
    isLoggedIn = true;
    notifyListeners();
  }

  // ---- Logout ----
  void logout() {
    isLoggedIn = false;
    notifyListeners();
  }

  // ---- Circuit ON / OFF ----
  void toggleCircuit(bool on) {
    _sensor.toggleCircuit(on);

    circuitOn = on;

    notifyListeners();
  }

  // ---- Theme ----
  void setThemeMode(ThemeMode mode) {
    themeMode = mode;
    notifyListeners();
  }

  // ---- Color ----
  void setColorSeed(int index) {
    colorSeedIndex = index;
    notifyListeners();
  }

  @override
  void dispose() {
    // Do not dispose SensorService here because it is shared
    // using SensorService.instance.
    super.dispose();
  }
}