// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AccountsTable extends Accounts
    with TableInfo<$AccountsTable, AccountRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AccountKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<AccountKind>($AccountsTable.$converterkind);
  static const VerificationMeta _ibanMeta = const VerificationMeta('iban');
  @override
  late final GeneratedColumn<String> iban = GeneratedColumn<String>(
    'iban',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _openingBalanceMinorMeta =
      const VerificationMeta('openingBalanceMinor');
  @override
  late final GeneratedColumn<int> openingBalanceMinor = GeneratedColumn<int>(
    'opening_balance_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> openingDate =
      GeneratedColumn<int>(
        'opening_date',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($AccountsTable.$converteropeningDate);
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    kind,
    iban,
    openingBalanceMinor,
    openingDate,
    isArchived,
    colorValue,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('iban')) {
      context.handle(
        _ibanMeta,
        iban.isAcceptableOrUnknown(data['iban']!, _ibanMeta),
      );
    }
    if (data.containsKey('opening_balance_minor')) {
      context.handle(
        _openingBalanceMinorMeta,
        openingBalanceMinor.isAcceptableOrUnknown(
          data['opening_balance_minor']!,
          _openingBalanceMinorMeta,
        ),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      kind: $AccountsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      iban: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}iban'],
      ),
      openingBalanceMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}opening_balance_minor'],
      )!,
      openingDate: $AccountsTable.$converteropeningDate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}opening_date'],
        )!,
      ),
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AccountKind, String, String> $converterkind =
      const EnumNameConverter<AccountKind>(AccountKind.values);
  static TypeConverter<DateTime, int> $converteropeningDate =
      const DateOnlyConverter();
}

class AccountRow extends DataClass implements Insertable<AccountRow> {
  final int id;
  final String name;
  final AccountKind kind;
  final String? iban;
  final int openingBalanceMinor;
  final DateTime openingDate;
  final bool isArchived;
  final int colorValue;
  final int sortOrder;
  const AccountRow({
    required this.id,
    required this.name,
    required this.kind,
    this.iban,
    required this.openingBalanceMinor,
    required this.openingDate,
    required this.isArchived,
    required this.colorValue,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['kind'] = Variable<String>($AccountsTable.$converterkind.toSql(kind));
    }
    if (!nullToAbsent || iban != null) {
      map['iban'] = Variable<String>(iban);
    }
    map['opening_balance_minor'] = Variable<int>(openingBalanceMinor);
    {
      map['opening_date'] = Variable<int>(
        $AccountsTable.$converteropeningDate.toSql(openingDate),
      );
    }
    map['is_archived'] = Variable<bool>(isArchived);
    map['color_value'] = Variable<int>(colorValue);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      name: Value(name),
      kind: Value(kind),
      iban: iban == null && nullToAbsent ? const Value.absent() : Value(iban),
      openingBalanceMinor: Value(openingBalanceMinor),
      openingDate: Value(openingDate),
      isArchived: Value(isArchived),
      colorValue: Value(colorValue),
      sortOrder: Value(sortOrder),
    );
  }

  factory AccountRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      kind: $AccountsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      iban: serializer.fromJson<String?>(json['iban']),
      openingBalanceMinor: serializer.fromJson<int>(
        json['openingBalanceMinor'],
      ),
      openingDate: serializer.fromJson<DateTime>(json['openingDate']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<String>(
        $AccountsTable.$converterkind.toJson(kind),
      ),
      'iban': serializer.toJson<String?>(iban),
      'openingBalanceMinor': serializer.toJson<int>(openingBalanceMinor),
      'openingDate': serializer.toJson<DateTime>(openingDate),
      'isArchived': serializer.toJson<bool>(isArchived),
      'colorValue': serializer.toJson<int>(colorValue),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  AccountRow copyWith({
    int? id,
    String? name,
    AccountKind? kind,
    Value<String?> iban = const Value.absent(),
    int? openingBalanceMinor,
    DateTime? openingDate,
    bool? isArchived,
    int? colorValue,
    int? sortOrder,
  }) => AccountRow(
    id: id ?? this.id,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    iban: iban.present ? iban.value : this.iban,
    openingBalanceMinor: openingBalanceMinor ?? this.openingBalanceMinor,
    openingDate: openingDate ?? this.openingDate,
    isArchived: isArchived ?? this.isArchived,
    colorValue: colorValue ?? this.colorValue,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  AccountRow copyWithCompanion(AccountsCompanion data) {
    return AccountRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      iban: data.iban.present ? data.iban.value : this.iban,
      openingBalanceMinor: data.openingBalanceMinor.present
          ? data.openingBalanceMinor.value
          : this.openingBalanceMinor,
      openingDate: data.openingDate.present
          ? data.openingDate.value
          : this.openingDate,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('iban: $iban, ')
          ..write('openingBalanceMinor: $openingBalanceMinor, ')
          ..write('openingDate: $openingDate, ')
          ..write('isArchived: $isArchived, ')
          ..write('colorValue: $colorValue, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    kind,
    iban,
    openingBalanceMinor,
    openingDate,
    isArchived,
    colorValue,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.iban == this.iban &&
          other.openingBalanceMinor == this.openingBalanceMinor &&
          other.openingDate == this.openingDate &&
          other.isArchived == this.isArchived &&
          other.colorValue == this.colorValue &&
          other.sortOrder == this.sortOrder);
}

class AccountsCompanion extends UpdateCompanion<AccountRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<AccountKind> kind;
  final Value<String?> iban;
  final Value<int> openingBalanceMinor;
  final Value<DateTime> openingDate;
  final Value<bool> isArchived;
  final Value<int> colorValue;
  final Value<int> sortOrder;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.iban = const Value.absent(),
    this.openingBalanceMinor = const Value.absent(),
    this.openingDate = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  AccountsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required AccountKind kind,
    this.iban = const Value.absent(),
    this.openingBalanceMinor = const Value.absent(),
    required DateTime openingDate,
    this.isArchived = const Value.absent(),
    required int colorValue,
    this.sortOrder = const Value.absent(),
  }) : name = Value(name),
       kind = Value(kind),
       openingDate = Value(openingDate),
       colorValue = Value(colorValue);
  static Insertable<AccountRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<String>? iban,
    Expression<int>? openingBalanceMinor,
    Expression<int>? openingDate,
    Expression<bool>? isArchived,
    Expression<int>? colorValue,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (iban != null) 'iban': iban,
      if (openingBalanceMinor != null)
        'opening_balance_minor': openingBalanceMinor,
      if (openingDate != null) 'opening_date': openingDate,
      if (isArchived != null) 'is_archived': isArchived,
      if (colorValue != null) 'color_value': colorValue,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  AccountsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<AccountKind>? kind,
    Value<String?>? iban,
    Value<int>? openingBalanceMinor,
    Value<DateTime>? openingDate,
    Value<bool>? isArchived,
    Value<int>? colorValue,
    Value<int>? sortOrder,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      iban: iban ?? this.iban,
      openingBalanceMinor: openingBalanceMinor ?? this.openingBalanceMinor,
      openingDate: openingDate ?? this.openingDate,
      isArchived: isArchived ?? this.isArchived,
      colorValue: colorValue ?? this.colorValue,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $AccountsTable.$converterkind.toSql(kind.value),
      );
    }
    if (iban.present) {
      map['iban'] = Variable<String>(iban.value);
    }
    if (openingBalanceMinor.present) {
      map['opening_balance_minor'] = Variable<int>(openingBalanceMinor.value);
    }
    if (openingDate.present) {
      map['opening_date'] = Variable<int>(
        $AccountsTable.$converteropeningDate.toSql(openingDate.value),
      );
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('iban: $iban, ')
          ..write('openingBalanceMinor: $openingBalanceMinor, ')
          ..write('openingDate: $openingDate, ')
          ..write('isArchived: $isArchived, ')
          ..write('colorValue: $colorValue, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, CategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CategoryKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CategoryKind>($CategoriesTable.$converterkind);
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconKeyMeta = const VerificationMeta(
    'iconKey',
  );
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
    'icon_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('category'),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    kind,
    parentId,
    colorValue,
    iconKey,
    isArchived,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    if (data.containsKey('icon_key')) {
      context.handle(
        _iconKeyMeta,
        iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      kind: $CategoriesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_id'],
      ),
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      )!,
      iconKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_key'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CategoryKind, String, String> $converterkind =
      const EnumNameConverter<CategoryKind>(CategoryKind.values);
}

class CategoryRow extends DataClass implements Insertable<CategoryRow> {
  final int id;
  final String name;
  final CategoryKind kind;
  final int? parentId;
  final int colorValue;
  final String iconKey;
  final bool isArchived;
  final int sortOrder;
  const CategoryRow({
    required this.id,
    required this.name,
    required this.kind,
    this.parentId,
    required this.colorValue,
    required this.iconKey,
    required this.isArchived,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['kind'] = Variable<String>(
        $CategoriesTable.$converterkind.toSql(kind),
      );
    }
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    map['color_value'] = Variable<int>(colorValue);
    map['icon_key'] = Variable<String>(iconKey);
    map['is_archived'] = Variable<bool>(isArchived);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      kind: Value(kind),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      colorValue: Value(colorValue),
      iconKey: Value(iconKey),
      isArchived: Value(isArchived),
      sortOrder: Value(sortOrder),
    );
  }

  factory CategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      kind: $CategoriesTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      parentId: serializer.fromJson<int?>(json['parentId']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      iconKey: serializer.fromJson<String>(json['iconKey']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<String>(
        $CategoriesTable.$converterkind.toJson(kind),
      ),
      'parentId': serializer.toJson<int?>(parentId),
      'colorValue': serializer.toJson<int>(colorValue),
      'iconKey': serializer.toJson<String>(iconKey),
      'isArchived': serializer.toJson<bool>(isArchived),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  CategoryRow copyWith({
    int? id,
    String? name,
    CategoryKind? kind,
    Value<int?> parentId = const Value.absent(),
    int? colorValue,
    String? iconKey,
    bool? isArchived,
    int? sortOrder,
  }) => CategoryRow(
    id: id ?? this.id,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    parentId: parentId.present ? parentId.value : this.parentId,
    colorValue: colorValue ?? this.colorValue,
    iconKey: iconKey ?? this.iconKey,
    isArchived: isArchived ?? this.isArchived,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  CategoryRow copyWithCompanion(CategoriesCompanion data) {
    return CategoryRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('parentId: $parentId, ')
          ..write('colorValue: $colorValue, ')
          ..write('iconKey: $iconKey, ')
          ..write('isArchived: $isArchived, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    kind,
    parentId,
    colorValue,
    iconKey,
    isArchived,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.parentId == this.parentId &&
          other.colorValue == this.colorValue &&
          other.iconKey == this.iconKey &&
          other.isArchived == this.isArchived &&
          other.sortOrder == this.sortOrder);
}

class CategoriesCompanion extends UpdateCompanion<CategoryRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<CategoryKind> kind;
  final Value<int?> parentId;
  final Value<int> colorValue;
  final Value<String> iconKey;
  final Value<bool> isArchived;
  final Value<int> sortOrder;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.parentId = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required CategoryKind kind,
    this.parentId = const Value.absent(),
    required int colorValue,
    this.iconKey = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : name = Value(name),
       kind = Value(kind),
       colorValue = Value(colorValue);
  static Insertable<CategoryRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<int>? parentId,
    Expression<int>? colorValue,
    Expression<String>? iconKey,
    Expression<bool>? isArchived,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (parentId != null) 'parent_id': parentId,
      if (colorValue != null) 'color_value': colorValue,
      if (iconKey != null) 'icon_key': iconKey,
      if (isArchived != null) 'is_archived': isArchived,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<CategoryKind>? kind,
    Value<int?>? parentId,
    Value<int>? colorValue,
    Value<String>? iconKey,
    Value<bool>? isArchived,
    Value<int>? sortOrder,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      parentId: parentId ?? this.parentId,
      colorValue: colorValue ?? this.colorValue,
      iconKey: iconKey ?? this.iconKey,
      isArchived: isArchived ?? this.isArchived,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $CategoriesTable.$converterkind.toSql(kind.value),
      );
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('parentId: $parentId, ')
          ..write('colorValue: $colorValue, ')
          ..write('iconKey: $iconKey, ')
          ..write('isArchived: $isArchived, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $ImportProfilesTable extends ImportProfiles
    with TableInfo<$ImportProfilesTable, ImportProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImportProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ImportFileType, String> fileType =
      GeneratedColumn<String>(
        'file_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ImportFileType>($ImportProfilesTable.$converterfileType);
  static const VerificationMeta _delimiterMeta = const VerificationMeta(
    'delimiter',
  );
  @override
  late final GeneratedColumn<String> delimiter = GeneratedColumn<String>(
    'delimiter',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TextEncoding, String> encoding =
      GeneratedColumn<String>(
        'encoding',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TextEncoding>($ImportProfilesTable.$converterencoding);
  static const VerificationMeta _headerRowMeta = const VerificationMeta(
    'headerRow',
  );
  @override
  late final GeneratedColumn<int> headerRow = GeneratedColumn<int>(
    'header_row',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(-1),
  );
  static const VerificationMeta _dateFormatMeta = const VerificationMeta(
    'dateFormat',
  );
  @override
  late final GeneratedColumn<String> dateFormat = GeneratedColumn<String>(
    'date_format',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _decimalSeparatorMeta = const VerificationMeta(
    'decimalSeparator',
  );
  @override
  late final GeneratedColumn<String> decimalSeparator = GeneratedColumn<String>(
    'decimal_separator',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AmountMode, String> amountMode =
      GeneratedColumn<String>(
        'amount_mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<AmountMode>($ImportProfilesTable.$converteramountMode);
  @override
  late final GeneratedColumnWithTypeConverter<Map<ImportField, String>, String>
  mapping =
      GeneratedColumn<String>(
        'mapping',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Map<ImportField, String>>(
        $ImportProfilesTable.$convertermapping,
      );
  static const VerificationMeta _invertSignMeta = const VerificationMeta(
    'invertSign',
  );
  @override
  late final GeneratedColumn<bool> invertSign = GeneratedColumn<bool>(
    'invert_sign',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("invert_sign" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _debitIndicatorsMeta = const VerificationMeta(
    'debitIndicators',
  );
  @override
  late final GeneratedColumn<String> debitIndicators = GeneratedColumn<String>(
    'debit_indicators',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonRootPathMeta = const VerificationMeta(
    'jsonRootPath',
  );
  @override
  late final GeneratedColumn<String> jsonRootPath = GeneratedColumn<String>(
    'json_root_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    fileType,
    delimiter,
    encoding,
    headerRow,
    dateFormat,
    decimalSeparator,
    amountMode,
    mapping,
    invertSign,
    debitIndicators,
    jsonRootPath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'import_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ImportProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('delimiter')) {
      context.handle(
        _delimiterMeta,
        delimiter.isAcceptableOrUnknown(data['delimiter']!, _delimiterMeta),
      );
    }
    if (data.containsKey('header_row')) {
      context.handle(
        _headerRowMeta,
        headerRow.isAcceptableOrUnknown(data['header_row']!, _headerRowMeta),
      );
    }
    if (data.containsKey('date_format')) {
      context.handle(
        _dateFormatMeta,
        dateFormat.isAcceptableOrUnknown(data['date_format']!, _dateFormatMeta),
      );
    } else if (isInserting) {
      context.missing(_dateFormatMeta);
    }
    if (data.containsKey('decimal_separator')) {
      context.handle(
        _decimalSeparatorMeta,
        decimalSeparator.isAcceptableOrUnknown(
          data['decimal_separator']!,
          _decimalSeparatorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_decimalSeparatorMeta);
    }
    if (data.containsKey('invert_sign')) {
      context.handle(
        _invertSignMeta,
        invertSign.isAcceptableOrUnknown(data['invert_sign']!, _invertSignMeta),
      );
    }
    if (data.containsKey('debit_indicators')) {
      context.handle(
        _debitIndicatorsMeta,
        debitIndicators.isAcceptableOrUnknown(
          data['debit_indicators']!,
          _debitIndicatorsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_debitIndicatorsMeta);
    }
    if (data.containsKey('json_root_path')) {
      context.handle(
        _jsonRootPathMeta,
        jsonRootPath.isAcceptableOrUnknown(
          data['json_root_path']!,
          _jsonRootPathMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ImportProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImportProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      fileType: $ImportProfilesTable.$converterfileType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}file_type'],
        )!,
      ),
      delimiter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}delimiter'],
      )!,
      encoding: $ImportProfilesTable.$converterencoding.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}encoding'],
        )!,
      ),
      headerRow: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}header_row'],
      )!,
      dateFormat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_format'],
      )!,
      decimalSeparator: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}decimal_separator'],
      )!,
      amountMode: $ImportProfilesTable.$converteramountMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}amount_mode'],
        )!,
      ),
      mapping: $ImportProfilesTable.$convertermapping.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}mapping'],
        )!,
      ),
      invertSign: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}invert_sign'],
      )!,
      debitIndicators: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}debit_indicators'],
      )!,
      jsonRootPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json_root_path'],
      )!,
    );
  }

  @override
  $ImportProfilesTable createAlias(String alias) {
    return $ImportProfilesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ImportFileType, String, String> $converterfileType =
      const EnumNameConverter<ImportFileType>(ImportFileType.values);
  static JsonTypeConverter2<TextEncoding, String, String> $converterencoding =
      const EnumNameConverter<TextEncoding>(TextEncoding.values);
  static JsonTypeConverter2<AmountMode, String, String> $converteramountMode =
      const EnumNameConverter<AmountMode>(AmountMode.values);
  static TypeConverter<Map<ImportField, String>, String> $convertermapping =
      const FieldMappingConverter();
}

