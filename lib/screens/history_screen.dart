import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/irrigation_event.dart';
import '../state/app_state.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final scheme = Theme.of(context).colorScheme;
    final records = app.records;

    // Group by day, preserving descending order.
    final Map<String, List<IrrigationEvent>> grouped = {};
    for (final e in records) {
      final key = DateFormat('EEEE, d MMM yyyy').format(e.day);
      grouped.putIfAbsent(key, () => []).add(e);
    }

    if (records.isEmpty) {
      return Center(
        child: Text('No irrigation history yet',
            style: TextStyle(color: scheme.onSurfaceVariant)),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: scheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _summaryStat(context, '${records.length}', 'Total Events'),
                Container(width: 1, height: 36, color: scheme.onPrimaryContainer.withValues(alpha: 0.2)),
                _summaryStat(context, app.litresTotal().toStringAsFixed(1), 'Total Litres'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        for (final entry in grouped.entries) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 10, bottom: 6),
            child: Text(entry.key,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
          for (final e in entry.value)
            Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: scheme.secondaryContainer,
                  child: Icon(Icons.opacity_rounded, color: scheme.onSecondaryContainer),
                ),
                title: Text('${e.litres.toStringAsFixed(1)} L'),
                subtitle: Text('Moisture at time: ${e.moistureAtTime}%'),
                trailing: Text(DateFormat('hh:mm a').format(e.dateTime)),
              ),
            ),
        ],
      ],
    );
  }

  Widget _summaryStat(BuildContext context, String value, String label) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(value,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold, color: scheme.onPrimaryContainer)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: scheme.onPrimaryContainer, fontSize: 12)),
      ],
    );
  }
}
