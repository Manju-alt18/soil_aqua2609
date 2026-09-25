import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../services/sensor_service.dart';
import '/app_theme.dart';
import '../widgets/stat_card.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final sensor = SensorService.instance;

  DailyRecord? _recordFor(DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    for (final r in sensor.history) {
      if (r.date == d) return r;
    }
    final today = DateTime.now();
    if (d.year == today.year && d.month == today.month && d.day == today.day) {
      return DailyRecord(
        date: d,
        irrigationCount: sensor.todayIrrigationCount,
        litresUsed: sensor.todayLitresUsed,
        avgMoisture: sensor.moistureLevel,
        hadDisconnectAlert: !sensor.circuitConnected,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    _selectedDay ??= DateTime.now();
    final record = _recordFor(_selectedDay!);

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.calendarGradient),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: TableCalendar(
                  firstDay: DateTime.now().subtract(const Duration(days: 60)),
                  lastDay: DateTime.now().add(const Duration(days: 14)),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (d) => isSameDay(_selectedDay, d),
                  onDaySelected: (selected, focused) {
                    setState(() {
                      _selectedDay = selected;
                      _focusedDay = focused;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    selectedDecoration: const BoxDecoration(color: Color(0xFF8E44AD), shape: BoxShape.circle),
                    todayDecoration: BoxDecoration(color: AppColors.sky.withOpacity(0.6), shape: BoxShape.circle),
                    markerDecoration: const BoxDecoration(color: AppColors.amber, shape: BoxShape.circle),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(fontWeight: FontWeight.bold, color: AppColors.ink),
                  ),
                  eventLoader: (day) {
                    final r = _recordFor(day);
                    return r == null ? [] : [r];
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                DateFormat('EEEE, d MMMM yyyy').format(_selectedDay!),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.ink),
              ),
              const SizedBox(height: 12),
              if (record == null)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                  child: const Text('No data recorded for this day.', style: TextStyle(color: Colors.black54)),
                )
              else
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.8,
                  children: [
                    StatCard(
                      label: 'Irrigations',
                      value: '${record.irrigationCount}',
                      icon: Icons.water_drop_outlined,
                      gradient: const LinearGradient(colors: [Color(0xFF8E44AD), Color(0xFF3498DB)]),
                    ),
                    StatCard(
                      label: 'Litres Used',
                      value: '${record.litresUsed.toStringAsFixed(1)} L',
                      icon: Icons.opacity,
                      gradient: AppColors.cardGradientBlue,
                    ),
                    StatCard(
                      label: 'Avg Moisture',
                      value: '${record.avgMoisture.toStringAsFixed(0)}%',
                      icon: Icons.grass,
                      gradient: AppColors.cardGradientGreen,
                    ),
                    StatCard(
                      label: record.hadDisconnectAlert ? 'Alert Occurred' : 'No Alerts',
                      value: record.hadDisconnectAlert ? '⚠' : '✓',
                      icon: record.hadDisconnectAlert ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                      gradient: record.hadDisconnectAlert
                          ? const LinearGradient(colors: [Color(0xFFFF8A65), Color(0xFFE64A4A)])
                          : AppColors.cardGradientGreen,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}