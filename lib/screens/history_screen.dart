import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/sensor_service.dart';
import '/app_theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

enum _Filter { all, alertsOnly }

class _HistoryScreenState extends State<HistoryScreen> {
  final sensor = SensorService.instance;
  _Filter _filter = _Filter.all;

  @override
  Widget build(BuildContext context) {
    final records = sensor.history.reversed
        .where((r) => _filter == _Filter.all || r.hadDisconnectAlert)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.historyGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _chip('All', _Filter.all),
                    const SizedBox(width: 8),
                    _chip('Alerts', _Filter.alertsOnly),
                  ],
                ),
              ),
              Expanded(
                child: records.isEmpty
                    ? const Center(child: Text('No records yet.', style: TextStyle(color: Colors.black54)))
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                        itemCount: records.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, i) => _historyTile(records[i]),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(String label, _Filter value) {
    final selected = _filter == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() => _filter = value),
      selectedColor: AppColors.forest,
      labelStyle: TextStyle(color: selected ? Colors.white : AppColors.ink, fontWeight: FontWeight.w600),
      backgroundColor: Colors.white,
    );
  }

  Widget _historyTile(DailyRecord r) {
    final alert = r.hadDisconnectAlert;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border(left: BorderSide(color: alert ? AppColors.coral : AppColors.leaf, width: 5)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: alert
                  ? const LinearGradient(colors: [Color(0xFFFF8A65), Color(0xFFE64A4A)])
                  : AppColors.cardGradientBlue,
            ),
            child: Icon(alert ? Icons.warning_amber_rounded : Icons.calendar_today, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat('EEE, d MMM yyyy').format(r.date), style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  '${r.irrigationCount} irrigations · ${r.litresUsed.toStringAsFixed(1)} L · ${r.avgMoisture.toStringAsFixed(0)}% moisture',
                  style: const TextStyle(color: Colors.black54, fontSize: 12.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}