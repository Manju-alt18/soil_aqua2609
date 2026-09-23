import 'dart:async';
import 'dart:math';

/// One reading pushed out by the sensor hardware.
class SensorReading {
  final int moisturePercent;
  final bool connected;
  final bool irrigationTriggered;
  final double litresUsed; // only meaningful when irrigationTriggered = true

  SensorReading({
    required this.moisturePercent,
    required this.connected,
    this.irrigationTriggered = false,
    this.litresUsed = 0,
  });
}

/// Talks to the physical soil-moisture sensor / irrigation controller.
///
/// This is currently a SIMULATOR so the app is runnable without real
/// hardware. To connect a real device:
///   - Bluetooth: use `flutter_blue_plus` and parse characteristic notifies
///     inside `start()`, pushing a [SensorReading] to `_controller` each time.
///   - WiFi/MQTT: connect with `mqtt_client` and forward incoming payloads.
///   - HTTP polling: poll your device's REST endpoint on a Timer.
/// Everywhere else in the app only depends on the [readings] stream below,
/// so swapping the implementation is a one-file change.
class SensorService {
  final _controller = StreamController<SensorReading>.broadcast();
  final _rand = Random();
  Timer? _timer;
  bool _circuitOn = true;
  int _lastMoisture = 55;

  Stream<SensorReading> get readings => _controller.stream;

  bool get circuitOn => _circuitOn;

  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) => _tick());
  }

  void setCircuitPower(bool on) {
    _circuitOn = on;
  }

  void _tick() {
    if (!_circuitOn) {
      _controller.add(SensorReading(moisturePercent: _lastMoisture, connected: true));
      return;
    }

    // Simulate an occasional disconnect (~6% chance per tick).
    final disconnected = _rand.nextDouble() < 0.06;
    if (disconnected) {
      _controller.add(SensorReading(moisturePercent: _lastMoisture, connected: false));
      return;
    }

    // Drift moisture level randomly within bounds.
    final drift = _rand.nextInt(9) - 4; // -4..+4
    _lastMoisture = (_lastMoisture + drift).clamp(10, 95);

    // If moisture is low, simulate the controller triggering irrigation.
    final shouldIrrigate = _lastMoisture < 35 && _rand.nextDouble() < 0.6;
    double litres = 0;
    if (shouldIrrigate) {
      litres = 2 + _rand.nextDouble() * 6; // 2–8 litres
      _lastMoisture = (_lastMoisture + 25).clamp(10, 95);
    }

    _controller.add(SensorReading(
      moisturePercent: _lastMoisture,
      connected: true,
      irrigationTriggered: shouldIrrigate,
      litresUsed: litres,
    ));
  }

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}
