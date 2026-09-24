import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';

class DailyRecord {
  final DateTime date;
  final int irrigationCount;
  final double litresUsed;
  final double avgMoisture;
  final bool hadDisconnectAlert;

  DailyRecord({
    required this.date,
    required this.irrigationCount,
    required this.litresUsed,
    required this.avgMoisture,
    this.hadDisconnectAlert = false,
  });
}

/// Simulated sensor + data store. Replace the TODO sections with your
/// real hardware connection (BLE / WiFi / MQTT). Every screen reads from
/// this single service, so the UI never needs to change once real data
/// is wired in.
class SensorService extends ChangeNotifier {
  SensorService._internal() {
    _seedHistory();
    _startSimulation();
  }
  static final SensorService instance = SensorService._internal();

  final Random _rng = Random();

  double moistureLevel = 62;
  bool circuitOn = true;
  bool circuitConnected = true;
  int todayIrrigationCount = 3;
  double todayLitresUsed = 18.5;
  DateTime lastUpdated = DateTime.now();

  final List<DailyRecord> history = [];
  Timer? _timer;

  void _seedHistory() {
    final today = DateTime.now();
    for (int i = 13; i >= 1; i--) {
      final day = today.subtract(Duration(days: i));
      history.add(DailyRecord(
        date: DateTime(day.year, day.month, day.day),
        irrigationCount: 1 + _rng.nextInt(5),
        litresUsed: 8 + _rng.nextDouble() * 20,
        avgMoisture: 35 + _rng.nextDouble() * 45,
        hadDisconnectAlert: _rng.nextDouble() < 0.15,
      ));
    }
  }

  void _startSimulation() {
    // TODO: replace with a real stream from your sensor hardware.
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (circuitConnected) {
        moistureLevel = (moistureLevel + (_rng.nextDouble() * 10 - 5)).clamp(0, 100);
        if (circuitOn && moistureLevel < 30 && _rng.nextDouble() < 0.4) {
          _triggerIrrigation();
        }
      }
      if (_rng.nextDouble() < 0.03) {
        circuitConnected = false;
      } else if (!circuitConnected && _rng.nextDouble() < 0.5) {
        circuitConnected = true;
      }
      lastUpdated = DateTime.now();
      notifyListeners();
    });
  }

  void _triggerIrrigation() {
    todayIrrigationCount++;
    todayLitresUsed += 1.5 + _rng.nextDouble() * 2;
    moistureLevel = (moistureLevel + 25).clamp(0, 100);
    _saveTodayToHistory();
  }

  /// Stores/updates today's running totals into history so the
  /// History and Calendar pages always reflect the latest saved record.
  void _saveTodayToHistory() {
    final today = DateTime.now();
    final d = DateTime(today.year, today.month, today.day);
    final idx = history.indexWhere((r) => r.date == d);
    final record = DailyRecord(
      date: d,
      irrigationCount: todayIrrigationCount,
      litresUsed: todayLitresUsed,
      avgMoisture: moistureLevel,
      hadDisconnectAlert: !circuitConnected,
    );
    if (idx >= 0) {
      history[idx] = record;
    } else {
      history.add(record);
    }
  }

  void toggleCircuit(bool value) {
    circuitOn = value;
    notifyListeners();
    // TODO: send ON/OFF command to your microcontroller here.
  }

  void reconnectCircuit() {
    circuitConnected = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}