class ImportProfileRow extends DataClass
    implements Insertable<ImportProfileRow> {
  final int id;
  final String name;
  final ImportFileType fileType;
  final String delimiter;
  final TextEncoding encoding;
  final int headerRow;
  final String dateFormat;
  final String decimalSeparator;
  final AmountMode amountMode;
  final Map<ImportField, String> mapping;
  final bool invertSign;
  final String debitIndicators;
  final String jsonRootPath;
  const ImportProfileRow({
    required this.id,
    required this.name,
    required this.fileType,
    required this.delimiter,
    required this.encoding,
    required this.headerRow,
    required this.dateFormat,
    required this.decimalSeparator,
    required this.amountMode,
    required this.mapping,
    required this.invertSign,
    required this.debitIndicators,
    required this.jsonRootPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['file_type'] = Variable<String>(
        $ImportProfilesTable.$converterfileType.toSql(fileType),
      );
    }
    map['delimiter'] = Variable<String>(delimiter);
    {
      map['encoding'] = Variable<String>(
        $ImportProfilesTable.$converterencoding.toSql(encoding),
      );
    }
    map['header_row'] = Variable<int>(headerRow);
    map['date_format'] = Variable<String>(dateFormat);
    map['decimal_separator'] = Variable<String>(decimalSeparator);
    {
      map['amount_mode'] = Variable<String>(
        $ImportProfilesTable.$converteramountMode.toSql(amountMode),
      );
    }
    {
      map['mapping'] = Variable<String>(
        $ImportProfilesTable.$convertermapping.toSql(mapping),
      );
    }
    map['invert_sign'] = Variable<bool>(invertSign);
    map['debit_indicators'] = Variable<String>(debitIndicators);
    map['json_root_path'] = Variable<String>(jsonRootPath);
    return map;
  }

  ImportProfilesCompanion toCompanion(bool nullToAbsent) {
    return ImportProfilesCompanion(
      id: Value(id),
      name: Value(name),
      fileType: Value(fileType),
      delimiter: Value(delimiter),
      encoding: Value(encoding),
      headerRow: Value(headerRow),
      dateFormat: Value(dateFormat),
      decimalSeparator: Value(decimalSeparator),
      amountMode: Value(amountMode),
      mapping: Value(mapping),
      invertSign: Value(invertSign),
      debitIndicators: Value(debitIndicators),
      jsonRootPath: Value(jsonRootPath),
    );
  }

  factory ImportProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImportProfileRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      fileType: $ImportProfilesTable.$converterfileType.fromJson(
        serializer.fromJson<String>(json['fileType']),
      ),
      delimiter: serializer.fromJson<String>(json['delimiter']),
      encoding: $ImportProfilesTable.$converterencoding.fromJson(
        serializer.fromJson<String>(json['encoding']),
      ),
      headerRow: serializer.fromJson<int>(json['headerRow']),
      dateFormat: serializer.fromJson<String>(json['dateFormat']),
      decimalSeparator: serializer.fromJson<String>(json['decimalSeparator']),
      amountMode: $ImportProfilesTable.$converteramountMode.fromJson(
        serializer.fromJson<String>(json['amountMode']),
      ),
      mapping: serializer.fromJson<Map<ImportField, String>>(json['mapping']),
      invertSign: serializer.fromJson<bool>(json['invertSign']),
      debitIndicators: serializer.fromJson<String>(json['debitIndicators']),
      jsonRootPath: serializer.fromJson<String>(json['jsonRootPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'fileType': serializer.toJson<String>(
        $ImportProfilesTable.$converterfileType.toJson(fileType),
      ),
      'delimiter': serializer.toJson<String>(delimiter),
      'encoding': serializer.toJson<String>(
        $ImportProfilesTable.$converterencoding.toJson(encoding),
      ),
      'headerRow': serializer.toJson<int>(headerRow),
      'dateFormat': serializer.toJson<String>(dateFormat),
      'decimalSeparator': serializer.toJson<String>(decimalSeparator),
      'amountMode': serializer.toJson<String>(
        $ImportProfilesTable.$converteramountMode.toJson(amountMode),
      ),
      'mapping': serializer.toJson<Map<ImportField, String>>(mapping),
      'invertSign': serializer.toJson<bool>(invertSign),
      'debitIndicators': serializer.toJson<String>(debitIndicators),
      'jsonRootPath': serializer.toJson<String>(jsonRootPath),
    };
  }

  ImportProfileRow copyWith({
    int? id,
    String? name,
    ImportFileType? fileType,
    String? delimiter,
    TextEncoding? encoding,
    int? headerRow,
    String? dateFormat,
    String? decimalSeparator,
    AmountMode? amountMode,
    Map<ImportField, String>? mapping,
    bool? invertSign,
    String? debitIndicators,
    String? jsonRootPath,
  }) => ImportProfileRow(
    id: id ?? this.id,
    name: name ?? this.name,
    fileType: fileType ?? this.fileType,
    delimiter: delimiter ?? this.delimiter,
    encoding: encoding ?? this.encoding,
    headerRow: headerRow ?? this.headerRow,
    dateFormat: dateFormat ?? this.dateFormat,
    decimalSeparator: decimalSeparator ?? this.decimalSeparator,
    amountMode: amountMode ?? this.amountMode,
    mapping: mapping ?? this.mapping,
    invertSign: invertSign ?? this.invertSign,
    debitIndicators: debitIndicators ?? this.debitIndicators,
    jsonRootPath: jsonRootPath ?? this.jsonRootPath,
  );
  ImportProfileRow copyWithCompanion(ImportProfilesCompanion data) {
    return ImportProfileRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      fileType: data.fileType.present ? data.fileType.value : this.fileType,
      delimiter: data.delimiter.present ? data.delimiter.value : this.delimiter,
      encoding: data.encoding.present ? data.encoding.value : this.encoding,
      headerRow: data.headerRow.present ? data.headerRow.value : this.headerRow,
      dateFormat: data.dateFormat.present
          ? data.dateFormat.value
          : this.dateFormat,
      decimalSeparator: data.decimalSeparator.present
          ? data.decimalSeparator.value
          : this.decimalSeparator,
      amountMode: data.amountMode.present
          ? data.amountMode.value
          : this.amountMode,
      mapping: data.mapping.present ? data.mapping.value : this.mapping,
      invertSign: data.invertSign.present
          ? data.invertSign.value
          : this.invertSign,
      debitIndicators: data.debitIndicators.present
          ? data.debitIndicators.value
          : this.debitIndicators,
      jsonRootPath: data.jsonRootPath.present
          ? data.jsonRootPath.value
          : this.jsonRootPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImportProfileRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('fileType: $fileType, ')
          ..write('delimiter: $delimiter, ')
          ..write('encoding: $encoding, ')
          ..write('headerRow: $headerRow, ')
          ..write('dateFormat: $dateFormat, ')
          ..write('decimalSeparator: $decimalSeparator, ')
          ..write('amountMode: $amountMode, ')
          ..write('mapping: $mapping, ')
          ..write('invertSign: $invertSign, ')
          ..write('debitIndicators: $debitIndicators, ')
          ..write('jsonRootPath: $jsonRootPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    fileType,
    delimiter,
    encoding,
    headerRow,
    dateFormat,
    decimalSeparator,
    amountMode,
    mapping,
    invertSign,
    debitIndicators,
    jsonRootPath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImportProfileRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.fileType == this.fileType &&
          other.delimiter == this.delimiter &&
          other.encoding == this.encoding &&
          other.headerRow == this.headerRow &&
          other.dateFormat == this.dateFormat &&
          other.decimalSeparator == this.decimalSeparator &&
          other.amountMode == this.amountMode &&
          other.mapping == this.mapping &&
          other.invertSign == this.invertSign &&
          other.debitIndicators == this.debitIndicators &&
          other.jsonRootPath == this.jsonRootPath);
}

