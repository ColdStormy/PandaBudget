import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pandabudget/app/routes.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/features/planning/presentation/budgets_tab.dart';
import 'package:pandabudget/features/planning/presentation/forecast_tab.dart';
import 'package:pandabudget/features/planning/presentation/goals_tab.dart';
import 'package:pandabudget/features/planning/presentation/planned_items_tab.dart';

/// Future planning: the forecast and everything it is built from.
class PlanningScreen extends ConsumerStatefulWidget {
  const PlanningScreen({super.key});

  @override
  ConsumerState<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends ConsumerState<PlanningScreen>
    with SingleTickerProviderStateMixin {
  late final _tabs = TabController(length: 4, vsync: this)
    ..addListener(() => setState(() {}));

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // What the add button creates depends on the tab that is showing.
    final (String addLabel, String addRoute) = switch (_tabs.index) {
      2 => (l10n.addBudget, Routes.budgetEdit()),
      3 => (l10n.addGoal, Routes.goalEdit()),
      _ => (l10n.addPlannedItem, Routes.plannedItemEdit()),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navPlanning),
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [
            Tab(text: l10n.tabForecast),
            Tab(text: l10n.tabPlannedItems),
            Tab(text: l10n.tabBudgets),
            Tab(text: l10n.tabGoals),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(addRoute),
        icon: const Icon(Icons.add),
        label: Text(addLabel),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          ForecastTab(onPlanFirstItem: () => _tabs.animateTo(1)),
          const PlannedItemsTab(),
          const BudgetsTab(),
          const GoalsTab(),
        ],
      ),
    );
  }
}
