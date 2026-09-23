import 'package:flutter/material.dart';
import '../models/irrigation_event.dart';
import '../services/sensor_service.dart';

class AppState extends ChangeNotifier {
  final SensorService _sensor = SensorService();

  // ---- Auth ----
  bool isLoggedIn = false;

  // ---- Theme ----
  ThemeMode themeMode = ThemeMode.dark;
  int colorSeedIndex = 0;
  static const List<Color> colorOptions = [
    Color(0xFF00BFA5), // Teal
    Color(0xFF2979FF), // Blue
    Color(0xFF7C4DFF), // Purple
    Color(0xFFFF6D00), // Orange
    Color(0xFF00C853), // Green
  ];
  Color get seedColor => colorOptions[colorSeedIndex];

  // ---- Live sensor data ----
  int moisturePercent = 55;
  bool connected = true;
  bool circuitOn = true;

  final List<IrrigationEvent> records = [];

  void login() {
    isLoggedIn = true;
    _sensor.start();
    _sensor.readings.listen(_onReading);
    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    notifyListeners();
  }

  void _onReading(SensorReading r) {
    moisturePercent = r.moisturePercent;
    connected = r.connected;
    if (r.irrigationTriggered && r.litresUsed > 0) {
      records.insert(
        0,
        IrrigationEvent(
          dateTime: DateTime.now(),
          litres: double.parse(r.litresUsed.toStringAsFixed(2)),
          moistureAtTime: r.moisturePercent,
        ),
      );
    }
    notifyListeners();
  }

  void toggleCircuit(bool on) {
    circuitOn = on;
    _sensor.setCircuitPower(on);
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    themeMode = mode;
    notifyListeners();
  }

  void setColorSeed(int index) {
    colorSeedIndex = index;
    notifyListeners();
  }

  // ---- Derived stats ----
  List<IrrigationEvent> recordsForDay(DateTime day) {
    return records
        .where((e) =>
            e.day.year == day.year && e.day.month == day.month && e.day.day == day.day)
        .toList();
  }

  int irrigationsToday() => recordsForDay(DateTime.now()).length;

  double litresToday() =>
      recordsForDay(DateTime.now()).fold(0.0, (sum, e) => sum + e.litres);

  double litresTotal() => records.fold(0.0, (sum, e) => sum + e.litres);

  @override
  void dispose() {
    _sensor.dispose();
    super.dispose();
  }
}
