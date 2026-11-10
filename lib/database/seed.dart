import 'package:drift/drift.dart';
import 'package:pandabudget/database/app_database.dart';
import 'package:pandabudget/features/categories/domain/category.dart';

class _Seed {
  const _Seed(
    this.en,
    this.de,
    this.icon,
    this.color, [
    this.children = const [],
  ]);

  final String en;
  final String de;
  final String icon;
  final int color;
  final List<(String en, String de, String icon)> children;
}

const List<_Seed> _expenseSeeds = [
  _Seed('Housing', 'Wohnen', 'home', 0xFF5B7C99, [
    ('Rent & mortgage', 'Miete & Kredit', 'home'),
    ('Utilities', 'Nebenkosten', 'bolt'),
    ('Internet & phone', 'Internet & Telefon', 'wifi'),
  ]),
  _Seed('Groceries', 'Lebensmittel', 'cart', 0xFF6A9A3A),
  _Seed('Eating out', 'Restaurants', 'restaurant', 0xFFD08A3C),
  _Seed('Transport', 'Mobilität', 'car', 0xFF4F8F8B, [
    ('Fuel', 'Tanken', 'fuel'),
    ('Public transport', 'ÖPNV & Bahn', 'train'),
    ('Car costs', 'Autokosten', 'car'),
  ]),
  _Seed('Insurance', 'Versicherungen', 'shield', 0xFF7A6FA8),
  _Seed('Health', 'Gesundheit', 'health', 0xFFC0605A),
  _Seed('Shopping', 'Einkäufe', 'bag', 0xFFB9739E, [
    ('Clothing', 'Kleidung', 'shirt'),
    ('Electronics', 'Elektronik', 'devices'),
    ('Home & garden', 'Haus & Garten', 'plant'),
  ]),
  _Seed('Leisure', 'Freizeit', 'leisure', 0xFFD9A441, [
    ('Subscriptions', 'Abos', 'subscriptions'),
    ('Travel', 'Reisen', 'flight'),
    ('Hobbies', 'Hobbys', 'leisure'),
  ]),
  _Seed('Children', 'Kinder', 'child', 0xFF89A85A),
  _Seed('Fees & taxes', 'Gebühren & Steuern', 'receipt', 0xFF8A8F86),
  _Seed('Other expenses', 'Sonstige Ausgaben', 'category', 0xFF9AA39A),
];

const List<_Seed> _incomeSeeds = [
  _Seed('Salary', 'Gehalt', 'work', 0xFF3F7D3A),
  _Seed('Benefits', 'Staatliche Leistungen', 'bank', 0xFF5E9E6A),
  _Seed('Other income', 'Sonstige Einnahmen', 'payments', 0xFF86B36B),
];

const List<_Seed> _transferSeeds = [
  _Seed('Transfers', 'Umbuchungen', 'swap', 0xFF8A8F86),
];

/// Fills a new database with a starter set of categories so the app is
/// usable right away. Users can rename, extend or delete them.
Future<void> seedDefaultCategories(
  AppDatabase db, {
  required String languageCode,
}) async {
  final german = languageCode == 'de';
  var order = 0;

  Future<void> insert(List<_Seed> seeds, CategoryKind kind) async {
    for (final seed in seeds) {
      final parentId = await db
          .into(db.categories)
          .insert(
            CategoriesCompanion.insert(
              name: german ? seed.de : seed.en,
              kind: kind,
              colorValue: seed.color,
              iconKey: Value(seed.icon),
              sortOrder: Value(order++),
            ),
          );
      for (final (en, de, icon) in seed.children) {
        await db
            .into(db.categories)
            .insert(
              CategoriesCompanion.insert(
                name: german ? de : en,
                kind: kind,
                parentId: Value(parentId),
                colorValue: seed.color,
                iconKey: Value(icon),
                sortOrder: Value(order++),
              ),
            );
      }
    }
  }

  await insert(_expenseSeeds, CategoryKind.expense);
  await insert(_incomeSeeds, CategoryKind.income);
  await insert(_transferSeeds, CategoryKind.transfer);
}