class ImportProfilesCompanion extends UpdateCompanion<ImportProfileRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<ImportFileType> fileType;
  final Value<String> delimiter;
  final Value<TextEncoding> encoding;
  final Value<int> headerRow;
  final Value<String> dateFormat;
  final Value<String> decimalSeparator;
  final Value<AmountMode> amountMode;
  final Value<Map<ImportField, String>> mapping;
  final Value<bool> invertSign;
  final Value<String> debitIndicators;
  final Value<String> jsonRootPath;
  const ImportProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.fileType = const Value.absent(),
    this.delimiter = const Value.absent(),
    this.encoding = const Value.absent(),
    this.headerRow = const Value.absent(),
    this.dateFormat = const Value.absent(),
    this.decimalSeparator = const Value.absent(),
    this.amountMode = const Value.absent(),
    this.mapping = const Value.absent(),
    this.invertSign = const Value.absent(),
    this.debitIndicators = const Value.absent(),
    this.jsonRootPath = const Value.absent(),
  });
  ImportProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required ImportFileType fileType,
    this.delimiter = const Value.absent(),
    required TextEncoding encoding,
    this.headerRow = const Value.absent(),
    required String dateFormat,
    required String decimalSeparator,
    required AmountMode amountMode,
    required Map<ImportField, String> mapping,
    this.invertSign = const Value.absent(),
    required String debitIndicators,
    this.jsonRootPath = const Value.absent(),
  }) : name = Value(name),
       fileType = Value(fileType),
       encoding = Value(encoding),
       dateFormat = Value(dateFormat),
       decimalSeparator = Value(decimalSeparator),
       amountMode = Value(amountMode),
       mapping = Value(mapping),
       debitIndicators = Value(debitIndicators);
  static Insertable<ImportProfileRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? fileType,
    Expression<String>? delimiter,
    Expression<String>? encoding,
    Expression<int>? headerRow,
    Expression<String>? dateFormat,
    Expression<String>? decimalSeparator,
    Expression<String>? amountMode,
    Expression<String>? mapping,
    Expression<bool>? invertSign,
    Expression<String>? debitIndicators,
    Expression<String>? jsonRootPath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (fileType != null) 'file_type': fileType,
      if (delimiter != null) 'delimiter': delimiter,
      if (encoding != null) 'encoding': encoding,
      if (headerRow != null) 'header_row': headerRow,
      if (dateFormat != null) 'date_format': dateFormat,
      if (decimalSeparator != null) 'decimal_separator': decimalSeparator,
      if (amountMode != null) 'amount_mode': amountMode,
      if (mapping != null) 'mapping': mapping,
      if (invertSign != null) 'invert_sign': invertSign,
      if (debitIndicators != null) 'debit_indicators': debitIndicators,
      if (jsonRootPath != null) 'json_root_path': jsonRootPath,
    });
  }

  ImportProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<ImportFileType>? fileType,
    Value<String>? delimiter,
    Value<TextEncoding>? encoding,
    Value<int>? headerRow,
    Value<String>? dateFormat,
    Value<String>? decimalSeparator,
    Value<AmountMode>? amountMode,
    Value<Map<ImportField, String>>? mapping,
    Value<bool>? invertSign,
    Value<String>? debitIndicators,
    Value<String>? jsonRootPath,
  }) {
    return ImportProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      fileType: fileType ?? this.fileType,
      delimiter: delimiter ?? this.delimiter,
      encoding: encoding ?? this.encoding,
      headerRow: headerRow ?? this.headerRow,
      dateFormat: dateFormat ?? this.dateFormat,
      decimalSeparator: decimalSeparator ?? this.decimalSeparator,
      amountMode: amountMode ?? this.amountMode,
      mapping: mapping ?? this.mapping,
      invertSign: invertSign ?? this.invertSign,
      debitIndicators: debitIndicators ?? this.debitIndicators,
      jsonRootPath: jsonRootPath ?? this.jsonRootPath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (fileType.present) {
      map['file_type'] = Variable<String>(
        $ImportProfilesTable.$converterfileType.toSql(fileType.value),
      );
    }
    if (delimiter.present) {
      map['delimiter'] = Variable<String>(delimiter.value);
    }
    if (encoding.present) {
      map['encoding'] = Variable<String>(
        $ImportProfilesTable.$converterencoding.toSql(encoding.value),
      );
    }
    if (headerRow.present) {
      map['header_row'] = Variable<int>(headerRow.value);
    }
    if (dateFormat.present) {
      map['date_format'] = Variable<String>(dateFormat.value);
    }
    if (decimalSeparator.present) {
      map['decimal_separator'] = Variable<String>(decimalSeparator.value);
    }
    if (amountMode.present) {
      map['amount_mode'] = Variable<String>(
        $ImportProfilesTable.$converteramountMode.toSql(amountMode.value),
      );
    }
    if (mapping.present) {
      map['mapping'] = Variable<String>(
        $ImportProfilesTable.$convertermapping.toSql(mapping.value),
      );
    }
    if (invertSign.present) {
      map['invert_sign'] = Variable<bool>(invertSign.value);
    }
    if (debitIndicators.present) {
      map['debit_indicators'] = Variable<String>(debitIndicators.value);
    }
    if (jsonRootPath.present) {
      map['json_root_path'] = Variable<String>(jsonRootPath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImportProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('fileType: $fileType, ')
          ..write('delimiter: $delimiter, ')
          ..write('encoding: $encoding, ')
          ..write('headerRow: $headerRow, ')
          ..write('dateFormat: $dateFormat, ')
          ..write('decimalSeparator: $decimalSeparator, ')
          ..write('amountMode: $amountMode, ')
          ..write('mapping: $mapping, ')
          ..write('invertSign: $invertSign, ')
          ..write('debitIndicators: $debitIndicators, ')
          ..write('jsonRootPath: $jsonRootPath')
          ..write(')'))
        .toString();
  }
}

class $ImportBatchesTable extends ImportBatches
    with TableInfo<$ImportBatchesTable, ImportBatchRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImportBatchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES import_profiles (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _importedAtMeta = const VerificationMeta(
    'importedAt',
  );
  @override
  late final GeneratedColumn<DateTime> importedAt = GeneratedColumn<DateTime>(
    'imported_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _importedCountMeta = const VerificationMeta(
    'importedCount',
  );
  @override
  late final GeneratedColumn<int> importedCount = GeneratedColumn<int>(
    'imported_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _duplicateCountMeta = const VerificationMeta(
    'duplicateCount',
  );
  @override
  late final GeneratedColumn<int> duplicateCount = GeneratedColumn<int>(
    'duplicate_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    profileId,
    fileName,
    importedAt,
    importedCount,
    duplicateCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'import_batches';
  @override
  VerificationContext validateIntegrity(
    Insertable<ImportBatchRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('imported_at')) {
      context.handle(
        _importedAtMeta,
        importedAt.isAcceptableOrUnknown(data['imported_at']!, _importedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_importedAtMeta);
    }
    if (data.containsKey('imported_count')) {
      context.handle(
        _importedCountMeta,
        importedCount.isAcceptableOrUnknown(
          data['imported_count']!,
          _importedCountMeta,
        ),
      );
    }
    if (data.containsKey('duplicate_count')) {
      context.handle(
        _duplicateCountMeta,
        duplicateCount.isAcceptableOrUnknown(
          data['duplicate_count']!,
          _duplicateCountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ImportBatchRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImportBatchRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      ),
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      importedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}imported_at'],
      )!,
      importedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}imported_count'],
      )!,
      duplicateCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duplicate_count'],
      )!,
    );
  }

  @override
  $ImportBatchesTable createAlias(String alias) {
    return $ImportBatchesTable(attachedDatabase, alias);
  }
}

class ImportBatchRow extends DataClass implements Insertable<ImportBatchRow> {
  final int id;
  final int accountId;
  final int? profileId;
  final String fileName;
  final DateTime importedAt;
  final int importedCount;
  final int duplicateCount;
  const ImportBatchRow({
    required this.id,
    required this.accountId,
    this.profileId,
    required this.fileName,
    required this.importedAt,
    required this.importedCount,
    required this.duplicateCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    if (!nullToAbsent || profileId != null) {
      map['profile_id'] = Variable<int>(profileId);
    }
    map['file_name'] = Variable<String>(fileName);
    map['imported_at'] = Variable<DateTime>(importedAt);
    map['imported_count'] = Variable<int>(importedCount);
    map['duplicate_count'] = Variable<int>(duplicateCount);
    return map;
  }

  ImportBatchesCompanion toCompanion(bool nullToAbsent) {
    return ImportBatchesCompanion(
      id: Value(id),
      accountId: Value(accountId),
      profileId: profileId == null && nullToAbsent
          ? const Value.absent()
          : Value(profileId),
      fileName: Value(fileName),
      importedAt: Value(importedAt),
      importedCount: Value(importedCount),
      duplicateCount: Value(duplicateCount),
    );
  }

  factory ImportBatchRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImportBatchRow(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['accountId']),
      profileId: serializer.fromJson<int?>(json['profileId']),
      fileName: serializer.fromJson<String>(json['fileName']),
      importedAt: serializer.fromJson<DateTime>(json['importedAt']),
      importedCount: serializer.fromJson<int>(json['importedCount']),
      duplicateCount: serializer.fromJson<int>(json['duplicateCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<int>(accountId),
      'profileId': serializer.toJson<int?>(profileId),
      'fileName': serializer.toJson<String>(fileName),
      'importedAt': serializer.toJson<DateTime>(importedAt),
      'importedCount': serializer.toJson<int>(importedCount),
      'duplicateCount': serializer.toJson<int>(duplicateCount),
    };
  }

  ImportBatchRow copyWith({
    int? id,
    int? accountId,
    Value<int?> profileId = const Value.absent(),
    String? fileName,
    DateTime? importedAt,
    int? importedCount,
    int? duplicateCount,
  }) => ImportBatchRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    profileId: profileId.present ? profileId.value : this.profileId,
    fileName: fileName ?? this.fileName,
    importedAt: importedAt ?? this.importedAt,
    importedCount: importedCount ?? this.importedCount,
    duplicateCount: duplicateCount ?? this.duplicateCount,
  );
  ImportBatchRow copyWithCompanion(ImportBatchesCompanion data) {
    return ImportBatchRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      importedAt: data.importedAt.present
          ? data.importedAt.value
          : this.importedAt,
      importedCount: data.importedCount.present
          ? data.importedCount.value
          : this.importedCount,
      duplicateCount: data.duplicateCount.present
          ? data.duplicateCount.value
          : this.duplicateCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImportBatchRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('profileId: $profileId, ')
          ..write('fileName: $fileName, ')
          ..write('importedAt: $importedAt, ')
          ..write('importedCount: $importedCount, ')
          ..write('duplicateCount: $duplicateCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    profileId,
    fileName,
    importedAt,
    importedCount,
    duplicateCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImportBatchRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.profileId == this.profileId &&
          other.fileName == this.fileName &&
          other.importedAt == this.importedAt &&
          other.importedCount == this.importedCount &&
          other.duplicateCount == this.duplicateCount);
}

class ImportBatchesCompanion extends UpdateCompanion<ImportBatchRow> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<int?> profileId;
  final Value<String> fileName;
  final Value<DateTime> importedAt;
  final Value<int> importedCount;
  final Value<int> duplicateCount;
  const ImportBatchesCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.fileName = const Value.absent(),
    this.importedAt = const Value.absent(),
    this.importedCount = const Value.absent(),
    this.duplicateCount = const Value.absent(),
  });
  ImportBatchesCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    this.profileId = const Value.absent(),
    required String fileName,
    required DateTime importedAt,
    this.importedCount = const Value.absent(),
    this.duplicateCount = const Value.absent(),
  }) : accountId = Value(accountId),
       fileName = Value(fileName),
       importedAt = Value(importedAt);
  static Insertable<ImportBatchRow> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<int>? profileId,
    Expression<String>? fileName,
    Expression<DateTime>? importedAt,
    Expression<int>? importedCount,
    Expression<int>? duplicateCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (profileId != null) 'profile_id': profileId,
      if (fileName != null) 'file_name': fileName,
      if (importedAt != null) 'imported_at': importedAt,
      if (importedCount != null) 'imported_count': importedCount,
      if (duplicateCount != null) 'duplicate_count': duplicateCount,
    });
  }

  ImportBatchesCompanion copyWith({
    Value<int>? id,
    Value<int>? accountId,
    Value<int?>? profileId,
    Value<String>? fileName,
    Value<DateTime>? importedAt,
    Value<int>? importedCount,
    Value<int>? duplicateCount,
  }) {
    return ImportBatchesCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      profileId: profileId ?? this.profileId,
      fileName: fileName ?? this.fileName,
      importedAt: importedAt ?? this.importedAt,
      importedCount: importedCount ?? this.importedCount,
      duplicateCount: duplicateCount ?? this.duplicateCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (importedAt.present) {
      map['imported_at'] = Variable<DateTime>(importedAt.value);
    }
    if (importedCount.present) {
      map['imported_count'] = Variable<int>(importedCount.value);
    }
    if (duplicateCount.present) {
      map['duplicate_count'] = Variable<int>(duplicateCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImportBatchesCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('profileId: $profileId, ')
          ..write('fileName: $fileName, ')
          ..write('importedAt: $importedAt, ')
          ..write('importedCount: $importedCount, ')
          ..write('duplicateCount: $duplicateCount')
          ..write(')'))
        .toString();
  }
}

