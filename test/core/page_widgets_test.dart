import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/theme/panda_colors.dart';
import 'package:pandabudget/core/widgets/form_widgets.dart';
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

  testWidgets('PandaListRow shows a trailing widget and dims when disabled', (
    tester,
  ) async {
    await pumpWidgetInApp(
      tester,
      const PandaListRow(
        title: 'Import',
        subtitle: 'a\nb\nc',
        subtitleMaxLines: 3,
        trailing: Text('Undo'),
        enabled: false,
      ),
    );

    expect(find.text('Undo'), findsOneWidget);
    expect(tester.widget<Opacity>(find.byType(Opacity).first).opacity, 0.5);
  });

  testWidgets('AddLink fires and is left aligned', (tester) async {
    var taps = 0;
    await pumpWidgetInApp(
      tester,
      AddLink(label: 'Add account', onPressed: () => taps++),
    );

    await tester.tap(find.text('Add account'));
    expect(taps, 1);
    expect(tester.getTopLeft(find.byType(TextButton)).dx, lessThan(40));
  });

  testWidgets('FormPage has save and delete in the top bar', (tester) async {
    var saved = 0;
    var deleted = 0;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: FormPage(
          title: 'Edit account',
          onSave: () => saved++,
          onDelete: () => deleted++,
          children: const [Text('field')],
        ),
      ),
    );

    expect(find.text('Edit account'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_left), findsOneWidget);
    await tester.tap(find.text('Save'));
    await tester.tap(find.text('Delete'));
    expect([saved, deleted], [1, 1]);
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

  testWidgets('BudgetRow can be tapped', (tester) async {
    var taps = 0;
    await pumpWidgetInApp(
      tester,
      BudgetRow(
        title: 'Groceries',
        detail: '€10 of €100',
        progress: 0.1,
        onTap: () => taps++,
      ),
    );

    await tester.tap(find.text('Groceries'));
    expect(taps, 1);
  });

  test('joinDetails drops empty and repeated parts, ignoring case', () {
    expect(
      joinDetails(['Fuel', 'fuel ', 'Main account']),
      'Fuel · Main account',
    );
    expect(
      joinDetails([null, '', 'Dinner', 'Eating out']),
      'Dinner · Eating out',
    );
    expect(
      joinDetails(['Nov 5', 'Groceries', 'Card payment']),
      'Nov 5 · Groceries · Card payment',
    );
    expect(joinDetails(const []), '');
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
