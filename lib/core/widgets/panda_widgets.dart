import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/money/money_providers.dart';
import 'package:pandabudget/core/theme/panda_colors.dart';
import 'package:pandabudget/core/theme/spacing.dart';
import 'package:pandabudget/core/time/year_month.dart';

/// Centers page content and limits its width on large windows.
class PageBody extends StatelessWidget {
  const PageBody({
    required this.children,
    this.maxWidth = Breakpoints.content,
    this.bottomPadding = Insets.xxl * 2,
    super.key,
  });

  final List<Widget> children;
  final double maxWidth;

  /// Extra space at the end so the last item scrolls clear of a FAB.
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gutter = constraints.maxWidth >= Breakpoints.wide
            ? Insets.xl
            : Insets.md;
        final extra = (constraints.maxWidth - maxWidth - 2 * gutter) / 2;
        final horizontal = gutter + (extra > 0 ? extra : 0);
        return ListView(
          padding: EdgeInsets.fromLTRB(
            horizontal,
            Insets.sm,
            horizontal,
            bottomPadding,
          ),
          children: children,
        );
      },
    );
  }
}

/// The app's content container: a quiet outlined surface.
class PandaCard extends StatelessWidget {
  const PandaCard({
    required this.child,
    this.padding = const EdgeInsets.all(Insets.lg),
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: child);
    return Card(
      child: onTap == null ? content : InkWell(onTap: onTap, child: content),
    );
  }
}

/// Title above a group of content, with an optional action on the right.
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {this.trailing, super.key});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Insets.lg, bottom: Insets.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// Small uppercase caption used above figures.
class Caption extends StatelessWidget {
  const Caption(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.labelMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

enum AmountTone {
  /// Default text colour.
  plain,

  /// Green when positive, red when negative.
  signed,

  /// Green when positive, default colour otherwise. Used in transaction
  /// lists, where most rows are expenses and red everywhere would shout.
  incomeOnly,
}

/// A formatted amount with tabular figures so columns of numbers line up.
class AmountText extends ConsumerWidget {
  const AmountText(
    this.amountMinor, {
    this.tone = AmountTone.plain,
    this.showPlus = false,
    this.style,
    super.key,
  });

  final int amountMinor;
  final AmountTone tone;
  final bool showPlus;
  final TextStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final money = ref.money(context);
    final finance = context.financeColors;
    final color = switch (tone) {
      AmountTone.plain => null,
      AmountTone.signed =>
        amountMinor > 0
            ? finance.income
            : amountMinor < 0
            ? finance.expense
            : null,
      AmountTone.incomeOnly => amountMinor > 0 ? finance.income : null,
    };
    return Text(
      showPlus ? money.formatSigned(amountMinor) : money.format(amountMinor),
      maxLines: 1,
      style: (style ?? DefaultTextStyle.of(context).style).copyWith(
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}

/// A caption with a figure below it.
class Figure extends StatelessWidget {
  const Figure({
    required this.label,
    required this.amountMinor,
    this.tone = AmountTone.plain,
    this.large = false,
    this.showPlus = false,
    super.key,
  });

  final String label;
  final int amountMinor;
  final AmountTone tone;
  final bool large;
  final bool showPlus;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Caption(label),
        gapXs,
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: AmountText(
            amountMinor,
            tone: tone,
            showPlus: showPlus,
            style: large ? text.headlineMedium : text.titleLarge,
          ),
        ),
      ],
    );
  }
}

/// Shown instead of a list when there is nothing to list yet.
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    this.message,
    this.action,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(Insets.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              gapMd,
              Text(
                title,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              if (message != null) ...[
                gapSm,
                Text(
                  message!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (action != null) ...[gapLg, action!],
            ],
          ),
        ),
      ),
    );
  }
}

/// Renders an [AsyncValue]: a spinner while loading, a message on error.
class AsyncView<T> extends StatelessWidget {
  const AsyncView({required this.value, required this.builder, super.key});

  final AsyncValue<T> value;
  final Widget Function(T data) builder;

