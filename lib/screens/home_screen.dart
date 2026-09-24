import 'package:flutter/material.dart';
import '../services/sensor_service.dart';
import '/app_theme.dart';
import '../widgets/moisture_gauge.dart';
import '../widgets/stat_card.dart';
import 'calendar_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final sensor = SensorService.instance;

  @override
  void initState() {
    super.initState();
    sensor.addListener(_refresh);
  }

  @override
  void dispose() {
    sensor.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.homeGradient),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
            children: [
              const Text('Hello, Grower 🌱',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.ink)),
              const SizedBox(height: 4),
              const Text("Here is today's field status", style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 16),

              // ----- Sensor connected / disconnected signal -----
              _signalBanner(),

              const SizedBox(height: 18),
              Center(child: MoistureGauge(value: sensor.moistureLevel, size: 200)),
              const SizedBox(height: 22),

              // ----- Circuit ON/OFF -----
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Row(
                  children: [
                    Icon(Icons.power_settings_new, color: sensor.circuitOn ? AppColors.forest : Colors.grey, size: 26),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        sensor.circuitOn ? 'Irrigation Circuit: ON' : 'Irrigation Circuit: OFF',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                    ),
                    Switch(
                      value: sensor.circuitOn,
                      activeColor: AppColors.forest,
                      onChanged: (v) => sensor.toggleCircuit(v),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.3,
                children: [
                  StatCard(
                    label: 'Irrigations Today',
                    value: '${sensor.todayIrrigationCount}',
                    icon: Icons.water_drop_outlined,
                    gradient: AppColors.cardGradientGreen,
                  ),
                  StatCard(
                    label: 'Litres Used Today',
                    value: '${sensor.todayLitresUsed.toStringAsFixed(1)} L',
                    icon: Icons.opacity,
                    gradient: AppColors.cardGradientBlue,
                  ),
                  // ----- Navigate to Calendar -----
                  StatCard(
                    label: 'View Calendar',
                    value: 'Calendar',
                    icon: Icons.calendar_month_rounded,
                    gradient: const LinearGradient(colors: [Color(0xFFB388FF), Color(0xFF8EC5FC)]),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CalendarScreen())),
                  ),
                  // ----- Navigate to History -----
                  StatCard(
                    label: 'View History',
                    value: 'History',
                    icon: Icons.history_rounded,
                    gradient: const LinearGradient(colors: [Color(0xFFFFC371), Color(0xFF3DDC97)]),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HistoryScreen())),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signalBanner() {
    final connected = sensor.circuitConnected;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: connected ? AppColors.leaf.withOpacity(0.15) : AppColors.coral.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: connected ? AppColors.leaf : AppColors.coral, width: 1.2),
      ),
      child: Row(
        children: [
          Icon(connected ? Icons.wifi : Icons.wifi_off, color: connected ? AppColors.forest : AppColors.coral),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              connected ? 'Sensor Connected' : 'Sensor Disconnected! Check wiring.',
              style: TextStyle(
                color: connected ? AppColors.forest : AppColors.coral,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (!connected)
            TextButton(onPressed: () => sensor.reconnectCircuit(), child: const Text('Retry')),
        ],
      ),
    );
  }
}