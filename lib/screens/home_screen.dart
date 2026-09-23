import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../widgets/moisture_gauge.dart';
import '../widgets/stat_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final scheme = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 700 ? 4 : (width > 420 ? 3 : 2);

    return CustomScrollView(
      slivers: [
        if (!app.connected)
          SliverToBoxAdapter(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              color: Colors.redAccent.withValues(alpha: 0.15),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Sensor circuit disconnected! Check wiring / power.',
                      style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Center(child: MoistureGauge(percent: app.moisturePercent)),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        app.circuitOn ? Icons.power : Icons.power_off,
                        color: app.circuitOn ? scheme.primary : scheme.outline,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Irrigation Circuit',
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            Text(
                              app.circuitOn
                                  ? (app.connected ? 'Online' : 'Disconnected')
                                  : 'Powered Off',
                              style: TextStyle(
                                color: !app.connected
                                    ? Colors.redAccent
                                    : (app.circuitOn ? Colors.greenAccent.shade400 : scheme.outline),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: app.circuitOn,
                        onChanged: (v) => context.read<AppState>().toggleCircuit(v),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.25,
                children: [
                  StatCard(
                    icon: Icons.water_drop_outlined,
                    label: 'Irrigations Today',
                    value: '${app.irrigationsToday()}',
                    accent: scheme.primary,
                  ),
                  StatCard(
                    icon: Icons.opacity_rounded,
                    label: 'Litres Used Today',
                    value: app.litresToday().toStringAsFixed(1),
                    accent: Colors.blueAccent,
                  ),
                  StatCard(
                    icon: Icons.water,
                    label: 'Total Litres Used',
                    value: app.litresTotal().toStringAsFixed(1),
                    accent: Colors.cyan,
                  ),
                  StatCard(
                    icon: app.connected ? Icons.wifi : Icons.wifi_off,
                    label: 'Sensor Status',
                    value: app.connected ? 'Connected' : 'Offline',
                    accent: app.connected ? Colors.greenAccent.shade400 : Colors.redAccent,
                  ),
                ],
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
