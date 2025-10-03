import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'dashboard_page.dart';
import 'destination_page.dart';
import 'trip_page.dart';
import 'progress_page.dart';
import 'info_page.dart';

class NavState extends ChangeNotifier {
  int _index = 0;
  int get index => _index;

  void setIndex(int i) {
    if (i == _index) return;
    _index = i;
    notifyListeners();
  }
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TravelAppState()),
        ChangeNotifierProvider(create: (_) => NavState()),
      ],
      child: const TravelApp(),
    ),
  );
}

class TravelApp extends StatefulWidget {
  const TravelApp({super.key});

  @override
  State<TravelApp> createState() => _TravelAppState();
}

class _TravelAppState extends State<TravelApp> {
  bool _useAltSeed = false;

  @override
  Widget build(BuildContext context) {
    final colorSeed = _useAltSeed ? const Color(0xFF1565C0) : const Color(0xFF2E7D32);

    return MaterialApp(
      title: 'Travel Navigator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: colorSeed,
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      home: _RootShell(
        onToggleAccent: () => setState(() => _useAltSeed = !_useAltSeed),
      ),
    );
  }
}

class _RootShell extends StatefulWidget {
  const _RootShell({super.key, required this.onToggleAccent});
  final VoidCallback onToggleAccent;

  @override
  State<_RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<_RootShell> {
  final _pages = const <Widget>[
    DashboardPage(),
    DestinationsPage(),
    TripPage(),
    ProgressPage(),
    InfoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavState>();
    final state = context.watch<TravelAppState>();

    final appBarTitle = switch (nav.index) {
      0 => 'Главная',
      1 => 'Направления',
      2 => 'Маршрут: ${state.selectedDestination?.name ?? "не выбран"}',
      3 => 'Прогресс путешествия',
      _ => 'Справка',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        actions: [
          IconButton(
            tooltip: 'Сменить акцентную тему',
            onPressed: widget.onToggleAccent,
            icon: const Icon(Icons.color_lens_outlined),
          ),
        ],
      ),
      body: SafeArea(child: _pages[nav.index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: nav.index,
        onDestinationSelected: nav.setIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Главная'),
          NavigationDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map), label: 'Направления'),
          NavigationDestination(icon: Icon(Icons.route_outlined), selectedIcon: Icon(Icons.route), label: 'Маршрут'),
          NavigationDestination(icon: Icon(Icons.timeline_outlined), selectedIcon: Icon(Icons.timeline), label: 'Прогресс'),
          NavigationDestination(icon: Icon(Icons.info_outline), selectedIcon: Icon(Icons.info), label: 'Справка'),
        ],
      ),
    );
  }
}
