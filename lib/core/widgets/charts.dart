import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/money/money_providers.dart';
import 'package:pandabudget/core/theme/spacing.dart';
import 'package:pandabudget/core/time/year_month.dart';

/// One series of a [MonthBarChart].
@immutable
class BarSeries {
  const BarSeries({
    required this.label,
    required this.color,
    required this.values,
  });

  final String label;
  final Color color;

  /// One value in minor units per month of the chart.
  final List<int> values;
}

/// Bars per month: one series (e.g. what a month leaves over) or several
/// side by side (income next to spending).
class MonthBarChart extends ConsumerWidget {
  const MonthBarChart({
    required this.months,
    required this.series,
    this.selected,
    this.onSelected,
    this.negativeColor,
    this.height = 200,
    super.key,
  });

  final List<YearMonth> months;
  final List<BarSeries> series;
  final YearMonth? selected;
  final ValueChanged<YearMonth>? onSelected;

  /// Colour for bars below zero; defaults to the series colour.
  final Color? negativeColor;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final money = ref.money(context);
    final all = [for (final s in series) ...s.values];
    final highest = all.fold(0, math.max);
    final lowest = all.fold(0, math.min);
    // Keep some headroom and avoid a zero-height axis for empty data.
    final top = highest == 0 && lowest == 0 ? 10000.0 : highest * 1.15;
    final bottom = lowest * 1.15;
    final labelStyle = theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final slot = (constraints.maxWidth - 56) / months.length;
          final rodWidth = (slot * 0.62 / series.length).clamp(3.0, 22.0);
          // Label every month if there is room, otherwise every 2nd/3rd.
          final labelEvery = (40 / slot).ceil().clamp(1, 6);

          return BarChart(
            BarChartData(
              maxY: top,
              minY: bottom,
              alignment: BarChartAlignment.spaceAround,
              groupsSpace: 0,
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: value == 0
                      ? theme.colorScheme.outline
                      : theme.colorScheme.outlineVariant,
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 56,
                    minIncluded: false,
                    maxIncluded: false,
                    getTitlesWidget: (value, meta) => SideTitleWidget(
                      meta: meta,
                      child: Text(
                        money.formatCompact(value.round()),
                        style: labelStyle,
                      ),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 ||
                          index >= months.length ||
                          index % labelEvery != 0) {
                        return const SizedBox.shrink();
                      }
                      final month = months[index];
                      return SideTitleWidget(
                        meta: meta,
                        child: Text(
                          // Mark each January with its year.
                          month.month == 1
                              ? "'${month.year % 100}"
                              : context.formatMonthName(month),
                          style: month == selected
                              ? labelStyle?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w700,
                                )
                              : labelStyle,
                        ),
                      );
                    },
                  ),
                ),
              ),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => theme.colorScheme.inverseSurface,
                  tooltipBorderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  fitInsideHorizontally: true,
                  fitInsideVertically: true,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                      BarTooltipItem(
                        '${context.formatShortMonth(months[group.x])}\n'
                        '${series.length > 1 ? '${series[rodIndex].label}: ' : ''}'
                        '${money.format(rod.toY.round())}',
                        theme.textTheme.labelMedium!.copyWith(
                          color: theme.colorScheme.onInverseSurface,
                        ),
                      ),
                ),
                touchCallback: (event, response) {
                  final index = response?.spot?.touchedBarGroupIndex;
                  if (event is FlTapUpEvent && index != null) {
                    onSelected?.call(months[index]);
                  }
                },
              ),
              barGroups: [
                for (final (index, month) in months.indexed)
                  BarChartGroupData(
                    x: index,
                    barsSpace: 2,
                    barRods: [
                      for (final s in series)
                        BarChartRodData(
                          toY: s.values[index].toDouble(),
                          width: rodWidth,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(4),
                          ),
                          color:
                              (s.values[index] < 0
                                      ? negativeColor ?? s.color
                                      : s.color)
                                  .withValues(
                                    alpha: selected == null || month == selected
                                        ? 1
                                        : 0.45,
                                  ),
                        ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// A slice of a [DonutChart].
@immutable
class DonutSlice {
  const DonutSlice({required this.value, required this.color});

  final int value;
  final Color color;
}

/// A ring chart with something in the middle (usually the total).
class DonutChart extends StatelessWidget {
  const DonutChart({
    required this.slices,
    this.center,
    this.size = 180,
    super.key,
  });

  final List<DonutSlice> slices;
  final Widget? center;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visible = slices.where((slice) => slice.value > 0).toList();
    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              startDegreeOffset: -90,
              sectionsSpace: visible.length > 1 ? 2 : 0,
              centerSpaceRadius: size * 0.34,
              pieTouchData: PieTouchData(enabled: false),
              sections: visible.isEmpty
                  ? [
                      PieChartSectionData(
                        value: 1,
                        color: theme.colorScheme.surfaceContainerHighest,
                        radius: size * 0.13,
                        showTitle: false,
                      ),
                    ]
                  : [
                      for (final slice in visible)
                        PieChartSectionData(
                          value: slice.value.toDouble(),
                          color: slice.color,
                          radius: size * 0.13,
                          showTitle: false,
                        ),
                    ],
            ),
          ),
          if (center != null)
            Padding(
              padding: EdgeInsets.all(size * 0.2),
              child: FittedBox(fit: BoxFit.scaleDown, child: center),
            ),
        ],
      ),
    );
  }
}

/// A coloured dot with a label, for chart legends.
class LegendDot extends StatelessWidget {
  const LegendDot({required this.color, required this.label, super.key});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: Insets.sm),
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
