import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pandabudget/core/theme/panda_colors.dart';
import 'package:pandabudget/core/widgets/page_widgets.dart';
import 'package:pandabudget/core/widgets/panda_widgets.dart';

import '../helpers/pump_widget.dart';

void main() {
  testWidgets('ChipBar reports the tapped option', (tester) async {
    String? picked;
    await pumpWidgetInApp(
      tester,
      ChipBar<String>(
        options: const {'a': 'Alpha', 'b': 'Beta'},
        selected: 'a',
        onSelected: (value) => picked = value,
      ),
    );

    await tester.tap(find.text('Beta'));
    expect(picked, 'b');
  });

  testWidgets('ChipBar marks the selected option', (tester) async {
    await pumpWidgetInApp(
      tester,
      ChipBar<int>(
        options: const {1: 'One', 2: 'Two'},
        selected: 2,
        onSelected: (_) {},
      ),
    );

    final primary = _primary(tester);
    expect(tester.widget<Text>(find.text('Two')).style?.color, primary);
    expect(tester.widget<Text>(find.text('One')).style?.color, isNot(primary));
  });

  testWidgets('SubpageBar shows the title and goes back', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) =>
                    const Scaffold(appBar: SubpageBar(title: 'Budgets')),
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('Budgets'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle();
    expect(find.text('Budgets'), findsNothing);
  });

  testWidgets('ActionLink shows label and caption and can be tapped', (
    tester,
  ) async {
    var taps = 0;
    await pumpWidgetInApp(
      tester,
      ActionLink(
        label: 'Accounts',
        caption: 'Cash, cards',
        onTap: () => taps++,
      ),
    );

    expect(find.text('Cash, cards'), findsOneWidget);
    await tester.tap(find.text('Accounts'));
    expect(taps, 1);
  });

  testWidgets('PandaListRow shows title, subtitle and formatted amount', (
    tester,
  ) async {
    var taps = 0;
    await pumpWidgetInApp(
      tester,
      PandaListRow(
        title: 'Rent',
        subtitle: 'Monthly',
        amountMinor: 78000,
        onTap: () => taps++,
      ),
    );

    expect(find.text('Rent'), findsOneWidget);
    expect(find.text('Monthly'), findsOneWidget);
    expect(find.text('€780.00'), findsOneWidget);
    await tester.tap(find.text('Rent'));
    expect(taps, 1);
  });

  testWidgets('BudgetRow turns red above 100 percent', (tester) async {
    await pumpWidgetInApp(
      tester,
      const Column(
        children: [
          BudgetRow(title: 'Fine', detail: '€80 of €100', progress: 0.8),
          BudgetRow(title: 'Over', detail: '€120 of €100', progress: 1.2),
        ],
      ),
    );

    final bars = tester
        .widgetList<LinearProgressIndicator>(
          find.byType(LinearProgressIndicator),
        )
        .toList();
    expect(bars[0].color, _primary(tester));
    expect(bars[1].color, FinanceColors.light.expense);
  });

  testWidgets('BudgetRow shows its note', (tester) async {
    await pumpWidgetInApp(
      tester,
      const BudgetRow(
        title: 'Holiday',
        detail: '40 %',
        progress: 0.4,
        note: 'Behind plan',
      ),
    );

    expect(find.text('Behind plan'), findsOneWidget);
  });

  testWidgets('SectionHeader opens something when it has onTap', (
    tester,
  ) async {
    var taps = 0;
    await pumpWidgetInApp(
      tester,
      SectionHeader('Budgets', onTap: () => taps++),
    );

    expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    await tester.tap(find.text('Budgets'));
    expect(taps, 1);
  });

  testWidgets('SectionHeader without onTap has no chevron', (tester) async {
    await pumpWidgetInApp(tester, const SectionHeader('Budgets'));

    expect(find.byIcon(Icons.chevron_right), findsNothing);
  });

  testWidgets('AccountTile colours a negative balance', (tester) async {
    await pumpWidgetInApp(
      tester,
      const Column(
        children: [
          AccountTile(name: 'Card', balanceMinor: -12050),
          AccountTile(name: 'Main', balanceMinor: 12050),
        ],
      ),
    );

    Color? colorOf(String text) =>
        tester.widget<Text>(find.text(text)).style?.color;
    final ink = Theme.of(tester.element(find.byType(Scaffold))).colorScheme;
    expect(colorOf('€120.50'), ink.onSurface);
    expect(colorOf('-€120.50'), FinanceColors.light.expense);
  });
}

Color _primary(WidgetTester tester) =>
    Theme.of(tester.element(find.byType(Scaffold))).colorScheme.primary;
