import 'package:flutter/material.dart';
import 'package:pandabudget/core/theme/panda_colors.dart';
import 'package:pandabudget/core/theme/spacing.dart';
import 'package:pandabudget/core/widgets/panda_widgets.dart';

// Flat building blocks of the Bamboo design: content sits directly on the
// page, grouped by spacing and section headings instead of cards. None of
// them adds a horizontal gutter; that is the job of `PageBody`.

/// Smallest height of a tappable row.
const double _rowMin = 48;

/// Top of a main screen: title with an optional action, then a caption and
/// one big figure (usually an [AmountText] in `displayLarge`).
class PageHeader extends StatelessWidget {
  const PageHeader({
    required this.title,
    this.caption,
    this.figure,
    this.leading,
    this.action,
    super.key,
  });

  final String title;
  final String? caption;
  final Widget? figure;

  /// Shown before the title, for example the logo.
  final Widget? leading;

  /// Shown after the title, usually a text button.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: Insets.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (leading != null) ...[leading!, gapMd],
              Expanded(child: Text(title, style: theme.textTheme.titleLarge)),
              ?action,
            ],
          ),
          if (caption != null) ...[
            gapSm,
            Text(caption!, style: theme.textTheme.bodySmall),
          ],
          if (figure != null) ...[gapXs, figure!],
        ],
      ),
    );
  }
}

/// Top bar of a nested screen: chevron back button and title.
class SubpageBar extends StatelessWidget implements PreferredSizeWidget {
  const SubpageBar({required this.title, this.onBack, this.actions, super.key});

  final String title;

  /// Defaults to popping the current route.
  final VoidCallback? onBack;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: onBack ?? () => Navigator.of(context).maybePop(),
        icon: const Icon(Icons.chevron_left),
      ),
      title: Text(title, overflow: TextOverflow.ellipsis),
      actions: actions,
    );
  }
}

/// Full-width row in accent colour that opens another view.
class ActionLink extends StatelessWidget {
  const ActionLink({
    required this.label,
    required this.onTap,
    this.caption,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback onTap;

  /// Muted explanation below the label.
  final String? caption;

  /// Muted icon before the label.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: _rowMin),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Insets.sm),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: theme.colorScheme.onSurfaceVariant),
                gapMd,
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.bodyLarge?.copyWith(color: accent),
                    ),
                    if (caption != null)
                      Text(caption!, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              gapSm,
              Icon(Icons.chevron_right, size: 20, color: accent),
            ],
          ),
        ),
      ),
    );
  }
}

/// Title, optional subtitle and optional amount. No divider, no background.
class PandaListRow extends StatelessWidget {
  const PandaListRow({
    required this.title,
    this.subtitle,
    this.amountMinor,
    this.tone = AmountTone.plain,
    this.showPlus = false,
    this.leading,
    this.trailing,
    this.subtitleMaxLines = 1,
    this.indent = false,
    this.enabled = true,
    this.onTap,
    super.key,
  });

  final String title;
  final String? subtitle;
  final int? amountMinor;
  final AmountTone tone;
  final bool showPlus;
  final Widget? leading;

  /// Shown after the amount, for example a text button.
  final Widget? trailing;
  final int subtitleMaxLines;

  /// Indents the row, for children in a tree.
  final bool indent;

  /// A disabled row is dimmed but can still be tapped.
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: _rowMin),
        child: Padding(
          padding: EdgeInsets.only(
            top: Insets.sm,
            bottom: Insets.sm,
            left: indent ? Insets.lg : 0,
          ),
          child: Opacity(
            opacity: enabled ? 1 : 0.5,
            child: Row(
              children: [
                if (leading != null) ...[leading!, gapMd],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: text.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: text.bodySmall,
                          maxLines: subtitleMaxLines,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                if (amountMinor != null) ...[
                  gapMd,
                  AmountText(
                    amountMinor!,
                    tone: tone,
                    showPlus: showPlus,
                    style: text.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                if (trailing != null) ...[gapSm, trailing!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A budget or goal: title and "x of y" on one line, thin progress bar below.
class BudgetRow extends StatelessWidget {
  const BudgetRow({
    required this.title,
    required this.detail,
    required this.progress,
    this.color,
    this.note,
    this.noteColor,
    super.key,
  });

  final String title;
  final String detail;

  /// Share used; values above 1 turn the bar red.
  final double progress;
  final Color? color;

  /// Small line below the bar, for example "Behind plan".
  final String? note;
  final Color? noteColor;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Insets.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: text.bodyLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              gapMd,
              Text(detail, style: text.labelMedium),
            ],
          ),
          gapSm,
          UsageBar(value: progress, color: color),
          if (note != null) ...[
            gapXs,
            Text(note!, style: text.labelMedium?.copyWith(color: noteColor)),
          ],
        ],
      ),
    );
  }
}

/// An account at a glance: name above, balance below. Place in a grid with
/// 8dp gaps.
class AccountTile extends StatelessWidget {
  const AccountTile({
    required this.name,
    required this.balanceMinor,
    this.onTap,
    super.key,
  });

  final String name;
  final int balanceMinor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Insets.md,
            vertical: Insets.sm + Insets.xs,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: text.labelMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              gapMd,
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: AmountText(
                  balanceMinor,
                  style: text.titleMedium?.copyWith(
                    color: balanceMinor < 0
                        ? context.financeColors.expense
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Full-width text toggles that pick one of a few options. The selected one
/// is accent coloured and semibold; there is no fill or border.
class ChipBar<T> extends StatelessWidget {
  const ChipBar({
    required this.options,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  /// Value -> label, in display order.
  final Map<T, String> options;
  final T selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        for (final MapEntry(key: value, value: label) in options.entries)
          Expanded(
            child: Semantics(
              button: true,
              selected: value == selected,
              child: InkWell(
                onTap: () => onSelected(value),
                child: SizedBox(
                  height: _rowMin,
                  child: Center(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: value == selected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: value == selected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Text button in accent colour, for actions that add or open something
/// ("+ Add account").
class AccentTextButton extends StatelessWidget {
  const AccentTextButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      child: Text(label),
    );
  }
}

/// "+ Add account" at the end of a list: left aligned, accent coloured.
class AddLink extends StatelessWidget {
  const AddLink({required this.label, required this.onPressed, super.key});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.only(right: Insets.md),
        ),
        icon: const Icon(Icons.add, size: 18),
        label: Text(label),
      ),
    );
  }
}
