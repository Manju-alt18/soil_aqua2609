import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import 'calendar_screen.dart';
import 'history_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _index = 0;
  final _titles = const ['Dashboard', 'Calendar', 'History'];
  final _screens = const [HomeScreen(), CalendarScreen(), HistoryScreen()];

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index]),
        actions: [
          IconButton(
            tooltip: 'Toggle dark mode',
            icon: Icon(app.themeMode == ThemeMode.dark
                ? Icons.dark_mode
                : Icons.light_mode),
            onPressed: () => context.read<AppState>().setThemeMode(
                app.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark),
          ),
          PopupMenuButton<int>(
            tooltip: 'Accent color',
            icon: const Icon(Icons.palette_outlined),
            onSelected: (i) => context.read<AppState>().setColorSeed(i),
            itemBuilder: (context) => List.generate(
              AppState.colorOptions.length,
              (i) => PopupMenuItem(
                value: i,
                child: Row(
                  children: [
                    CircleAvatar(radius: 9, backgroundColor: AppState.colorOptions[i]),
                    const SizedBox(width: 10),
                    Text('Variant ${i + 1}'),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AppState>().logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.calendar_month_outlined), label: 'Calendar'),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }
}