class $CategoryRulesTable extends CategoryRules
    with TableInfo<$CategoryRulesTable, CategoryRuleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _matchAllMeta = const VerificationMeta(
    'matchAll',
  );
  @override
  late final GeneratedColumn<bool> matchAll = GeneratedColumn<bool>(
    'match_all',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("match_all" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<RuleCondition>, String>
  conditions =
      GeneratedColumn<String>(
        'conditions',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<RuleCondition>>(
        $CategoryRulesTable.$converterconditions,
      );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    categoryId,
    priority,
    matchAll,
    conditions,
    isEnabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryRuleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('match_all')) {
      context.handle(
        _matchAllMeta,
        matchAll.isAcceptableOrUnknown(data['match_all']!, _matchAllMeta),
      );
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryRuleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRuleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      matchAll: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}match_all'],
      )!,
      conditions: $CategoryRulesTable.$converterconditions.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}conditions'],
        )!,
      ),
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
    );
  }

  @override
  $CategoryRulesTable createAlias(String alias) {
    return $CategoryRulesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<RuleCondition>, String> $converterconditions =
      const RuleConditionsConverter();
}

class CategoryRuleRow extends DataClass implements Insertable<CategoryRuleRow> {
  final int id;
  final String name;
  final int categoryId;
  final int priority;
  final bool matchAll;
  final List<RuleCondition> conditions;
  final bool isEnabled;
  const CategoryRuleRow({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.priority,
    required this.matchAll,
    required this.conditions,
    required this.isEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['category_id'] = Variable<int>(categoryId);
    map['priority'] = Variable<int>(priority);
    map['match_all'] = Variable<bool>(matchAll);
    {
      map['conditions'] = Variable<String>(
        $CategoryRulesTable.$converterconditions.toSql(conditions),
      );
    }
    map['is_enabled'] = Variable<bool>(isEnabled);
    return map;
  }

  CategoryRulesCompanion toCompanion(bool nullToAbsent) {
    return CategoryRulesCompanion(
      id: Value(id),
      name: Value(name),
      categoryId: Value(categoryId),
      priority: Value(priority),
      matchAll: Value(matchAll),
      conditions: Value(conditions),
      isEnabled: Value(isEnabled),
    );
  }

  factory CategoryRuleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRuleRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      priority: serializer.fromJson<int>(json['priority']),
      matchAll: serializer.fromJson<bool>(json['matchAll']),
      conditions: serializer.fromJson<List<RuleCondition>>(json['conditions']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'categoryId': serializer.toJson<int>(categoryId),
      'priority': serializer.toJson<int>(priority),
      'matchAll': serializer.toJson<bool>(matchAll),
      'conditions': serializer.toJson<List<RuleCondition>>(conditions),
      'isEnabled': serializer.toJson<bool>(isEnabled),
    };
  }

  CategoryRuleRow copyWith({
    int? id,
    String? name,
    int? categoryId,
    int? priority,
    bool? matchAll,
    List<RuleCondition>? conditions,
    bool? isEnabled,
  }) => CategoryRuleRow(
    id: id ?? this.id,
    name: name ?? this.name,
    categoryId: categoryId ?? this.categoryId,
    priority: priority ?? this.priority,
    matchAll: matchAll ?? this.matchAll,
    conditions: conditions ?? this.conditions,
    isEnabled: isEnabled ?? this.isEnabled,
  );
  CategoryRuleRow copyWithCompanion(CategoryRulesCompanion data) {
    return CategoryRuleRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      priority: data.priority.present ? data.priority.value : this.priority,
      matchAll: data.matchAll.present ? data.matchAll.value : this.matchAll,
      conditions: data.conditions.present
          ? data.conditions.value
          : this.conditions,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRuleRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('priority: $priority, ')
          ..write('matchAll: $matchAll, ')
          ..write('conditions: $conditions, ')
          ..write('isEnabled: $isEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    categoryId,
    priority,
    matchAll,
    conditions,
    isEnabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRuleRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.categoryId == this.categoryId &&
          other.priority == this.priority &&
          other.matchAll == this.matchAll &&
          other.conditions == this.conditions &&
          other.isEnabled == this.isEnabled);
}

class CategoryRulesCompanion extends UpdateCompanion<CategoryRuleRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> categoryId;
  final Value<int> priority;
  final Value<bool> matchAll;
  final Value<List<RuleCondition>> conditions;
  final Value<bool> isEnabled;
  const CategoryRulesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.priority = const Value.absent(),
    this.matchAll = const Value.absent(),
    this.conditions = const Value.absent(),
    this.isEnabled = const Value.absent(),
  });
  CategoryRulesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int categoryId,
    this.priority = const Value.absent(),
    this.matchAll = const Value.absent(),
    required List<RuleCondition> conditions,
    this.isEnabled = const Value.absent(),
  }) : name = Value(name),
       categoryId = Value(categoryId),
       conditions = Value(conditions);
  static Insertable<CategoryRuleRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? categoryId,
    Expression<int>? priority,
    Expression<bool>? matchAll,
    Expression<String>? conditions,
    Expression<bool>? isEnabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (categoryId != null) 'category_id': categoryId,
      if (priority != null) 'priority': priority,
      if (matchAll != null) 'match_all': matchAll,
      if (conditions != null) 'conditions': conditions,
      if (isEnabled != null) 'is_enabled': isEnabled,
    });
  }

  CategoryRulesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? categoryId,
    Value<int>? priority,
    Value<bool>? matchAll,
    Value<List<RuleCondition>>? conditions,
    Value<bool>? isEnabled,
  }) {
    return CategoryRulesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      priority: priority ?? this.priority,
      matchAll: matchAll ?? this.matchAll,
      conditions: conditions ?? this.conditions,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (matchAll.present) {
      map['match_all'] = Variable<bool>(matchAll.value);
    }
    if (conditions.present) {
      map['conditions'] = Variable<String>(
        $CategoryRulesTable.$converterconditions.toSql(conditions.value),
      );
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRulesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('priority: $priority, ')
          ..write('matchAll: $matchAll, ')
          ..write('conditions: $conditions, ')
          ..write('isEnabled: $isEnabled')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, TransactionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> bookingDate =
      GeneratedColumn<int>(
        'booking_date',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($TransactionsTable.$converterbookingDate);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> valueDate =
      GeneratedColumn<int>(
        'value_date',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($TransactionsTable.$convertervalueDaten);
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _counterpartyMeta = const VerificationMeta(
    'counterparty',
  );
  @override
  late final GeneratedColumn<String> counterparty = GeneratedColumn<String>(
    'counterparty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _purposeMeta = const VerificationMeta(
    'purpose',
  );
  @override
  late final GeneratedColumn<String> purpose = GeneratedColumn<String>(
    'purpose',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _counterpartyIbanMeta = const VerificationMeta(
    'counterpartyIban',
  );
  @override
  late final GeneratedColumn<String> counterpartyIban = GeneratedColumn<String>(
    'counterparty_iban',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE SET NULL',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<CategorySource, String>
  categorySource = GeneratedColumn<String>(
    'category_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<CategorySource>($TransactionsTable.$convertercategorySource);
  static const VerificationMeta _ruleIdMeta = const VerificationMeta('ruleId');
  @override
  late final GeneratedColumn<int> ruleId = GeneratedColumn<int>(
    'rule_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES category_rules (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _trainedCategoryIdMeta = const VerificationMeta(
    'trainedCategoryId',
  );
  @override
  late final GeneratedColumn<int> trainedCategoryId = GeneratedColumn<int>(
    'trained_category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _importBatchIdMeta = const VerificationMeta(
    'importBatchId',
  );
  @override
  late final GeneratedColumn<int> importBatchId = GeneratedColumn<int>(
    'import_batch_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES import_batches (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _dedupHashMeta = const VerificationMeta(
    'dedupHash',
  );
  @override
  late final GeneratedColumn<String> dedupHash = GeneratedColumn<String>(
    'dedup_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    bookingDate,
    valueDate,
    amountMinor,
    counterparty,
    purpose,
    counterpartyIban,
    categoryId,
    categorySource,
    ruleId,
    trainedCategoryId,
    note,
    importBatchId,
    dedupHash,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('counterparty')) {
      context.handle(
        _counterpartyMeta,
        counterparty.isAcceptableOrUnknown(
          data['counterparty']!,
          _counterpartyMeta,
        ),
      );
    }
    if (data.containsKey('purpose')) {
      context.handle(
        _purposeMeta,
        purpose.isAcceptableOrUnknown(data['purpose']!, _purposeMeta),
      );
    }
    if (data.containsKey('counterparty_iban')) {
      context.handle(
        _counterpartyIbanMeta,
        counterpartyIban.isAcceptableOrUnknown(
          data['counterparty_iban']!,
          _counterpartyIbanMeta,
        ),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('rule_id')) {
      context.handle(
        _ruleIdMeta,
        ruleId.isAcceptableOrUnknown(data['rule_id']!, _ruleIdMeta),
      );
    }
    if (data.containsKey('trained_category_id')) {
      context.handle(
        _trainedCategoryIdMeta,
        trainedCategoryId.isAcceptableOrUnknown(
          data['trained_category_id']!,
          _trainedCategoryIdMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('import_batch_id')) {
      context.handle(
        _importBatchIdMeta,
        importBatchId.isAcceptableOrUnknown(
          data['import_batch_id']!,
          _importBatchIdMeta,
        ),
      );
    }
    if (data.containsKey('dedup_hash')) {
      context.handle(
        _dedupHashMeta,
        dedupHash.isAcceptableOrUnknown(data['dedup_hash']!, _dedupHashMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      bookingDate: $TransactionsTable.$converterbookingDate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}booking_date'],
        )!,
      ),
      valueDate: $TransactionsTable.$convertervalueDaten.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}value_date'],
        ),
      ),
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      counterparty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}counterparty'],
      )!,
      purpose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purpose'],
      )!,
      counterpartyIban: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}counterparty_iban'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      categorySource: $TransactionsTable.$convertercategorySource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category_source'],
        )!,
      ),
      ruleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rule_id'],
      ),
      trainedCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trained_category_id'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      importBatchId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}import_batch_id'],
      ),
      dedupHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dedup_hash'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $converterbookingDate =
      const DateOnlyConverter();
  static TypeConverter<DateTime, int> $convertervalueDate =
      const DateOnlyConverter();
  static TypeConverter<DateTime?, int?> $convertervalueDaten =
      NullAwareTypeConverter.wrap($convertervalueDate);
  static JsonTypeConverter2<CategorySource, String, String>
  $convertercategorySource = const EnumNameConverter<CategorySource>(
    CategorySource.values,
  );
}

