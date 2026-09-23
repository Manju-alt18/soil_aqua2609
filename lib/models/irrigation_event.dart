/// A single irrigation event logged by the sensor/controller.
class IrrigationEvent {
  final DateTime dateTime;
  final double litres;
  final int moistureAtTime; // % at the moment irrigation ran

  IrrigationEvent({
    required this.dateTime,
    required this.litres,
    required this.moistureAtTime,
  });

  /// Normalized date (no time) — handy for grouping by day.
  DateTime get day => DateTime(dateTime.year, dateTime.month, dateTime.day);
}
