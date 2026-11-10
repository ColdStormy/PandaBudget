import 'package:meta/meta.dart';
import 'package:pandabudget/core/entity.dart';

enum CategoryKind {
  expense,
  income,

  /// Money moved between the household's own accounts. Excluded from income
  /// and spending figures.
  transfer,
}

@immutable
class Category {
  const Category({
    required this.name,
    required this.kind,
    this.id = kNewId,
    this.parentId,
    this.colorValue = 0xFF6A9A3A,
    this.iconKey = 'category',
    this.isArchived = false,
    this.sortOrder = 0,
  });

  final int id;
  final String name;
  final CategoryKind kind;

  /// Set for sub-categories. Only one level of nesting is supported.
  final int? parentId;
  final int colorValue;
  final String iconKey;
  final bool isArchived;
  final int sortOrder;

  bool get isNew => id == kNewId;

  Category copyWith({
    int? id,
    String? name,
    CategoryKind? kind,
    int? Function()? parentId,
    int? colorValue,
    String? iconKey,
    bool? isArchived,
    int? sortOrder,
  }) => Category(
    id: id ?? this.id,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    parentId: parentId != null ? parentId() : this.parentId,
    colorValue: colorValue ?? this.colorValue,
    iconKey: iconKey ?? this.iconKey,
    isArchived: isArchived ?? this.isArchived,
    sortOrder: sortOrder ?? this.sortOrder,
  );
}

/// Lookup helpers over the full category list.
class CategoryTree {
  CategoryTree(Iterable<Category> categories)
    : byId = {for (final c in categories) c.id: c};

  final Map<int, Category> byId;

  Category? operator [](int? id) => id == null ? null : byId[id];

  Iterable<Category> get all => byId.values;

  List<Category> get roots =>
      _sorted(byId.values.where((c) => c.parentId == null));

  List<Category> childrenOf(int id) =>
      _sorted(byId.values.where((c) => c.parentId == id));

  /// The top-level category [id] belongs to (itself if it is top-level).
  int rootIdOf(int id) => byId[id]?.parentId ?? id;

  /// [id] plus the ids of its sub-categories.
  Set<int> withDescendants(int id) => {
    id,
    for (final c in byId.values)
      if (c.parentId == id) c.id,
  };

  /// "Parent › Child" for sub-categories, the plain name otherwise.
  String pathOf(int id) {
    final category = byId[id];
    if (category == null) return '';
    final parent = this[category.parentId];
    return parent == null ? category.name : '${parent.name} › ${category.name}';
  }

  /// Roots, each followed by its children: the order used in pickers.
  List<Category> get flattened => [
    for (final root in roots) ...[root, ...childrenOf(root.id)],
  ];

  static List<Category> _sorted(Iterable<Category> items) =>
      items.toList()..sort((a, b) {
        final order = a.sortOrder.compareTo(b.sortOrder);
        return order != 0
            ? order
            : a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
}

abstract interface class CategoryRepository {
  Stream<List<Category>> watchAll({bool includeArchived = true});

  Future<List<Category>> getAll();

  Future<int> save(Category category);

  /// Deletes the category and its sub-categories. Transactions that used
  /// them become uncategorised.
  Future<void> delete(int id);
}
