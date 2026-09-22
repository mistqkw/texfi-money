import 'package:flutter/material.dart';

import '../../core/theme/app_l10n_ext.dart';
import '../history/history_screen.dart';
import '../home/home_screen.dart';
import 'grouped_tab.dart';
import 'pixel_icon.dart';
import 'pixel_nav_bar.dart';

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
    PlanTab(),
    SummaryTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: PixelNavBar(
        currentIndex: _index,
        onSelected: (value) => setState(() => _index = value),
        items: [
          PixelNavItem(sprite: PixelIcons.home, label: l10n.navHome),
          PixelNavItem(sprite: PixelIcons.history, label: l10n.navHistory),
          // «План» и «Итоги» — не новые разделы, а две пары старых
          // вкладок: бюджеты с целями и статистика с капиталом. Шесть
          // равнозначных пунктов внизу не складывались в структуру и не
          // помещались подписями в Material-панель.
          PixelNavItem(sprite: PixelIcons.budgets, label: l10n.navPlan),
          PixelNavItem(sprite: PixelIcons.statistics, label: l10n.navSummary),
        ],
      ),
    );
  }
}