class TransactionRow extends DataClass implements Insertable<TransactionRow> {
  final int id;
  final int accountId;
  final DateTime bookingDate;
  final DateTime? valueDate;
  final int amountMinor;
  final String counterparty;
  final String purpose;
  final String? counterpartyIban;
  final int? categoryId;
  final CategorySource categorySource;
  final int? ruleId;
  final int? trainedCategoryId;
  final String note;
  final int? importBatchId;
  final String? dedupHash;
  final DateTime createdAt;
  const TransactionRow({
    required this.id,
    required this.accountId,
    required this.bookingDate,
    this.valueDate,
    required this.amountMinor,
    required this.counterparty,
    required this.purpose,
    this.counterpartyIban,
    this.categoryId,
    required this.categorySource,
    this.ruleId,
    this.trainedCategoryId,
    required this.note,
    this.importBatchId,
    this.dedupHash,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    {
      map['booking_date'] = Variable<int>(
        $TransactionsTable.$converterbookingDate.toSql(bookingDate),
      );
    }
    if (!nullToAbsent || valueDate != null) {
      map['value_date'] = Variable<int>(
        $TransactionsTable.$convertervalueDaten.toSql(valueDate),
      );
    }
    map['amount_minor'] = Variable<int>(amountMinor);
    map['counterparty'] = Variable<String>(counterparty);
    map['purpose'] = Variable<String>(purpose);
    if (!nullToAbsent || counterpartyIban != null) {
      map['counterparty_iban'] = Variable<String>(counterpartyIban);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    {
      map['category_source'] = Variable<String>(
        $TransactionsTable.$convertercategorySource.toSql(categorySource),
      );
    }
    if (!nullToAbsent || ruleId != null) {
      map['rule_id'] = Variable<int>(ruleId);
    }
    if (!nullToAbsent || trainedCategoryId != null) {
      map['trained_category_id'] = Variable<int>(trainedCategoryId);
    }
    map['note'] = Variable<String>(note);
    if (!nullToAbsent || importBatchId != null) {
      map['import_batch_id'] = Variable<int>(importBatchId);
    }
    if (!nullToAbsent || dedupHash != null) {
      map['dedup_hash'] = Variable<String>(dedupHash);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      bookingDate: Value(bookingDate),
      valueDate: valueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(valueDate),
      amountMinor: Value(amountMinor),
      counterparty: Value(counterparty),
      purpose: Value(purpose),
      counterpartyIban: counterpartyIban == null && nullToAbsent
          ? const Value.absent()
          : Value(counterpartyIban),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      categorySource: Value(categorySource),
      ruleId: ruleId == null && nullToAbsent
          ? const Value.absent()
          : Value(ruleId),
      trainedCategoryId: trainedCategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(trainedCategoryId),
      note: Value(note),
      importBatchId: importBatchId == null && nullToAbsent
          ? const Value.absent()
          : Value(importBatchId),
      dedupHash: dedupHash == null && nullToAbsent
          ? const Value.absent()
          : Value(dedupHash),
      createdAt: Value(createdAt),
    );
  }

  factory TransactionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionRow(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['accountId']),
      bookingDate: serializer.fromJson<DateTime>(json['bookingDate']),
      valueDate: serializer.fromJson<DateTime?>(json['valueDate']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      counterparty: serializer.fromJson<String>(json['counterparty']),
      purpose: serializer.fromJson<String>(json['purpose']),
      counterpartyIban: serializer.fromJson<String?>(json['counterpartyIban']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      categorySource: $TransactionsTable.$convertercategorySource.fromJson(
        serializer.fromJson<String>(json['categorySource']),
      ),
      ruleId: serializer.fromJson<int?>(json['ruleId']),
      trainedCategoryId: serializer.fromJson<int?>(json['trainedCategoryId']),
      note: serializer.fromJson<String>(json['note']),
      importBatchId: serializer.fromJson<int?>(json['importBatchId']),
      dedupHash: serializer.fromJson<String?>(json['dedupHash']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<int>(accountId),
      'bookingDate': serializer.toJson<DateTime>(bookingDate),
      'valueDate': serializer.toJson<DateTime?>(valueDate),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'counterparty': serializer.toJson<String>(counterparty),
      'purpose': serializer.toJson<String>(purpose),
      'counterpartyIban': serializer.toJson<String?>(counterpartyIban),
      'categoryId': serializer.toJson<int?>(categoryId),
      'categorySource': serializer.toJson<String>(
        $TransactionsTable.$convertercategorySource.toJson(categorySource),
      ),
      'ruleId': serializer.toJson<int?>(ruleId),
      'trainedCategoryId': serializer.toJson<int?>(trainedCategoryId),
      'note': serializer.toJson<String>(note),
      'importBatchId': serializer.toJson<int?>(importBatchId),
      'dedupHash': serializer.toJson<String?>(dedupHash),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TransactionRow copyWith({
    int? id,
    int? accountId,
    DateTime? bookingDate,
    Value<DateTime?> valueDate = const Value.absent(),
    int? amountMinor,
    String? counterparty,
    String? purpose,
    Value<String?> counterpartyIban = const Value.absent(),
    Value<int?> categoryId = const Value.absent(),
    CategorySource? categorySource,
    Value<int?> ruleId = const Value.absent(),
    Value<int?> trainedCategoryId = const Value.absent(),
    String? note,
    Value<int?> importBatchId = const Value.absent(),
    Value<String?> dedupHash = const Value.absent(),
    DateTime? createdAt,
  }) => TransactionRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    bookingDate: bookingDate ?? this.bookingDate,
    valueDate: valueDate.present ? valueDate.value : this.valueDate,
    amountMinor: amountMinor ?? this.amountMinor,
    counterparty: counterparty ?? this.counterparty,
    purpose: purpose ?? this.purpose,
    counterpartyIban: counterpartyIban.present
        ? counterpartyIban.value
        : this.counterpartyIban,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    categorySource: categorySource ?? this.categorySource,
    ruleId: ruleId.present ? ruleId.value : this.ruleId,
    trainedCategoryId: trainedCategoryId.present
        ? trainedCategoryId.value
        : this.trainedCategoryId,
    note: note ?? this.note,
    importBatchId: importBatchId.present
        ? importBatchId.value
        : this.importBatchId,
    dedupHash: dedupHash.present ? dedupHash.value : this.dedupHash,
    createdAt: createdAt ?? this.createdAt,
  );
  TransactionRow copyWithCompanion(TransactionsCompanion data) {
    return TransactionRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      bookingDate: data.bookingDate.present
          ? data.bookingDate.value
          : this.bookingDate,
      valueDate: data.valueDate.present ? data.valueDate.value : this.valueDate,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      counterparty: data.counterparty.present
          ? data.counterparty.value
          : this.counterparty,
      purpose: data.purpose.present ? data.purpose.value : this.purpose,
      counterpartyIban: data.counterpartyIban.present
          ? data.counterpartyIban.value
          : this.counterpartyIban,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      categorySource: data.categorySource.present
          ? data.categorySource.value
          : this.categorySource,
      ruleId: data.ruleId.present ? data.ruleId.value : this.ruleId,
      trainedCategoryId: data.trainedCategoryId.present
          ? data.trainedCategoryId.value
          : this.trainedCategoryId,
      note: data.note.present ? data.note.value : this.note,
      importBatchId: data.importBatchId.present
          ? data.importBatchId.value
          : this.importBatchId,
      dedupHash: data.dedupHash.present ? data.dedupHash.value : this.dedupHash,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('bookingDate: $bookingDate, ')
          ..write('valueDate: $valueDate, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('counterparty: $counterparty, ')
          ..write('purpose: $purpose, ')
          ..write('counterpartyIban: $counterpartyIban, ')
          ..write('categoryId: $categoryId, ')
          ..write('categorySource: $categorySource, ')
          ..write('ruleId: $ruleId, ')
          ..write('trainedCategoryId: $trainedCategoryId, ')
          ..write('note: $note, ')
          ..write('importBatchId: $importBatchId, ')
          ..write('dedupHash: $dedupHash, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    bookingDate,
    valueDate,
    amountMinor,
    counterparty,
    purpose,
    counterpartyIban,
    categoryId,
    categorySource,
    ruleId,
    trainedCategoryId,
    note,
    importBatchId,
    dedupHash,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.bookingDate == this.bookingDate &&
          other.valueDate == this.valueDate &&
          other.amountMinor == this.amountMinor &&
          other.counterparty == this.counterparty &&
          other.purpose == this.purpose &&
          other.counterpartyIban == this.counterpartyIban &&
          other.categoryId == this.categoryId &&
          other.categorySource == this.categorySource &&
          other.ruleId == this.ruleId &&
          other.trainedCategoryId == this.trainedCategoryId &&
          other.note == this.note &&
          other.importBatchId == this.importBatchId &&
          other.dedupHash == this.dedupHash &&
          other.createdAt == this.createdAt);
}

class TransactionsCompanion extends UpdateCompanion<TransactionRow> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<DateTime> bookingDate;
  final Value<DateTime?> valueDate;
  final Value<int> amountMinor;
  final Value<String> counterparty;
  final Value<String> purpose;
  final Value<String?> counterpartyIban;
  final Value<int?> categoryId;
  final Value<CategorySource> categorySource;
  final Value<int?> ruleId;
  final Value<int?> trainedCategoryId;
  final Value<String> note;
  final Value<int?> importBatchId;
  final Value<String?> dedupHash;
  final Value<DateTime> createdAt;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.bookingDate = const Value.absent(),
    this.valueDate = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.counterparty = const Value.absent(),
    this.purpose = const Value.absent(),
    this.counterpartyIban = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.categorySource = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.trainedCategoryId = const Value.absent(),
    this.note = const Value.absent(),
    this.importBatchId = const Value.absent(),
    this.dedupHash = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    required DateTime bookingDate,
    this.valueDate = const Value.absent(),
    required int amountMinor,
    this.counterparty = const Value.absent(),
    this.purpose = const Value.absent(),
    this.counterpartyIban = const Value.absent(),
    this.categoryId = const Value.absent(),
    required CategorySource categorySource,
    this.ruleId = const Value.absent(),
    this.trainedCategoryId = const Value.absent(),
    this.note = const Value.absent(),
    this.importBatchId = const Value.absent(),
    this.dedupHash = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : accountId = Value(accountId),
       bookingDate = Value(bookingDate),
       amountMinor = Value(amountMinor),
       categorySource = Value(categorySource);
  static Insertable<TransactionRow> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<int>? bookingDate,
    Expression<int>? valueDate,
    Expression<int>? amountMinor,
    Expression<String>? counterparty,
    Expression<String>? purpose,
    Expression<String>? counterpartyIban,
    Expression<int>? categoryId,
    Expression<String>? categorySource,
    Expression<int>? ruleId,
    Expression<int>? trainedCategoryId,
    Expression<String>? note,
    Expression<int>? importBatchId,
    Expression<String>? dedupHash,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (bookingDate != null) 'booking_date': bookingDate,
      if (valueDate != null) 'value_date': valueDate,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (counterparty != null) 'counterparty': counterparty,
      if (purpose != null) 'purpose': purpose,
      if (counterpartyIban != null) 'counterparty_iban': counterpartyIban,
      if (categoryId != null) 'category_id': categoryId,
      if (categorySource != null) 'category_source': categorySource,
      if (ruleId != null) 'rule_id': ruleId,
      if (trainedCategoryId != null) 'trained_category_id': trainedCategoryId,
      if (note != null) 'note': note,
      if (importBatchId != null) 'import_batch_id': importBatchId,
      if (dedupHash != null) 'dedup_hash': dedupHash,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TransactionsCompanion copyWith({
    Value<int>? id,
    Value<int>? accountId,
    Value<DateTime>? bookingDate,
    Value<DateTime?>? valueDate,
    Value<int>? amountMinor,
    Value<String>? counterparty,
    Value<String>? purpose,
    Value<String?>? counterpartyIban,
    Value<int?>? categoryId,
    Value<CategorySource>? categorySource,
    Value<int?>? ruleId,
    Value<int?>? trainedCategoryId,
    Value<String>? note,
    Value<int?>? importBatchId,
    Value<String?>? dedupHash,
    Value<DateTime>? createdAt,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      bookingDate: bookingDate ?? this.bookingDate,
      valueDate: valueDate ?? this.valueDate,
      amountMinor: amountMinor ?? this.amountMinor,
      counterparty: counterparty ?? this.counterparty,
      purpose: purpose ?? this.purpose,
      counterpartyIban: counterpartyIban ?? this.counterpartyIban,
      categoryId: categoryId ?? this.categoryId,
      categorySource: categorySource ?? this.categorySource,
      ruleId: ruleId ?? this.ruleId,
      trainedCategoryId: trainedCategoryId ?? this.trainedCategoryId,
      note: note ?? this.note,
      importBatchId: importBatchId ?? this.importBatchId,
      dedupHash: dedupHash ?? this.dedupHash,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (bookingDate.present) {
      map['booking_date'] = Variable<int>(
        $TransactionsTable.$converterbookingDate.toSql(bookingDate.value),
      );
    }
    if (valueDate.present) {
      map['value_date'] = Variable<int>(
        $TransactionsTable.$convertervalueDaten.toSql(valueDate.value),
      );
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (counterparty.present) {
      map['counterparty'] = Variable<String>(counterparty.value);
    }
    if (purpose.present) {
      map['purpose'] = Variable<String>(purpose.value);
    }
    if (counterpartyIban.present) {
      map['counterparty_iban'] = Variable<String>(counterpartyIban.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (categorySource.present) {
      map['category_source'] = Variable<String>(
        $TransactionsTable.$convertercategorySource.toSql(categorySource.value),
      );
    }
    if (ruleId.present) {
      map['rule_id'] = Variable<int>(ruleId.value);
    }
    if (trainedCategoryId.present) {
      map['trained_category_id'] = Variable<int>(trainedCategoryId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (importBatchId.present) {
      map['import_batch_id'] = Variable<int>(importBatchId.value);
    }
    if (dedupHash.present) {
      map['dedup_hash'] = Variable<String>(dedupHash.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('bookingDate: $bookingDate, ')
          ..write('valueDate: $valueDate, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('counterparty: $counterparty, ')
          ..write('purpose: $purpose, ')
          ..write('counterpartyIban: $counterpartyIban, ')
          ..write('categoryId: $categoryId, ')
          ..write('categorySource: $categorySource, ')
          ..write('ruleId: $ruleId, ')
          ..write('trainedCategoryId: $trainedCategoryId, ')
          ..write('note: $note, ')
          ..write('importBatchId: $importBatchId, ')
          ..write('dedupHash: $dedupHash, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ClassifierTokensTable extends ClassifierTokens
    with TableInfo<$ClassifierTokensTable, ClassifierTokenRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClassifierTokensTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tokenMeta = const VerificationMeta('token');
  @override
  late final GeneratedColumn<String> token = GeneratedColumn<String>(
    'token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
    'count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [token, categoryId, count];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'classifier_tokens';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClassifierTokenRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('token')) {
      context.handle(
        _tokenMeta,
        token.isAcceptableOrUnknown(data['token']!, _tokenMeta),
      );
    } else if (isInserting) {
      context.missing(_tokenMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
        _countMeta,
        count.isAcceptableOrUnknown(data['count']!, _countMeta),
      );
    } else if (isInserting) {
      context.missing(_countMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {token, categoryId};
  @override
  ClassifierTokenRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClassifierTokenRow(
      token: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}token'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      count: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}count'],
      )!,
    );
  }

  @override
  $ClassifierTokensTable createAlias(String alias) {
    return $ClassifierTokensTable(attachedDatabase, alias);
  }
}

class ClassifierTokenRow extends DataClass
    implements Insertable<ClassifierTokenRow> {
  final String token;
  final int categoryId;
  final int count;
  const ClassifierTokenRow({
    required this.token,
    required this.categoryId,
    required this.count,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['token'] = Variable<String>(token);
    map['category_id'] = Variable<int>(categoryId);
    map['count'] = Variable<int>(count);
    return map;
  }

  ClassifierTokensCompanion toCompanion(bool nullToAbsent) {
    return ClassifierTokensCompanion(
      token: Value(token),
      categoryId: Value(categoryId),
      count: Value(count),
    );
  }

  factory ClassifierTokenRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClassifierTokenRow(
      token: serializer.fromJson<String>(json['token']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      count: serializer.fromJson<int>(json['count']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'token': serializer.toJson<String>(token),
      'categoryId': serializer.toJson<int>(categoryId),
      'count': serializer.toJson<int>(count),
    };
  }

  ClassifierTokenRow copyWith({String? token, int? categoryId, int? count}) =>
      ClassifierTokenRow(
        token: token ?? this.token,
        categoryId: categoryId ?? this.categoryId,
        count: count ?? this.count,
      );
  ClassifierTokenRow copyWithCompanion(ClassifierTokensCompanion data) {
    return ClassifierTokenRow(
      token: data.token.present ? data.token.value : this.token,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      count: data.count.present ? data.count.value : this.count,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClassifierTokenRow(')
          ..write('token: $token, ')
          ..write('categoryId: $categoryId, ')
          ..write('count: $count')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(token, categoryId, count);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClassifierTokenRow &&
          other.token == this.token &&
          other.categoryId == this.categoryId &&
          other.count == this.count);
}

class ClassifierTokensCompanion extends UpdateCompanion<ClassifierTokenRow> {
  final Value<String> token;
  final Value<int> categoryId;
  final Value<int> count;
  final Value<int> rowid;
  const ClassifierTokensCompanion({
    this.token = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.count = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClassifierTokensCompanion.insert({
    required String token,
    required int categoryId,
    required int count,
    this.rowid = const Value.absent(),
  }) : token = Value(token),
       categoryId = Value(categoryId),
       count = Value(count);
  static Insertable<ClassifierTokenRow> custom({
    Expression<String>? token,
    Expression<int>? categoryId,
    Expression<int>? count,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (token != null) 'token': token,
      if (categoryId != null) 'category_id': categoryId,
      if (count != null) 'count': count,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClassifierTokensCompanion copyWith({
    Value<String>? token,
    Value<int>? categoryId,
    Value<int>? count,
    Value<int>? rowid,
  }) {
    return ClassifierTokensCompanion(
      token: token ?? this.token,
      categoryId: categoryId ?? this.categoryId,
      count: count ?? this.count,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClassifierTokensCompanion(')
          ..write('token: $token, ')
          ..write('categoryId: $categoryId, ')
          ..write('count: $count, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ClassifierCategoriesTable extends ClassifierCategories
    with TableInfo<$ClassifierCategoriesTable, ClassifierCategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClassifierCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _documentCountMeta = const VerificationMeta(
    'documentCount',
  );
  @override
  late final GeneratedColumn<int> documentCount = GeneratedColumn<int>(
    'document_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [categoryId, documentCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'classifier_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClassifierCategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('document_count')) {
      context.handle(
        _documentCountMeta,
        documentCount.isAcceptableOrUnknown(
          data['document_count']!,
          _documentCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_documentCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {categoryId};
  @override
  ClassifierCategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClassifierCategoryRow(
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      documentCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}document_count'],
      )!,
    );
  }

  @override
  $ClassifierCategoriesTable createAlias(String alias) {
    return $ClassifierCategoriesTable(attachedDatabase, alias);
  }
}

class ClassifierCategoryRow extends DataClass
    implements Insertable<ClassifierCategoryRow> {
  final int categoryId;
  final int documentCount;
  const ClassifierCategoryRow({
    required this.categoryId,
    required this.documentCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['category_id'] = Variable<int>(categoryId);
    map['document_count'] = Variable<int>(documentCount);
    return map;
  }

  ClassifierCategoriesCompanion toCompanion(bool nullToAbsent) {
    return ClassifierCategoriesCompanion(
      categoryId: Value(categoryId),
      documentCount: Value(documentCount),
    );
  }

  factory ClassifierCategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClassifierCategoryRow(
      categoryId: serializer.fromJson<int>(json['categoryId']),
      documentCount: serializer.fromJson<int>(json['documentCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'categoryId': serializer.toJson<int>(categoryId),
      'documentCount': serializer.toJson<int>(documentCount),
    };
  }

  ClassifierCategoryRow copyWith({int? categoryId, int? documentCount}) =>
      ClassifierCategoryRow(
        categoryId: categoryId ?? this.categoryId,
        documentCount: documentCount ?? this.documentCount,
      );
  ClassifierCategoryRow copyWithCompanion(ClassifierCategoriesCompanion data) {
    return ClassifierCategoryRow(
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      documentCount: data.documentCount.present
          ? data.documentCount.value
          : this.documentCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClassifierCategoryRow(')
          ..write('categoryId: $categoryId, ')
          ..write('documentCount: $documentCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(categoryId, documentCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClassifierCategoryRow &&
          other.categoryId == this.categoryId &&
          other.documentCount == this.documentCount);
}

class ClassifierCategoriesCompanion
    extends UpdateCompanion<ClassifierCategoryRow> {
  final Value<int> categoryId;
  final Value<int> documentCount;
  const ClassifierCategoriesCompanion({
    this.categoryId = const Value.absent(),
    this.documentCount = const Value.absent(),
  });
  ClassifierCategoriesCompanion.insert({
    this.categoryId = const Value.absent(),
    required int documentCount,
  }) : documentCount = Value(documentCount);
  static Insertable<ClassifierCategoryRow> custom({
    Expression<int>? categoryId,
    Expression<int>? documentCount,
  }) {
    return RawValuesInsertable({
      if (categoryId != null) 'category_id': categoryId,
      if (documentCount != null) 'document_count': documentCount,
    });
  }

  ClassifierCategoriesCompanion copyWith({
    Value<int>? categoryId,
    Value<int>? documentCount,
  }) {
    return ClassifierCategoriesCompanion(
      categoryId: categoryId ?? this.categoryId,
      documentCount: documentCount ?? this.documentCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (documentCount.present) {
      map['document_count'] = Variable<int>(documentCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClassifierCategoriesCompanion(')
          ..write('categoryId: $categoryId, ')
          ..write('documentCount: $documentCount')
          ..write(')'))
        .toString();
  }
}

class $PlannedItemsTable extends PlannedItems
    with TableInfo<$PlannedItemsTable, PlannedItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlannedItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PlannedKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PlannedKind>($PlannedItemsTable.$converterkind);
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RecurrenceUnit, String> unit =
      GeneratedColumn<String>(
        'unit',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RecurrenceUnit>($PlannedItemsTable.$converterunit);
  static const VerificationMeta _intervalMeta = const VerificationMeta(
    'interval',
  );
  @override
  late final GeneratedColumn<int> interval = GeneratedColumn<int>(
    'interval',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> startDate =
      GeneratedColumn<int>(
        'start_date',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($PlannedItemsTable.$converterstartDate);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> endDate =
      GeneratedColumn<int>(
        'end_date',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($PlannedItemsTable.$converterendDaten);
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    kind,
    amountMinor,
    unit,
    interval,
    startDate,
    endDate,
    categoryId,
    accountId,
    note,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'planned_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlannedItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('interval')) {
      context.handle(
        _intervalMeta,
        interval.isAcceptableOrUnknown(data['interval']!, _intervalMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlannedItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlannedItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      kind: $PlannedItemsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      unit: $PlannedItemsTable.$converterunit.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}unit'],
        )!,
      ),
      interval: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval'],
      )!,
      startDate: $PlannedItemsTable.$converterstartDate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}start_date'],
        )!,
      ),
      endDate: $PlannedItemsTable.$converterendDaten.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}end_date'],
        ),
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $PlannedItemsTable createAlias(String alias) {
    return $PlannedItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PlannedKind, String, String> $converterkind =
      const EnumNameConverter<PlannedKind>(PlannedKind.values);
  static JsonTypeConverter2<RecurrenceUnit, String, String> $converterunit =
      const EnumNameConverter<RecurrenceUnit>(RecurrenceUnit.values);
  static TypeConverter<DateTime, int> $converterstartDate =
      const DateOnlyConverter();
  static TypeConverter<DateTime, int> $converterendDate =
      const DateOnlyConverter();
  static TypeConverter<DateTime?, int?> $converterendDaten =
      NullAwareTypeConverter.wrap($converterendDate);
}

class PlannedItemRow extends DataClass implements Insertable<PlannedItemRow> {
  final int id;
  final String name;
  final PlannedKind kind;
  final int amountMinor;
  final RecurrenceUnit unit;
  final int interval;
  final DateTime startDate;
  final DateTime? endDate;
  final int? categoryId;
  final int? accountId;
  final String note;
  final bool isActive;
  const PlannedItemRow({
    required this.id,
    required this.name,
    required this.kind,
    required this.amountMinor,
    required this.unit,
    required this.interval,
    required this.startDate,
    this.endDate,
    this.categoryId,
    this.accountId,
    required this.note,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['kind'] = Variable<String>(
        $PlannedItemsTable.$converterkind.toSql(kind),
      );
    }
    map['amount_minor'] = Variable<int>(amountMinor);
    {
      map['unit'] = Variable<String>(
        $PlannedItemsTable.$converterunit.toSql(unit),
      );
    }
    map['interval'] = Variable<int>(interval);
    {
      map['start_date'] = Variable<int>(
        $PlannedItemsTable.$converterstartDate.toSql(startDate),
      );
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<int>(
        $PlannedItemsTable.$converterendDaten.toSql(endDate),
      );
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<int>(accountId);
    }
    map['note'] = Variable<String>(note);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  PlannedItemsCompanion toCompanion(bool nullToAbsent) {
    return PlannedItemsCompanion(
      id: Value(id),
      name: Value(name),
      kind: Value(kind),
      amountMinor: Value(amountMinor),
      unit: Value(unit),
      interval: Value(interval),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      note: Value(note),
      isActive: Value(isActive),
    );
  }

  factory PlannedItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlannedItemRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      kind: $PlannedItemsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      unit: $PlannedItemsTable.$converterunit.fromJson(
        serializer.fromJson<String>(json['unit']),
      ),
      interval: serializer.fromJson<int>(json['interval']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      accountId: serializer.fromJson<int?>(json['accountId']),
      note: serializer.fromJson<String>(json['note']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<String>(
        $PlannedItemsTable.$converterkind.toJson(kind),
      ),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'unit': serializer.toJson<String>(
        $PlannedItemsTable.$converterunit.toJson(unit),
      ),
      'interval': serializer.toJson<int>(interval),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'categoryId': serializer.toJson<int?>(categoryId),
      'accountId': serializer.toJson<int?>(accountId),
      'note': serializer.toJson<String>(note),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  PlannedItemRow copyWith({
    int? id,
    String? name,
    PlannedKind? kind,
    int? amountMinor,
    RecurrenceUnit? unit,
    int? interval,
    DateTime? startDate,
    Value<DateTime?> endDate = const Value.absent(),
    Value<int?> categoryId = const Value.absent(),
    Value<int?> accountId = const Value.absent(),
    String? note,
    bool? isActive,
  }) => PlannedItemRow(
    id: id ?? this.id,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    amountMinor: amountMinor ?? this.amountMinor,
    unit: unit ?? this.unit,
    interval: interval ?? this.interval,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    accountId: accountId.present ? accountId.value : this.accountId,
    note: note ?? this.note,
    isActive: isActive ?? this.isActive,
  );
  PlannedItemRow copyWithCompanion(PlannedItemsCompanion data) {
    return PlannedItemRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      unit: data.unit.present ? data.unit.value : this.unit,
      interval: data.interval.present ? data.interval.value : this.interval,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      note: data.note.present ? data.note.value : this.note,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlannedItemRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('unit: $unit, ')
          ..write('interval: $interval, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('categoryId: $categoryId, ')
          ..write('accountId: $accountId, ')
          ..write('note: $note, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    kind,
    amountMinor,
    unit,
    interval,
    startDate,
    endDate,
    categoryId,
    accountId,
    note,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlannedItemRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.amountMinor == this.amountMinor &&
          other.unit == this.unit &&
          other.interval == this.interval &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.categoryId == this.categoryId &&
          other.accountId == this.accountId &&
          other.note == this.note &&
          other.isActive == this.isActive);
}

class PlannedItemsCompanion extends UpdateCompanion<PlannedItemRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<PlannedKind> kind;
  final Value<int> amountMinor;
  final Value<RecurrenceUnit> unit;
  final Value<int> interval;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<int?> categoryId;
  final Value<int?> accountId;
  final Value<String> note;
  final Value<bool> isActive;
  const PlannedItemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.unit = const Value.absent(),
    this.interval = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.note = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  PlannedItemsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required PlannedKind kind,
    required int amountMinor,
    required RecurrenceUnit unit,
    this.interval = const Value.absent(),
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.note = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : name = Value(name),
       kind = Value(kind),
       amountMinor = Value(amountMinor),
       unit = Value(unit),
       startDate = Value(startDate);
  static Insertable<PlannedItemRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<int>? amountMinor,
    Expression<String>? unit,
    Expression<int>? interval,
    Expression<int>? startDate,
    Expression<int>? endDate,
    Expression<int>? categoryId,
    Expression<int>? accountId,
    Expression<String>? note,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (unit != null) 'unit': unit,
      if (interval != null) 'interval': interval,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (categoryId != null) 'category_id': categoryId,
      if (accountId != null) 'account_id': accountId,
      if (note != null) 'note': note,
      if (isActive != null) 'is_active': isActive,
    });
  }

  PlannedItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<PlannedKind>? kind,
    Value<int>? amountMinor,
    Value<RecurrenceUnit>? unit,
    Value<int>? interval,
    Value<DateTime>? startDate,
    Value<DateTime?>? endDate,
    Value<int?>? categoryId,
    Value<int?>? accountId,
    Value<String>? note,
    Value<bool>? isActive,
  }) {
    return PlannedItemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      amountMinor: amountMinor ?? this.amountMinor,
      unit: unit ?? this.unit,
      interval: interval ?? this.interval,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      categoryId: categoryId ?? this.categoryId,
      accountId: accountId ?? this.accountId,
      note: note ?? this.note,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $PlannedItemsTable.$converterkind.toSql(kind.value),
      );
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(
        $PlannedItemsTable.$converterunit.toSql(unit.value),
      );
    }
    if (interval.present) {
      map['interval'] = Variable<int>(interval.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<int>(
        $PlannedItemsTable.$converterstartDate.toSql(startDate.value),
      );
    }
    if (endDate.present) {
      map['end_date'] = Variable<int>(
        $PlannedItemsTable.$converterendDaten.toSql(endDate.value),
      );
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlannedItemsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('unit: $unit, ')
          ..write('interval: $interval, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('categoryId: $categoryId, ')
          ..write('accountId: $accountId, ')
          ..write('note: $note, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, BudgetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<YearMonth, int> startMonth =
      GeneratedColumn<int>(
        'start_month',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<YearMonth>($BudgetsTable.$converterstartMonth);
  @override
  late final GeneratedColumnWithTypeConverter<YearMonth?, int> endMonth =
      GeneratedColumn<int>(
        'end_month',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<YearMonth?>($BudgetsTable.$converterendMonthn);
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    amountMinor,
    startMonth,
    endMonth,
    colorValue,
    isArchived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      startMonth: $BudgetsTable.$converterstartMonth.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}start_month'],
        )!,
      ),
      endMonth: $BudgetsTable.$converterendMonthn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}end_month'],
        ),
      ),
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }

  static TypeConverter<YearMonth, int> $converterstartMonth =
      const YearMonthConverter();
  static TypeConverter<YearMonth, int> $converterendMonth =
      const YearMonthConverter();
  static TypeConverter<YearMonth?, int?> $converterendMonthn =
      NullAwareTypeConverter.wrap($converterendMonth);
}

class BudgetRow extends DataClass implements Insertable<BudgetRow> {
  final int id;
  final String name;
  final int amountMinor;
  final YearMonth startMonth;
  final YearMonth? endMonth;
  final int colorValue;
  final bool isArchived;
  const BudgetRow({
    required this.id,
    required this.name,
    required this.amountMinor,
    required this.startMonth,
    this.endMonth,
    required this.colorValue,
    required this.isArchived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['amount_minor'] = Variable<int>(amountMinor);
    {
      map['start_month'] = Variable<int>(
        $BudgetsTable.$converterstartMonth.toSql(startMonth),
      );
    }
    if (!nullToAbsent || endMonth != null) {
      map['end_month'] = Variable<int>(
        $BudgetsTable.$converterendMonthn.toSql(endMonth),
      );
    }
    map['color_value'] = Variable<int>(colorValue);
    map['is_archived'] = Variable<bool>(isArchived);
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      id: Value(id),
      name: Value(name),
      amountMinor: Value(amountMinor),
      startMonth: Value(startMonth),
      endMonth: endMonth == null && nullToAbsent
          ? const Value.absent()
          : Value(endMonth),
      colorValue: Value(colorValue),
      isArchived: Value(isArchived),
    );
  }

  factory BudgetRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      startMonth: serializer.fromJson<YearMonth>(json['startMonth']),
      endMonth: serializer.fromJson<YearMonth?>(json['endMonth']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'startMonth': serializer.toJson<YearMonth>(startMonth),
      'endMonth': serializer.toJson<YearMonth?>(endMonth),
      'colorValue': serializer.toJson<int>(colorValue),
      'isArchived': serializer.toJson<bool>(isArchived),
    };
  }

  BudgetRow copyWith({
    int? id,
    String? name,
    int? amountMinor,
    YearMonth? startMonth,
    Value<YearMonth?> endMonth = const Value.absent(),
    int? colorValue,
    bool? isArchived,
  }) => BudgetRow(
    id: id ?? this.id,
    name: name ?? this.name,
    amountMinor: amountMinor ?? this.amountMinor,
    startMonth: startMonth ?? this.startMonth,
    endMonth: endMonth.present ? endMonth.value : this.endMonth,
    colorValue: colorValue ?? this.colorValue,
    isArchived: isArchived ?? this.isArchived,
  );
  BudgetRow copyWithCompanion(BudgetsCompanion data) {
    return BudgetRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      startMonth: data.startMonth.present
          ? data.startMonth.value
          : this.startMonth,
      endMonth: data.endMonth.present ? data.endMonth.value : this.endMonth,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('startMonth: $startMonth, ')
          ..write('endMonth: $endMonth, ')
          ..write('colorValue: $colorValue, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    amountMinor,
    startMonth,
    endMonth,
    colorValue,
    isArchived,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.amountMinor == this.amountMinor &&
          other.startMonth == this.startMonth &&
          other.endMonth == this.endMonth &&
          other.colorValue == this.colorValue &&
          other.isArchived == this.isArchived);
}

class BudgetsCompanion extends UpdateCompanion<BudgetRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> amountMinor;
  final Value<YearMonth> startMonth;
  final Value<YearMonth?> endMonth;
  final Value<int> colorValue;
  final Value<bool> isArchived;
  const BudgetsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.startMonth = const Value.absent(),
    this.endMonth = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.isArchived = const Value.absent(),
  });
  BudgetsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int amountMinor,
    required YearMonth startMonth,
    this.endMonth = const Value.absent(),
    required int colorValue,
    this.isArchived = const Value.absent(),
  }) : name = Value(name),
       amountMinor = Value(amountMinor),
       startMonth = Value(startMonth),
       colorValue = Value(colorValue);
  static Insertable<BudgetRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? amountMinor,
    Expression<int>? startMonth,
    Expression<int>? endMonth,
    Expression<int>? colorValue,
    Expression<bool>? isArchived,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (startMonth != null) 'start_month': startMonth,
      if (endMonth != null) 'end_month': endMonth,
      if (colorValue != null) 'color_value': colorValue,
      if (isArchived != null) 'is_archived': isArchived,
    });
  }

  BudgetsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? amountMinor,
    Value<YearMonth>? startMonth,
    Value<YearMonth?>? endMonth,
    Value<int>? colorValue,
    Value<bool>? isArchived,
  }) {
    return BudgetsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      amountMinor: amountMinor ?? this.amountMinor,
      startMonth: startMonth ?? this.startMonth,
      endMonth: endMonth ?? this.endMonth,
      colorValue: colorValue ?? this.colorValue,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (startMonth.present) {
      map['start_month'] = Variable<int>(
        $BudgetsTable.$converterstartMonth.toSql(startMonth.value),
      );
    }
    if (endMonth.present) {
      map['end_month'] = Variable<int>(
        $BudgetsTable.$converterendMonthn.toSql(endMonth.value),
      );
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('startMonth: $startMonth, ')
          ..write('endMonth: $endMonth, ')
          ..write('colorValue: $colorValue, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }
}

class $BudgetCategoriesTable extends BudgetCategories
    with TableInfo<$BudgetCategoriesTable, BudgetCategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _budgetIdMeta = const VerificationMeta(
    'budgetId',
  );
  @override
  late final GeneratedColumn<int> budgetId = GeneratedColumn<int>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES budgets (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [budgetId, categoryId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetCategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {budgetId, categoryId};
  @override
  BudgetCategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetCategoryRow(
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}budget_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
    );
  }

  @override
  $BudgetCategoriesTable createAlias(String alias) {
    return $BudgetCategoriesTable(attachedDatabase, alias);
  }
}

class BudgetCategoryRow extends DataClass
    implements Insertable<BudgetCategoryRow> {
  final int budgetId;
  final int categoryId;
  const BudgetCategoryRow({required this.budgetId, required this.categoryId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['budget_id'] = Variable<int>(budgetId);
    map['category_id'] = Variable<int>(categoryId);
    return map;
  }

  BudgetCategoriesCompanion toCompanion(bool nullToAbsent) {
    return BudgetCategoriesCompanion(
      budgetId: Value(budgetId),
      categoryId: Value(categoryId),
    );
  }

  factory BudgetCategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetCategoryRow(
      budgetId: serializer.fromJson<int>(json['budgetId']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'budgetId': serializer.toJson<int>(budgetId),
      'categoryId': serializer.toJson<int>(categoryId),
    };
  }

  BudgetCategoryRow copyWith({int? budgetId, int? categoryId}) =>
      BudgetCategoryRow(
        budgetId: budgetId ?? this.budgetId,
        categoryId: categoryId ?? this.categoryId,
      );
  BudgetCategoryRow copyWithCompanion(BudgetCategoriesCompanion data) {
    return BudgetCategoryRow(
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetCategoryRow(')
          ..write('budgetId: $budgetId, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(budgetId, categoryId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetCategoryRow &&
          other.budgetId == this.budgetId &&
          other.categoryId == this.categoryId);
}

class BudgetCategoriesCompanion extends UpdateCompanion<BudgetCategoryRow> {
  final Value<int> budgetId;
  final Value<int> categoryId;
  final Value<int> rowid;
  const BudgetCategoriesCompanion({
    this.budgetId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetCategoriesCompanion.insert({
    required int budgetId,
    required int categoryId,
    this.rowid = const Value.absent(),
  }) : budgetId = Value(budgetId),
       categoryId = Value(categoryId);
  static Insertable<BudgetCategoryRow> custom({
    Expression<int>? budgetId,
    Expression<int>? categoryId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (budgetId != null) 'budget_id': budgetId,
      if (categoryId != null) 'category_id': categoryId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetCategoriesCompanion copyWith({
    Value<int>? budgetId,
    Value<int>? categoryId,
    Value<int>? rowid,
  }) {
    return BudgetCategoriesCompanion(
      budgetId: budgetId ?? this.budgetId,
      categoryId: categoryId ?? this.categoryId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (budgetId.present) {
      map['budget_id'] = Variable<int>(budgetId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetCategoriesCompanion(')
          ..write('budgetId: $budgetId, ')
          ..write('categoryId: $categoryId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavingsGoalsTable extends SavingsGoals
    with TableInfo<$SavingsGoalsTable, SavingsGoalRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMinorMeta = const VerificationMeta(
    'targetMinor',
  );
  @override
  late final GeneratedColumn<int> targetMinor = GeneratedColumn<int>(
    'target_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _savedMinorMeta = const VerificationMeta(
    'savedMinor',
  );
  @override
  late final GeneratedColumn<int> savedMinor = GeneratedColumn<int>(
    'saved_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<YearMonth, int> targetMonth =
      GeneratedColumn<int>(
        'target_month',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<YearMonth>($SavingsGoalsTable.$convertertargetMonth);
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    targetMinor,
    savedMinor,
    targetMonth,
    priority,
    accountId,
    colorValue,
    isArchived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavingsGoalRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_minor')) {
      context.handle(
        _targetMinorMeta,
        targetMinor.isAcceptableOrUnknown(
          data['target_minor']!,
          _targetMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetMinorMeta);
    }
    if (data.containsKey('saved_minor')) {
      context.handle(
        _savedMinorMeta,
        savedMinor.isAcceptableOrUnknown(data['saved_minor']!, _savedMinorMeta),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavingsGoalRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsGoalRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      targetMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_minor'],
      )!,
      savedMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}saved_minor'],
      )!,
      targetMonth: $SavingsGoalsTable.$convertertargetMonth.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}target_month'],
        )!,
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      ),
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
    );
  }

  @override
  $SavingsGoalsTable createAlias(String alias) {
    return $SavingsGoalsTable(attachedDatabase, alias);
  }

  static TypeConverter<YearMonth, int> $convertertargetMonth =
      const YearMonthConverter();
}

class SavingsGoalRow extends DataClass implements Insertable<SavingsGoalRow> {
  final int id;
  final String name;
  final int targetMinor;
  final int savedMinor;
  final YearMonth targetMonth;
  final int priority;
  final int? accountId;
  final int colorValue;
  final bool isArchived;
  const SavingsGoalRow({
    required this.id,
    required this.name,
    required this.targetMinor,
    required this.savedMinor,
    required this.targetMonth,
    required this.priority,
    this.accountId,
    required this.colorValue,
    required this.isArchived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['target_minor'] = Variable<int>(targetMinor);
    map['saved_minor'] = Variable<int>(savedMinor);
    {
      map['target_month'] = Variable<int>(
        $SavingsGoalsTable.$convertertargetMonth.toSql(targetMonth),
      );
    }
    map['priority'] = Variable<int>(priority);
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<int>(accountId);
    }
    map['color_value'] = Variable<int>(colorValue);
    map['is_archived'] = Variable<bool>(isArchived);
    return map;
  }

  SavingsGoalsCompanion toCompanion(bool nullToAbsent) {
    return SavingsGoalsCompanion(
      id: Value(id),
      name: Value(name),
      targetMinor: Value(targetMinor),
      savedMinor: Value(savedMinor),
      targetMonth: Value(targetMonth),
      priority: Value(priority),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      colorValue: Value(colorValue),
      isArchived: Value(isArchived),
    );
  }

  factory SavingsGoalRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsGoalRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      targetMinor: serializer.fromJson<int>(json['targetMinor']),
      savedMinor: serializer.fromJson<int>(json['savedMinor']),
      targetMonth: serializer.fromJson<YearMonth>(json['targetMonth']),
      priority: serializer.fromJson<int>(json['priority']),
      accountId: serializer.fromJson<int?>(json['accountId']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'targetMinor': serializer.toJson<int>(targetMinor),
      'savedMinor': serializer.toJson<int>(savedMinor),
      'targetMonth': serializer.toJson<YearMonth>(targetMonth),
      'priority': serializer.toJson<int>(priority),
      'accountId': serializer.toJson<int?>(accountId),
      'colorValue': serializer.toJson<int>(colorValue),
      'isArchived': serializer.toJson<bool>(isArchived),
    };
  }

  SavingsGoalRow copyWith({
    int? id,
    String? name,
    int? targetMinor,
    int? savedMinor,
    YearMonth? targetMonth,
    int? priority,
    Value<int?> accountId = const Value.absent(),
    int? colorValue,
    bool? isArchived,
  }) => SavingsGoalRow(
    id: id ?? this.id,
    name: name ?? this.name,
    targetMinor: targetMinor ?? this.targetMinor,
    savedMinor: savedMinor ?? this.savedMinor,
    targetMonth: targetMonth ?? this.targetMonth,
    priority: priority ?? this.priority,
    accountId: accountId.present ? accountId.value : this.accountId,
    colorValue: colorValue ?? this.colorValue,
    isArchived: isArchived ?? this.isArchived,
  );
  SavingsGoalRow copyWithCompanion(SavingsGoalsCompanion data) {
    return SavingsGoalRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      targetMinor: data.targetMinor.present
          ? data.targetMinor.value
          : this.targetMinor,
      savedMinor: data.savedMinor.present
          ? data.savedMinor.value
          : this.savedMinor,
      targetMonth: data.targetMonth.present
          ? data.targetMonth.value
          : this.targetMonth,
      priority: data.priority.present ? data.priority.value : this.priority,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoalRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetMinor: $targetMinor, ')
          ..write('savedMinor: $savedMinor, ')
          ..write('targetMonth: $targetMonth, ')
          ..write('priority: $priority, ')
          ..write('accountId: $accountId, ')
          ..write('colorValue: $colorValue, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    targetMinor,
    savedMinor,
    targetMonth,
    priority,
    accountId,
    colorValue,
    isArchived,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsGoalRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.targetMinor == this.targetMinor &&
          other.savedMinor == this.savedMinor &&
          other.targetMonth == this.targetMonth &&
          other.priority == this.priority &&
          other.accountId == this.accountId &&
          other.colorValue == this.colorValue &&
          other.isArchived == this.isArchived);
}

class SavingsGoalsCompanion extends UpdateCompanion<SavingsGoalRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> targetMinor;
  final Value<int> savedMinor;
  final Value<YearMonth> targetMonth;
  final Value<int> priority;
  final Value<int?> accountId;
  final Value<int> colorValue;
  final Value<bool> isArchived;
  const SavingsGoalsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.targetMinor = const Value.absent(),
    this.savedMinor = const Value.absent(),
    this.targetMonth = const Value.absent(),
    this.priority = const Value.absent(),
    this.accountId = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.isArchived = const Value.absent(),
  });
  SavingsGoalsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int targetMinor,
    this.savedMinor = const Value.absent(),
    required YearMonth targetMonth,
    this.priority = const Value.absent(),
    this.accountId = const Value.absent(),
    required int colorValue,
    this.isArchived = const Value.absent(),
  }) : name = Value(name),
       targetMinor = Value(targetMinor),
       targetMonth = Value(targetMonth),
       colorValue = Value(colorValue);
  static Insertable<SavingsGoalRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? targetMinor,
    Expression<int>? savedMinor,
    Expression<int>? targetMonth,
    Expression<int>? priority,
    Expression<int>? accountId,
    Expression<int>? colorValue,
    Expression<bool>? isArchived,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (targetMinor != null) 'target_minor': targetMinor,
      if (savedMinor != null) 'saved_minor': savedMinor,
      if (targetMonth != null) 'target_month': targetMonth,
      if (priority != null) 'priority': priority,
      if (accountId != null) 'account_id': accountId,
      if (colorValue != null) 'color_value': colorValue,
      if (isArchived != null) 'is_archived': isArchived,
    });
  }

  SavingsGoalsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? targetMinor,
    Value<int>? savedMinor,
    Value<YearMonth>? targetMonth,
    Value<int>? priority,
    Value<int?>? accountId,
    Value<int>? colorValue,
    Value<bool>? isArchived,
  }) {
    return SavingsGoalsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      targetMinor: targetMinor ?? this.targetMinor,
      savedMinor: savedMinor ?? this.savedMinor,
      targetMonth: targetMonth ?? this.targetMonth,
      priority: priority ?? this.priority,
      accountId: accountId ?? this.accountId,
      colorValue: colorValue ?? this.colorValue,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetMinor.present) {
      map['target_minor'] = Variable<int>(targetMinor.value);
    }
    if (savedMinor.present) {
      map['saved_minor'] = Variable<int>(savedMinor.value);
    }
    if (targetMonth.present) {
      map['target_month'] = Variable<int>(
        $SavingsGoalsTable.$convertertargetMonth.toSql(targetMonth.value),
      );
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoalsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetMinor: $targetMinor, ')
          ..write('savedMinor: $savedMinor, ')
          ..write('targetMonth: $targetMonth, ')
          ..write('priority: $priority, ')
          ..write('accountId: $accountId, ')
          ..write('colorValue: $colorValue, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }
}

class $AppSettingEntriesTable extends AppSettingEntries
    with TableInfo<$AppSettingEntriesTable, AppSettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_setting_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingEntriesTable createAlias(String alias) {
    return $AppSettingEntriesTable(attachedDatabase, alias);
  }
}

class AppSettingRow extends DataClass implements Insertable<AppSettingRow> {
  final String key;
  final String value;
  const AppSettingRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingEntriesCompanion toCompanion(bool nullToAbsent) {
    return AppSettingEntriesCompanion(key: Value(key), value: Value(value));
  }

  factory AppSettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSettingRow copyWith({String? key, String? value}) =>
      AppSettingRow(key: key ?? this.key, value: value ?? this.value);
  AppSettingRow copyWithCompanion(AppSettingEntriesCompanion data) {
    return AppSettingRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingRow &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingEntriesCompanion extends UpdateCompanion<AppSettingRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingEntriesCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingEntriesCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSettingRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingEntriesCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingEntriesCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingEntriesCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $ImportProfilesTable importProfiles = $ImportProfilesTable(this);
  late final $ImportBatchesTable importBatches = $ImportBatchesTable(this);
  late final $CategoryRulesTable categoryRules = $CategoryRulesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $ClassifierTokensTable classifierTokens = $ClassifierTokensTable(
    this,
  );
  late final $ClassifierCategoriesTable classifierCategories =
      $ClassifierCategoriesTable(this);
  late final $PlannedItemsTable plannedItems = $PlannedItemsTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $BudgetCategoriesTable budgetCategories = $BudgetCategoriesTable(
    this,
  );
  late final $SavingsGoalsTable savingsGoals = $SavingsGoalsTable(this);
  late final $AppSettingEntriesTable appSettingEntries =
      $AppSettingEntriesTable(this);
  late final Index transactionsAccountDate = Index(
    'transactions_account_date',
    'CREATE INDEX transactions_account_date ON transactions (account_id, booking_date)',
  );
  late final Index transactionsDate = Index(
    'transactions_date',
    'CREATE INDEX transactions_date ON transactions (booking_date)',
  );
  late final Index transactionsCategory = Index(
    'transactions_category',
    'CREATE INDEX transactions_category ON transactions (category_id)',
  );
  late final Index transactionsDedup = Index(
    'transactions_dedup',
    'CREATE INDEX transactions_dedup ON transactions (account_id, dedup_hash)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    accounts,
    categories,
    importProfiles,
    importBatches,
    categoryRules,
    transactions,
    classifierTokens,
    classifierCategories,
    plannedItems,
    budgets,
    budgetCategories,
    savingsGoals,
    appSettingEntries,
    transactionsAccountDate,
    transactionsDate,
    transactionsCategory,
    transactionsDedup,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('categories', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accounts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('import_batches', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'import_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('import_batches', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('category_rules', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accounts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('transactions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('transactions', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'category_rules',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('transactions', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('transactions', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'import_batches',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('transactions', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('classifier_tokens', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('classifier_categories', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('planned_items', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accounts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('planned_items', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'budgets',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('budget_categories', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('budget_categories', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accounts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('savings_goals', kind: UpdateKind.update)],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}
