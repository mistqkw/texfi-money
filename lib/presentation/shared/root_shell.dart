import 'package:flutter/material.dart';

import '../../core/theme/app_l10n_ext.dart';
import '../../core/utils/haptics.dart';
import '../budgets/budgets_screen.dart';
import '../goals/goals_screen.dart';
import '../history/history_screen.dart';
import '../home/home_screen.dart';
import '../statistics/statistics_screen.dart';
import 'pixel_icon.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  static const _pages = [
    HomeScreen(),
    HistoryScreen(),
    BudgetsScreen(),
    GoalsScreen(),
    StatisticsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) {
          if (value != _index) Haptics.select();
          setState(() => _index = value);
        },
        destinations: [
          NavigationDestination(
            icon: const PixelIcon(PixelIcons.home),
            label: l10n.navHome,
          ),
          NavigationDestination(
            icon: const PixelIcon(PixelIcons.history),
            label: l10n.navHistory,
          ),
          NavigationDestination(
            icon: const PixelIcon(PixelIcons.budgets),
            label: l10n.navBudgets,
          ),
          NavigationDestination(
            icon: const PixelIcon(PixelIcons.goals),
            label: l10n.navGoals,
          ),
          NavigationDestination(
            icon: const PixelIcon(PixelIcons.statistics),
            label: l10n.navStatistics,
          ),
        ],
      ),
    );
  }
}
