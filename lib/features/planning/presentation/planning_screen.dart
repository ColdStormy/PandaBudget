import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/theme/spacing.dart';
import 'package:pandabudget/core/widgets/page_widgets.dart';
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
  late final _tabs = TabController(length: 4, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const gutter = EdgeInsets.symmetric(horizontal: Insets.md);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: gutter,
              child: PageHeader(title: l10n.navPlanning),
            ),
            gapSm,
            TabBar(
              controller: _tabs,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              padding: gutter,
              tabs: [
                Tab(text: l10n.tabForecast),
                Tab(text: l10n.tabPlannedItems),
                Tab(text: l10n.tabBudgets),
                Tab(text: l10n.tabGoals),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabs,
                children: [
                  ForecastTab(onPlanFirstItem: () => _tabs.animateTo(1)),
                  const PlannedItemsTab(),
                  const BudgetsTab(),
                  const GoalsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
