import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pandabudget/app/panda_logo.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/theme/spacing.dart';

/// The frame around the five main sections: a bottom bar on phones, a
/// navigation rail on tablets and desktop windows.
class AppShell extends StatelessWidget {
  const AppShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  void _select(int index) => shell.goBranch(
    index,
    // Tapping the current section again returns to its first screen.
    initialLocation: index == shell.currentIndex,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final destinations = [
      (
        icon: Icons.space_dashboard_outlined,
        selected: Icons.space_dashboard,
        label: l10n.navOverview,
      ),
      (
        icon: Icons.event_note_outlined,
        selected: Icons.event_note,
        label: l10n.navPlanning,
      ),
      (
        icon: Icons.receipt_long_outlined,
        selected: Icons.receipt_long,
        label: l10n.navTransactions,
      ),
      (
        icon: Icons.donut_large_outlined,
        selected: Icons.donut_large,
        label: l10n.navAnalysis,
      ),
      (
        icon: Icons.settings_outlined,
        selected: Icons.settings,
        label: l10n.navSettings,
      ),
    ];

    final isWide = MediaQuery.sizeOf(context).width >= Breakpoints.wide;
    if (!isWide) {
      return Scaffold(
        body: shell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: shell.currentIndex,
          onDestinationSelected: _select,
          destinations: [
            for (final destination in destinations)
              NavigationDestination(
                icon: Icon(destination.icon),
                selectedIcon: Icon(destination.selected),
                label: destination.label,
              ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: shell.currentIndex,
            onDestinationSelected: _select,
            labelType: NavigationRailLabelType.all,
            minWidth: 96,
            groupAlignment: -0.85,
            leading: const Padding(
              padding: EdgeInsets.symmetric(vertical: Insets.md),
              child: PandaLogo(size: 44),
            ),
            destinations: [
              for (final destination in destinations)
                NavigationRailDestination(
                  icon: Icon(destination.icon),
                  selectedIcon: Icon(destination.selected),
                  label: Text(destination.label),
                  padding: const EdgeInsets.symmetric(vertical: Insets.xs),
                ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: shell),
        ],
      ),
    );
  }
}
