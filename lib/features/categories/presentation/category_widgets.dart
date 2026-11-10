import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/theme/spacing.dart';
import 'package:pandabudget/core/widgets/form_widgets.dart';
import 'package:pandabudget/core/widgets/panda_widgets.dart';
import 'package:pandabudget/features/categories/data/drift_category_repository.dart';
import 'package:pandabudget/features/categories/domain/category.dart';

final categoriesProvider = StreamProvider<List<Category>>(
  (ref) => ref.watch(categoryRepositoryProvider).watchAll(),
);

/// All categories as a tree; empty while loading.
final categoryTreeProvider = Provider<CategoryTree>(
  (ref) => CategoryTree(ref.watch(categoriesProvider).value ?? const []),
);

/// Icons a category can use, by the key stored in the database.
const Map<String, IconData> categoryIcons = {
  'category': Icons.label_outline,
  'home': Icons.home_outlined,
  'bolt': Icons.bolt_outlined,
  'wifi': Icons.wifi,
  'cart': Icons.shopping_cart_outlined,
  'restaurant': Icons.restaurant_outlined,
  'car': Icons.directions_car_outlined,
  'fuel': Icons.local_gas_station_outlined,
  'train': Icons.train_outlined,
  'shield': Icons.shield_outlined,
  'health': Icons.favorite_outline,
  'bag': Icons.shopping_bag_outlined,
  'shirt': Icons.checkroom_outlined,
  'devices': Icons.devices_outlined,
  'plant': Icons.yard_outlined,
  'leisure': Icons.sports_esports_outlined,
  'subscriptions': Icons.subscriptions_outlined,
  'flight': Icons.flight_outlined,
  'child': Icons.child_care_outlined,
  'receipt': Icons.receipt_long_outlined,
  'work': Icons.work_outline,
  'bank': Icons.account_balance_outlined,
  'payments': Icons.payments_outlined,
  'swap': Icons.swap_horiz,
  'savings': Icons.savings_outlined,
  'pets': Icons.pets_outlined,
  'school': Icons.school_outlined,
  'gift': Icons.card_giftcard_outlined,
  'fitness': Icons.fitness_center_outlined,
  'coffee': Icons.local_cafe_outlined,
};

IconData categoryIcon(String key) => categoryIcons[key] ?? Icons.label_outline;

class CategoryAvatar extends StatelessWidget {
  const CategoryAvatar(this.category, {this.size = 40, super.key});

  /// Null renders the "uncategorised" placeholder.
  final Category? category;
  final double size;

  @override
  Widget build(BuildContext context) {
    final category = this.category;
    if (category == null) {
      return ColorAvatar(
        color: Theme.of(context).colorScheme.outline,
        icon: Icons.question_mark,
        size: size,
      );
    }
    return ColorAvatar(
      color: Color(category.colorValue),
      icon: categoryIcon(category.iconKey),
      size: size,
    );
  }
}

/// Form field showing the chosen category; opens the picker on tap.
class CategoryField extends ConsumerWidget {
  const CategoryField({
    required this.value,
    required this.onChanged,
    this.label,
    this.kinds,
    this.clearable = true,
    super.key,
  });

  final int? value;
  final ValueChanged<int?> onChanged;
  final String? label;
  final Set<CategoryKind>? kinds;
  final bool clearable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tree = ref.watch(categoryTreeProvider);
    final category = tree[value];
    return PickerField(
      label: label ?? context.l10n.category,
      value: category == null ? null : tree.pathOf(category.id),
      leading: category == null
          ? null
          : Padding(
              padding: const EdgeInsets.all(Insets.sm),
              child: CategoryAvatar(category, size: 28),
            ),
      onClear: clearable ? () => onChanged(null) : null,
      onTap: () async {
        final picked = await showCategoryPicker(context, kinds: kinds);
        if (picked != null) onChanged(picked.id);
      },
    );
  }
}

/// Bottom sheet with a searchable list of categories.
Future<Category?> showCategoryPicker(
  BuildContext context, {
  Set<CategoryKind>? kinds,
}) {
  return showModalBottomSheet<Category>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: const BoxConstraints(maxWidth: Breakpoints.form),
    builder: (context) => _CategoryPickerSheet(kinds: kinds),
  );
}

class _CategoryPickerSheet extends ConsumerStatefulWidget {
  const _CategoryPickerSheet({this.kinds});

  final Set<CategoryKind>? kinds;

  @override
  ConsumerState<_CategoryPickerSheet> createState() =>
      _CategoryPickerSheetState();
}

class _CategoryPickerSheetState extends ConsumerState<_CategoryPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tree = ref.watch(categoryTreeProvider);
    final query = _query.trim().toLowerCase();
    final categories = tree.flattened.where((category) {
      if (category.isArchived) return false;
      if (widget.kinds != null && !widget.kinds!.contains(category.kind)) {
        return false;
      }
      return query.isEmpty ||
          tree.pathOf(category.id).toLowerCase().contains(query);
    }).toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Insets.md,
              0,
              Insets.md,
              Insets.sm,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: l10n.searchCategories,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Expanded(
            child: categories.isEmpty
                ? EmptyState(
                    icon: Icons.label_off_outlined,
                    title: l10n.noCategoriesFound,
                  )
                : ListView.builder(
                    controller: scrollController,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isChild = category.parentId != null;
                      return ListTile(
                        contentPadding: EdgeInsets.only(
                          left: isChild && query.isEmpty
                              ? Insets.xl + Insets.md
                              : Insets.md,
                          right: Insets.md,
                        ),
                        leading: CategoryAvatar(category, size: 36),
                        title: Text(
                          query.isEmpty
                              ? category.name
                              : tree.pathOf(category.id),
                        ),
                        onTap: () => Navigator.of(context).pop(category),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
