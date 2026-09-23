import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../state/app_state.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final scheme = Theme.of(context).colorScheme;
    final dayRecords = app.recordsForDay(_selectedDay);

    return Column(
      children: [
        Card(
          margin: const EdgeInsets.all(14),
          child: TableCalendar(
            firstDay: DateTime.now().subtract(const Duration(days: 365)),
            lastDay: DateTime.now().add(const Duration(days: 30)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (d) => isSameDay(d, _selectedDay),
            eventLoader: (day) => app.recordsForDay(day),
            calendarFormat: CalendarFormat.month,
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: scheme.primary,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: scheme.secondary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(DateFormat('EEEE, d MMM yyyy').format(_selectedDay),
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              Text('${dayRecords.length} event(s)',
                  style: TextStyle(color: scheme.onSurfaceVariant)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: dayRecords.isEmpty
              ? Center(
                  child: Text('No irrigation events this day',
                      style: TextStyle(color: scheme.onSurfaceVariant)),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  itemCount: dayRecords.length,
                  itemBuilder: (context, i) {
                    final e = dayRecords[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: scheme.primaryContainer,
                          child: Icon(Icons.water_drop, color: scheme.onPrimaryContainer),
                        ),
                        title: Text('${e.litres.toStringAsFixed(1)} L used'),
                        subtitle: Text(
                            '${DateFormat('hh:mm a').format(e.dateTime)}  •  Moisture ${e.moistureAtTime}%'),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