  @override
  Widget build(BuildContext context) {
    return switch (value) {
      AsyncValue(:final value?) => builder(value),
      AsyncValue(hasValue: true) => builder(value.value as T),
      AsyncValue(:final error?) => EmptyState(
        icon: Icons.error_outline,
        title: context.l10n.errorTitle,
        message: '$error',
      ),
      _ => const Center(
        child: Padding(
          padding: EdgeInsets.all(Insets.xl),
          child: CircularProgressIndicator(),
        ),
      ),
    };
  }
}

/// "‹ October 2026 ›"
class MonthSwitcher extends StatelessWidget {
  const MonthSwitcher({
    required this.month,
    required this.onChanged,
    this.min,
    this.max,
    super.key,
  });

  final YearMonth month;
  final ValueChanged<YearMonth> onChanged;
  final YearMonth? min;
  final YearMonth? max;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final canGoBack = min == null || month.isAfter(min!);
    final canGoForward = max == null || month.isBefore(max!);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: l10n.previousMonth,
          onPressed: canGoBack ? () => onChanged(month.previous) : null,
          icon: const Icon(Icons.chevron_left),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 132),
          child: Text(
            context.formatMonth(month),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        IconButton(
          tooltip: l10n.nextMonth,
          onPressed: canGoForward ? () => onChanged(month.next) : null,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

/// A coloured circle with an icon, used for categories and accounts.
class ColorAvatar extends StatelessWidget {
  const ColorAvatar({
    required this.color,
    required this.icon,
    this.size = 40,
    super.key,
  });

  final Color color;
  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: size * 0.5, color: color),
    );
  }
}

/// A slim progress bar that turns red when [value] exceeds 1.
class UsageBar extends StatelessWidget {
  const UsageBar({required this.value, this.color, super.key});

  /// Share used; values above 1 mean "over".
  final double value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final over = value > 1;
    return LinearProgressIndicator(
      value: value.isFinite ? value.clamp(0, 1).toDouble() : 1,
      color: over
          ? context.financeColors.expense
          : color ?? Theme.of(context).colorScheme.primary,
    );
  }
}

/// A small rounded label, e.g. "On track".
class StatusPill extends StatelessWidget {
  const StatusPill({
    required this.label,
    required this.color,
    this.icon,
    super.key,
  });

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: const BorderRadius.all(Radius.circular(999)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium
                  ?.copyWith(color: color, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

/// Lays children out in equal-width columns on wide screens and stacks them
/// on narrow ones.
class AdaptiveColumns extends StatelessWidget {
  const AdaptiveColumns({
    required this.children,
    this.columns = 2,
    this.spacing = Insets.md,
    super.key,
  });

  final List<Widget> children;
  final int columns;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = constraints.maxWidth >= 720 ? columns : 1;
        if (count == 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (index, child) in children.indexed) ...[
                if (index > 0) SizedBox(height: spacing),
                child,
              ],
            ],
          );
        }
        final width = (constraints.maxWidth - spacing * (count - 1)) / count;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final child in children) SizedBox(width: width, child: child),
          ],
        );
      },
    );
  }
}

/// Asks before something is deleted. Returns true if the user confirmed.
Future<bool> confirmDelete(
  BuildContext context, {
  required String title,
  String? message,
}) async {
  final l10n = context.l10n;
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: message == null ? null : Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.delete),
        ),
      ],
    ),
  );
  return result ?? false;
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

/// A row of colour dots to pick from [PandaColors.swatches].
class ColorPickerRow extends StatelessWidget {
  const ColorPickerRow({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: Insets.sm,
      runSpacing: Insets.sm,
      children: [
        for (final swatch in PandaColors.swatches)
          InkWell(
            customBorder: const CircleBorder(),
            onTap: () => onChanged(swatch),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Color(swatch),
                shape: BoxShape.circle,
                border: Border.all(
                  color: swatch == value
                      ? scheme.onSurface
                      : Colors.transparent,
                  width: 3,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
              ),
              child: swatch == value
                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                  : null,
            ),
          ),
      ],
    );
  }
}
