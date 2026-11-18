@Tags(['golden'])
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pandabudget/core/widgets/page_widgets.dart';
import 'package:pandabudget/core/widgets/panda_widgets.dart';

import '../helpers/pump_widget.dart';

/// Every shared page widget once, in light and dark, so the look can be
/// reviewed without running the app.
///
/// Refresh the images with `flutter test --update-goldens --tags golden`.
/// Linux only, like the screen goldens.
void main() {
  for (final brightness in Brightness.values) {
    testWidgets('page widgets: ${brightness.name}', (tester) async {
      await pumpWidgetInApp(
        tester,
        brightness: brightness,
        size: const Size(412, 1000),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeader(
              title: 'Accounts',
              action: AccentTextButton(label: 'Hide amounts', onPressed: () {}),
            ),
            const SizedBox(height: 8),
            const HeadlineFigures(
              caption: 'This month',
              netMinor: 123985,
              incomeLabel: 'Income',
              incomeMinor: 255000,
              expenseLabel: 'Spent',
              expenseMinor: -131015,
            ),
            const SizedBox(height: 16),
            const Callout(
              icon: Icons.shield_outlined,
              color: Color(0xFFB57A14),
              child: Text('€500 stays reserved for budgets'),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(
                  child: AccountTile(name: 'Current', balanceMinor: 321480),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: AccountTile(
                    name: 'Credit card',
                    balanceMinor: -124050,
                  ),
                ),
              ],
            ),
            ActionLink(label: 'Fixed costs', onTap: () {}),
            ActionLink(
              label: 'Categories',
              caption: 'What you sort spending into',
              icon: Icons.label_outline,
              onTap: () {},
            ),
            const SectionHeader('List rows'),
            const PandaListRow(
              title: 'Rent',
              subtitle: 'Monthly · next on 1 Dec',
              amountMinor: -78000,
            ),
            const PandaListRow(
              title: 'Salary',
              subtitle: 'Monthly',
              amountMinor: 255000,
              tone: AmountTone.incomeOnly,
              showPlus: true,
            ),
            SectionHeader('Budgets', onTap: () {}),
            const BudgetRow(
              title: 'Groceries',
              detail: '€320 of €400',
              progress: 0.8,
            ),
            const BudgetRow(
              title: 'Holiday',
              detail: '40 %',
              progress: 0.4,
              note: 'Behind plan',
              noteColor: Color(0xFFB57A14),
            ),
            const BudgetRow(
              title: 'Dining out',
              detail: '€180 of €150',
              progress: 1.2,
            ),
            const SizedBox(height: 8),
            ChipBar<int>(
              options: const {0: 'All', 1: 'Income', 2: 'Expenses'},
              selected: 1,
              onSelected: (_) {},
            ),
          ],
        ),
      );

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('images/widgets_${brightness.name}.png'),
      );
    }, skip: !Platform.isLinux);
  }
}
