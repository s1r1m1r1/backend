// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_client.dart';

// ignore_for_file: type=lint
class $ChannelTableTable extends ChannelTable
    with TableInfo<$ChannelTableTable, ChannelEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChannelTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, title, description, deletedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'channel_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChannelEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChannelEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChannelEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $ChannelTableTable createAlias(String alias) {
    return $ChannelTableTable(attachedDatabase, alias);
  }
}

class ChannelEntry extends DataClass implements Insertable<ChannelEntry> {
  final int id;
  final String title;
  final String description;
  final DateTime? deletedAt;
  const ChannelEntry({
    required this.id,
    required this.title,
    required this.description,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  ChannelTableCompanion toCompanion(bool nullToAbsent) {
    return ChannelTableCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory ChannelEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChannelEntry(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  ChannelEntry copyWith({
    int? id,
    String? title,
    String? description,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => ChannelEntry(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  ChannelEntry copyWithCompanion(ChannelTableCompanion data) {
    return ChannelEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChannelEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, description, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChannelEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.deletedAt == this.deletedAt);
}

class ChannelTableCompanion extends UpdateCompanion<ChannelEntry> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> description;
  final Value<DateTime?> deletedAt;
  const ChannelTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  ChannelTableCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String description,
    this.deletedAt = const Value.absent(),
  }) : title = Value(title),
       description = Value(description);
  static Insertable<ChannelEntry> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  ChannelTableCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? description,
    Value<DateTime?>? deletedAt,
  }) {
    return ChannelTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChannelTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }
}

class $UserTableTable extends UserTable
    with TableInfo<$UserTableTable, UserEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v1(),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passwordMeta = const VerificationMeta(
    'password',
  );
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
    'password',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    email,
    password,
    createdAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('password')) {
      context.handle(
        _passwordMeta,
        password.isAcceptableOrUnknown(data['password']!, _passwordMeta),
      );
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      password: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $UserTableTable createAlias(String alias) {
    return $UserTableTable(attachedDatabase, alias);
  }
}

class UserEntry extends DataClass implements Insertable<UserEntry> {
  final String id;
  final String email;
  final String password;
  final DateTime createdAt;
  final DateTime? deletedAt;
  const UserEntry({
    required this.id,
    required this.email,
    required this.password,
    required this.createdAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['email'] = Variable<String>(email);
    map['password'] = Variable<String>(password);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  UserTableCompanion toCompanion(bool nullToAbsent) {
    return UserTableCompanion(
      id: Value(id),
      email: Value(email),
      password: Value(password),
      createdAt: Value(createdAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory UserEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserEntry(
      id: serializer.fromJson<String>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      password: serializer.fromJson<String>(json['password']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'email': serializer.toJson<String>(email),
      'password': serializer.toJson<String>(password),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  UserEntry copyWith({
    String? id,
    String? email,
    String? password,
    DateTime? createdAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => UserEntry(
    id: id ?? this.id,
    email: email ?? this.email,
    password: password ?? this.password,
    createdAt: createdAt ?? this.createdAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  UserEntry copyWithCompanion(UserTableCompanion data) {
    return UserEntry(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      password: data.password.present ? data.password.value : this.password,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserEntry(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, email, password, createdAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserEntry &&
          other.id == this.id &&
          other.email == this.email &&
          other.password == this.password &&
          other.createdAt == this.createdAt &&
          other.deletedAt == this.deletedAt);
}

class UserTableCompanion extends UpdateCompanion<UserEntry> {
  final Value<String> id;
  final Value<String> email;
  final Value<String> password;
  final Value<DateTime> createdAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const UserTableCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.password = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserTableCompanion.insert({
    this.id = const Value.absent(),
    required String email,
    required String password,
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : email = Value(email),
       password = Value(password);
  static Insertable<UserEntry> custom({
    Expression<String>? id,
    Expression<String>? email,
    Expression<String>? password,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
      if (createdAt != null) 'created_at': createdAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserTableCompanion copyWith({
    Value<String>? id,
    Value<String>? email,
    Value<String>? password,
    Value<DateTime>? createdAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return UserTableCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserTableCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TodoTableTable extends TodoTable
    with TableInfo<$TodoTableTable, TodoEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodoTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_table (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    completed,
    createdAt,
    updatedAt,
    deletedAt,
    userId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todo_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TodoEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TodoEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TodoEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
    );
  }

  @override
  $TodoTableTable createAlias(String alias) {
    return $TodoTableTable(attachedDatabase, alias);
  }
}

class TodoEntry extends DataClass implements Insertable<TodoEntry> {
  final int id;
  final String title;
  final String description;
  final bool completed;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final String? userId;
  const TodoEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.userId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['completed'] = Variable<bool>(completed);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    return map;
  }

  TodoTableCompanion toCompanion(bool nullToAbsent) {
    return TodoTableCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      completed: Value(completed),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
    );
  }

  factory TodoEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TodoEntry(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      completed: serializer.fromJson<bool>(json['completed']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      userId: serializer.fromJson<String?>(json['userId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'completed': serializer.toJson<bool>(completed),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'userId': serializer.toJson<String?>(userId),
    };
  }

  TodoEntry copyWith({
    int? id,
    String? title,
    String? description,
    bool? completed,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> userId = const Value.absent(),
  }) => TodoEntry(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    completed: completed ?? this.completed,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    userId: userId.present ? userId.value : this.userId,
  );
  TodoEntry copyWithCompanion(TodoTableCompanion data) {
    return TodoEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      completed: data.completed.present ? data.completed.value : this.completed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      userId: data.userId.present ? data.userId.value : this.userId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TodoEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('completed: $completed, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    completed,
    createdAt,
    updatedAt,
    deletedAt,
    userId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TodoEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.completed == this.completed &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.userId == this.userId);
}

class TodoTableCompanion extends UpdateCompanion<TodoEntry> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> description;
  final Value<bool> completed;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> userId;
  const TodoTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.completed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.userId = const Value.absent(),
  });
  TodoTableCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String description,
    this.completed = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.userId = const Value.absent(),
  }) : title = Value(title),
       description = Value(description),
       createdAt = Value(createdAt);
  static Insertable<TodoEntry> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<bool>? completed,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? userId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (completed != null) 'completed': completed,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (userId != null) 'user_id': userId,
    });
  }

  TodoTableCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? description,
    Value<bool>? completed,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? userId,
  }) {
    return TodoTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      userId: userId ?? this.userId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodoTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('completed: $completed, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }
}

class $SessionTableTable extends SessionTable
    with TableInfo<$SessionTableTable, SessionEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _tokenMeta = const VerificationMeta('token');
  @override
  late final GeneratedColumn<String> token = GeneratedColumn<String>(
    'token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_table (id)',
    ),
  );
  static const VerificationMeta _expiryDateMeta = const VerificationMeta(
    'expiryDate',
  );
  @override
  late final GeneratedColumn<DateTime> expiryDate = GeneratedColumn<DateTime>(
    'expiry_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _refreshTokenMeta = const VerificationMeta(
    'refreshToken',
  );
  @override
  late final GeneratedColumn<String> refreshToken = GeneratedColumn<String>(
    'refresh_token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _refreshTokenExpiryMeta =
      const VerificationMeta('refreshTokenExpiry');
  @override
  late final GeneratedColumn<DateTime> refreshTokenExpiry =
      GeneratedColumn<DateTime>(
        'refresh_token_expiry',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    token,
    userId,
    expiryDate,
    createdAt,
    refreshToken,
    refreshTokenExpiry,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('token')) {
      context.handle(
        _tokenMeta,
        token.isAcceptableOrUnknown(data['token']!, _tokenMeta),
      );
    } else if (isInserting) {
      context.missing(_tokenMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
        _expiryDateMeta,
        expiryDate.isAcceptableOrUnknown(data['expiry_date']!, _expiryDateMeta),
      );
    } else if (isInserting) {
      context.missing(_expiryDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('refresh_token')) {
      context.handle(
        _refreshTokenMeta,
        refreshToken.isAcceptableOrUnknown(
          data['refresh_token']!,
          _refreshTokenMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_refreshTokenMeta);
    }
    if (data.containsKey('refresh_token_expiry')) {
      context.handle(
        _refreshTokenExpiryMeta,
        refreshTokenExpiry.isAcceptableOrUnknown(
          data['refresh_token_expiry']!,
          _refreshTokenExpiryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_refreshTokenExpiryMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      token: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}token'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      expiryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expiry_date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      refreshToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}refresh_token'],
      )!,
      refreshTokenExpiry: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}refresh_token_expiry'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $SessionTableTable createAlias(String alias) {
    return $SessionTableTable(attachedDatabase, alias);
  }
}

class SessionEntry extends DataClass implements Insertable<SessionEntry> {
  final int id;
  final String token;
  final String userId;
  final DateTime expiryDate;
  final DateTime createdAt;
  final String refreshToken;
  final DateTime refreshTokenExpiry;
  final DateTime? deletedAt;
  const SessionEntry({
    required this.id,
    required this.token,
    required this.userId,
    required this.expiryDate,
    required this.createdAt,
    required this.refreshToken,
    required this.refreshTokenExpiry,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['token'] = Variable<String>(token);
    map['user_id'] = Variable<String>(userId);
    map['expiry_date'] = Variable<DateTime>(expiryDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['refresh_token'] = Variable<String>(refreshToken);
    map['refresh_token_expiry'] = Variable<DateTime>(refreshTokenExpiry);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  SessionTableCompanion toCompanion(bool nullToAbsent) {
    return SessionTableCompanion(
      id: Value(id),
      token: Value(token),
      userId: Value(userId),
      expiryDate: Value(expiryDate),
      createdAt: Value(createdAt),
      refreshToken: Value(refreshToken),
      refreshTokenExpiry: Value(refreshTokenExpiry),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory SessionEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionEntry(
      id: serializer.fromJson<int>(json['id']),
      token: serializer.fromJson<String>(json['token']),
      userId: serializer.fromJson<String>(json['userId']),
      expiryDate: serializer.fromJson<DateTime>(json['expiryDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      refreshToken: serializer.fromJson<String>(json['refreshToken']),
      refreshTokenExpiry: serializer.fromJson<DateTime>(
        json['refreshTokenExpiry'],
      ),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'token': serializer.toJson<String>(token),
      'userId': serializer.toJson<String>(userId),
      'expiryDate': serializer.toJson<DateTime>(expiryDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'refreshToken': serializer.toJson<String>(refreshToken),
      'refreshTokenExpiry': serializer.toJson<DateTime>(refreshTokenExpiry),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  SessionEntry copyWith({
    int? id,
    String? token,
    String? userId,
    DateTime? expiryDate,
    DateTime? createdAt,
    String? refreshToken,
    DateTime? refreshTokenExpiry,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => SessionEntry(
    id: id ?? this.id,
    token: token ?? this.token,
    userId: userId ?? this.userId,
    expiryDate: expiryDate ?? this.expiryDate,
    createdAt: createdAt ?? this.createdAt,
    refreshToken: refreshToken ?? this.refreshToken,
    refreshTokenExpiry: refreshTokenExpiry ?? this.refreshTokenExpiry,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  SessionEntry copyWithCompanion(SessionTableCompanion data) {
    return SessionEntry(
      id: data.id.present ? data.id.value : this.id,
      token: data.token.present ? data.token.value : this.token,
      userId: data.userId.present ? data.userId.value : this.userId,
      expiryDate: data.expiryDate.present
          ? data.expiryDate.value
          : this.expiryDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      refreshToken: data.refreshToken.present
          ? data.refreshToken.value
          : this.refreshToken,
      refreshTokenExpiry: data.refreshTokenExpiry.present
          ? data.refreshTokenExpiry.value
          : this.refreshTokenExpiry,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionEntry(')
          ..write('id: $id, ')
          ..write('token: $token, ')
          ..write('userId: $userId, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('refreshTokenExpiry: $refreshTokenExpiry, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    token,
    userId,
    expiryDate,
    createdAt,
    refreshToken,
    refreshTokenExpiry,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionEntry &&
          other.id == this.id &&
          other.token == this.token &&
          other.userId == this.userId &&
          other.expiryDate == this.expiryDate &&
          other.createdAt == this.createdAt &&
          other.refreshToken == this.refreshToken &&
          other.refreshTokenExpiry == this.refreshTokenExpiry &&
          other.deletedAt == this.deletedAt);
}

class SessionTableCompanion extends UpdateCompanion<SessionEntry> {
  final Value<int> id;
  final Value<String> token;
  final Value<String> userId;
  final Value<DateTime> expiryDate;
  final Value<DateTime> createdAt;
  final Value<String> refreshToken;
  final Value<DateTime> refreshTokenExpiry;
  final Value<DateTime?> deletedAt;
  const SessionTableCompanion({
    this.id = const Value.absent(),
    this.token = const Value.absent(),
    this.userId = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.refreshToken = const Value.absent(),
    this.refreshTokenExpiry = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  SessionTableCompanion.insert({
    this.id = const Value.absent(),
    required String token,
    required String userId,
    required DateTime expiryDate,
    required DateTime createdAt,
    required String refreshToken,
    required DateTime refreshTokenExpiry,
    this.deletedAt = const Value.absent(),
  }) : token = Value(token),
       userId = Value(userId),
       expiryDate = Value(expiryDate),
       createdAt = Value(createdAt),
       refreshToken = Value(refreshToken),
       refreshTokenExpiry = Value(refreshTokenExpiry);
  static Insertable<SessionEntry> custom({
    Expression<int>? id,
    Expression<String>? token,
    Expression<String>? userId,
    Expression<DateTime>? expiryDate,
    Expression<DateTime>? createdAt,
    Expression<String>? refreshToken,
    Expression<DateTime>? refreshTokenExpiry,
    Expression<DateTime>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (token != null) 'token': token,
      if (userId != null) 'user_id': userId,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (createdAt != null) 'created_at': createdAt,
      if (refreshToken != null) 'refresh_token': refreshToken,
      if (refreshTokenExpiry != null)
        'refresh_token_expiry': refreshTokenExpiry,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  SessionTableCompanion copyWith({
    Value<int>? id,
    Value<String>? token,
    Value<String>? userId,
    Value<DateTime>? expiryDate,
    Value<DateTime>? createdAt,
    Value<String>? refreshToken,
    Value<DateTime>? refreshTokenExpiry,
    Value<DateTime?>? deletedAt,
  }) {
    return SessionTableCompanion(
      id: id ?? this.id,
      token: token ?? this.token,
      userId: userId ?? this.userId,
      expiryDate: expiryDate ?? this.expiryDate,
      createdAt: createdAt ?? this.createdAt,
      refreshToken: refreshToken ?? this.refreshToken,
      refreshTokenExpiry: refreshTokenExpiry ?? this.refreshTokenExpiry,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<DateTime>(expiryDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (refreshToken.present) {
      map['refresh_token'] = Variable<String>(refreshToken.value);
    }
    if (refreshTokenExpiry.present) {
      map['refresh_token_expiry'] = Variable<DateTime>(
        refreshTokenExpiry.value,
      );
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionTableCompanion(')
          ..write('id: $id, ')
          ..write('token: $token, ')
          ..write('userId: $userId, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('refreshTokenExpiry: $refreshTokenExpiry, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }
}

class $MessageTableTable extends MessageTable
    with TableInfo<$MessageTableTable, MessageEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessageTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _channelIdMeta = const VerificationMeta(
    'channelId',
  );
  @override
  late final GeneratedColumn<int> channelId = GeneratedColumn<int>(
    'channel_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES channel_table (id)',
    ),
  );
  static const VerificationMeta _senderIdMeta = const VerificationMeta(
    'senderId',
  );
  @override
  late final GeneratedColumn<int> senderId = GeneratedColumn<int>(
    'sender_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    channelId,
    senderId,
    content,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'message_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MessageEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('channel_id')) {
      context.handle(
        _channelIdMeta,
        channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta),
      );
    }
    if (data.containsKey('sender_id')) {
      context.handle(
        _senderIdMeta,
        senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_senderIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
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
  MessageEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessageEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      channelId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}channel_id'],
      ),
      senderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sender_id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MessageTableTable createAlias(String alias) {
    return $MessageTableTable(attachedDatabase, alias);
  }
}

class MessageEntry extends DataClass implements Insertable<MessageEntry> {
  final int id;
  final int? channelId;
  final int senderId;
  final String content;
  final DateTime createdAt;
  const MessageEntry({
    required this.id,
    this.channelId,
    required this.senderId,
    required this.content,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || channelId != null) {
      map['channel_id'] = Variable<int>(channelId);
    }
    map['sender_id'] = Variable<int>(senderId);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MessageTableCompanion toCompanion(bool nullToAbsent) {
    return MessageTableCompanion(
      id: Value(id),
      channelId: channelId == null && nullToAbsent
          ? const Value.absent()
          : Value(channelId),
      senderId: Value(senderId),
      content: Value(content),
      createdAt: Value(createdAt),
    );
  }

  factory MessageEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessageEntry(
      id: serializer.fromJson<int>(json['id']),
      channelId: serializer.fromJson<int?>(json['channelId']),
      senderId: serializer.fromJson<int>(json['senderId']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'channelId': serializer.toJson<int?>(channelId),
      'senderId': serializer.toJson<int>(senderId),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MessageEntry copyWith({
    int? id,
    Value<int?> channelId = const Value.absent(),
    int? senderId,
    String? content,
    DateTime? createdAt,
  }) => MessageEntry(
    id: id ?? this.id,
    channelId: channelId.present ? channelId.value : this.channelId,
    senderId: senderId ?? this.senderId,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
  );
  MessageEntry copyWithCompanion(MessageTableCompanion data) {
    return MessageEntry(
      id: data.id.present ? data.id.value : this.id,
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      senderId: data.senderId.present ? data.senderId.value : this.senderId,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MessageEntry(')
          ..write('id: $id, ')
          ..write('channelId: $channelId, ')
          ..write('senderId: $senderId, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, channelId, senderId, content, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageEntry &&
          other.id == this.id &&
          other.channelId == this.channelId &&
          other.senderId == this.senderId &&
          other.content == this.content &&
          other.createdAt == this.createdAt);
}

class MessageTableCompanion extends UpdateCompanion<MessageEntry> {
  final Value<int> id;
  final Value<int?> channelId;
  final Value<int> senderId;
  final Value<String> content;
  final Value<DateTime> createdAt;
  const MessageTableCompanion({
    this.id = const Value.absent(),
    this.channelId = const Value.absent(),
    this.senderId = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MessageTableCompanion.insert({
    this.id = const Value.absent(),
    this.channelId = const Value.absent(),
    required int senderId,
    required String content,
    this.createdAt = const Value.absent(),
  }) : senderId = Value(senderId),
       content = Value(content);
  static Insertable<MessageEntry> custom({
    Expression<int>? id,
    Expression<int>? channelId,
    Expression<int>? senderId,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (channelId != null) 'channel_id': channelId,
      if (senderId != null) 'sender_id': senderId,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MessageTableCompanion copyWith({
    Value<int>? id,
    Value<int?>? channelId,
    Value<int>? senderId,
    Value<String>? content,
    Value<DateTime>? createdAt,
  }) {
    return MessageTableCompanion(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (channelId.present) {
      map['channel_id'] = Variable<int>(channelId.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<int>(senderId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessageTableCompanion(')
          ..write('id: $id, ')
          ..write('channelId: $channelId, ')
          ..write('senderId: $senderId, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$DbClient extends GeneratedDatabase {
  _$DbClient(QueryExecutor e) : super(e);
  $DbClientManager get managers => $DbClientManager(this);
  late final $ChannelTableTable channelTable = $ChannelTableTable(this);
  late final $UserTableTable userTable = $UserTableTable(this);
  late final $TodoTableTable todoTable = $TodoTableTable(this);
  late final $SessionTableTable sessionTable = $SessionTableTable(this);
  late final $MessageTableTable messageTable = $MessageTableTable(this);
  late final ChannelDao channelDao = ChannelDao(this as DbClient);
  late final TodoDao todoDao = TodoDao(this as DbClient);
  late final UserDao userDao = UserDao(this as DbClient);
  late final SessionDao sessionDao = SessionDao(this as DbClient);
  late final MessagesDao messagesDao = MessagesDao(this as DbClient);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    channelTable,
    userTable,
    todoTable,
    sessionTable,
    messageTable,
  ];
}

typedef $$ChannelTableTableCreateCompanionBuilder =
    ChannelTableCompanion Function({
      Value<int> id,
      required String title,
      required String description,
      Value<DateTime?> deletedAt,
    });
typedef $$ChannelTableTableUpdateCompanionBuilder =
    ChannelTableCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> description,
      Value<DateTime?> deletedAt,
    });

final class $$ChannelTableTableReferences
    extends BaseReferences<_$DbClient, $ChannelTableTable, ChannelEntry> {
  $$ChannelTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MessageTableTable, List<MessageEntry>>
  _messageTableRefsTable(_$DbClient db) => MultiTypedResultKey.fromTable(
    db.messageTable,
    aliasName: $_aliasNameGenerator(
      db.channelTable.id,
      db.messageTable.channelId,
    ),
  );

  $$MessageTableTableProcessedTableManager get messageTableRefs {
    final manager = $$MessageTableTableTableManager(
      $_db,
      $_db.messageTable,
    ).filter((f) => f.channelId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_messageTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ChannelTableTableFilterComposer
    extends Composer<_$DbClient, $ChannelTableTable> {
  $$ChannelTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> messageTableRefs(
    Expression<bool> Function($$MessageTableTableFilterComposer f) f,
  ) {
    final $$MessageTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messageTable,
      getReferencedColumn: (t) => t.channelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessageTableTableFilterComposer(
            $db: $db,
            $table: $db.messageTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChannelTableTableOrderingComposer
    extends Composer<_$DbClient, $ChannelTableTable> {
  $$ChannelTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChannelTableTableAnnotationComposer
    extends Composer<_$DbClient, $ChannelTableTable> {
  $$ChannelTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  Expression<T> messageTableRefs<T extends Object>(
    Expression<T> Function($$MessageTableTableAnnotationComposer a) f,
  ) {
    final $$MessageTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messageTable,
      getReferencedColumn: (t) => t.channelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessageTableTableAnnotationComposer(
            $db: $db,
            $table: $db.messageTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChannelTableTableTableManager
    extends
        RootTableManager<
          _$DbClient,
          $ChannelTableTable,
          ChannelEntry,
          $$ChannelTableTableFilterComposer,
          $$ChannelTableTableOrderingComposer,
          $$ChannelTableTableAnnotationComposer,
          $$ChannelTableTableCreateCompanionBuilder,
          $$ChannelTableTableUpdateCompanionBuilder,
          (ChannelEntry, $$ChannelTableTableReferences),
          ChannelEntry,
          PrefetchHooks Function({bool messageTableRefs})
        > {
  $$ChannelTableTableTableManager(_$DbClient db, $ChannelTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChannelTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChannelTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChannelTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => ChannelTableCompanion(
                id: id,
                title: title,
                description: description,
                deletedAt: deletedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String description,
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => ChannelTableCompanion.insert(
                id: id,
                title: title,
                description: description,
                deletedAt: deletedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChannelTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({messageTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (messageTableRefs) db.messageTable],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (messageTableRefs)
                    await $_getPrefetchedData<
                      ChannelEntry,
                      $ChannelTableTable,
                      MessageEntry
                    >(
                      currentTable: table,
                      referencedTable: $$ChannelTableTableReferences
                          ._messageTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ChannelTableTableReferences(
                            db,
                            table,
                            p0,
                          ).messageTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.channelId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ChannelTableTableProcessedTableManager =
    ProcessedTableManager<
      _$DbClient,
      $ChannelTableTable,
      ChannelEntry,
      $$ChannelTableTableFilterComposer,
      $$ChannelTableTableOrderingComposer,
      $$ChannelTableTableAnnotationComposer,
      $$ChannelTableTableCreateCompanionBuilder,
      $$ChannelTableTableUpdateCompanionBuilder,
      (ChannelEntry, $$ChannelTableTableReferences),
      ChannelEntry,
      PrefetchHooks Function({bool messageTableRefs})
    >;
typedef $$UserTableTableCreateCompanionBuilder =
    UserTableCompanion Function({
      Value<String> id,
      required String email,
      required String password,
      Value<DateTime> createdAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$UserTableTableUpdateCompanionBuilder =
    UserTableCompanion Function({
      Value<String> id,
      Value<String> email,
      Value<String> password,
      Value<DateTime> createdAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$UserTableTableReferences
    extends BaseReferences<_$DbClient, $UserTableTable, UserEntry> {
  $$UserTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TodoTableTable, List<TodoEntry>>
  _todoTableRefsTable(_$DbClient db) => MultiTypedResultKey.fromTable(
    db.todoTable,
    aliasName: $_aliasNameGenerator(db.userTable.id, db.todoTable.userId),
  );

  $$TodoTableTableProcessedTableManager get todoTableRefs {
    final manager = $$TodoTableTableTableManager(
      $_db,
      $_db.todoTable,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_todoTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SessionTableTable, List<SessionEntry>>
  _sessionTableRefsTable(_$DbClient db) => MultiTypedResultKey.fromTable(
    db.sessionTable,
    aliasName: $_aliasNameGenerator(db.userTable.id, db.sessionTable.userId),
  );

  $$SessionTableTableProcessedTableManager get sessionTableRefs {
    final manager = $$SessionTableTableTableManager(
      $_db,
      $_db.sessionTable,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UserTableTableFilterComposer
    extends Composer<_$DbClient, $UserTableTable> {
  $$UserTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> todoTableRefs(
    Expression<bool> Function($$TodoTableTableFilterComposer f) f,
  ) {
    final $$TodoTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.todoTable,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TodoTableTableFilterComposer(
            $db: $db,
            $table: $db.todoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sessionTableRefs(
    Expression<bool> Function($$SessionTableTableFilterComposer f) f,
  ) {
    final $$SessionTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionTable,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionTableTableFilterComposer(
            $db: $db,
            $table: $db.sessionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UserTableTableOrderingComposer
    extends Composer<_$DbClient, $UserTableTable> {
  $$UserTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserTableTableAnnotationComposer
    extends Composer<_$DbClient, $UserTableTable> {
  $$UserTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  Expression<T> todoTableRefs<T extends Object>(
    Expression<T> Function($$TodoTableTableAnnotationComposer a) f,
  ) {
    final $$TodoTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.todoTable,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TodoTableTableAnnotationComposer(
            $db: $db,
            $table: $db.todoTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sessionTableRefs<T extends Object>(
    Expression<T> Function($$SessionTableTableAnnotationComposer a) f,
  ) {
    final $$SessionTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionTable,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionTableTableAnnotationComposer(
            $db: $db,
            $table: $db.sessionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UserTableTableTableManager
    extends
        RootTableManager<
          _$DbClient,
          $UserTableTable,
          UserEntry,
          $$UserTableTableFilterComposer,
          $$UserTableTableOrderingComposer,
          $$UserTableTableAnnotationComposer,
          $$UserTableTableCreateCompanionBuilder,
          $$UserTableTableUpdateCompanionBuilder,
          (UserEntry, $$UserTableTableReferences),
          UserEntry,
          PrefetchHooks Function({bool todoTableRefs, bool sessionTableRefs})
        > {
  $$UserTableTableTableManager(_$DbClient db, $UserTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> password = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserTableCompanion(
                id: id,
                email: email,
                password: password,
                createdAt: createdAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String email,
                required String password,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserTableCompanion.insert(
                id: id,
                email: email,
                password: password,
                createdAt: createdAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UserTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({todoTableRefs = false, sessionTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (todoTableRefs) db.todoTable,
                    if (sessionTableRefs) db.sessionTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (todoTableRefs)
                        await $_getPrefetchedData<
                          UserEntry,
                          $UserTableTable,
                          TodoEntry
                        >(
                          currentTable: table,
                          referencedTable: $$UserTableTableReferences
                              ._todoTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UserTableTableReferences(
                                db,
                                table,
                                p0,
                              ).todoTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sessionTableRefs)
                        await $_getPrefetchedData<
                          UserEntry,
                          $UserTableTable,
                          SessionEntry
                        >(
                          currentTable: table,
                          referencedTable: $$UserTableTableReferences
                              ._sessionTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UserTableTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$UserTableTableProcessedTableManager =
    ProcessedTableManager<
      _$DbClient,
      $UserTableTable,
      UserEntry,
      $$UserTableTableFilterComposer,
      $$UserTableTableOrderingComposer,
      $$UserTableTableAnnotationComposer,
      $$UserTableTableCreateCompanionBuilder,
      $$UserTableTableUpdateCompanionBuilder,
      (UserEntry, $$UserTableTableReferences),
      UserEntry,
      PrefetchHooks Function({bool todoTableRefs, bool sessionTableRefs})
    >;
typedef $$TodoTableTableCreateCompanionBuilder =
    TodoTableCompanion Function({
      Value<int> id,
      required String title,
      required String description,
      Value<bool> completed,
      required DateTime createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> userId,
    });
typedef $$TodoTableTableUpdateCompanionBuilder =
    TodoTableCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> description,
      Value<bool> completed,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> userId,
    });

final class $$TodoTableTableReferences
    extends BaseReferences<_$DbClient, $TodoTableTable, TodoEntry> {
  $$TodoTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UserTableTable _userIdTable(_$DbClient db) => db.userTable
      .createAlias($_aliasNameGenerator(db.todoTable.userId, db.userTable.id));

  $$UserTableTableProcessedTableManager? get userId {
    final $_column = $_itemColumn<String>('user_id');
    if ($_column == null) return null;
    final manager = $$UserTableTableTableManager(
      $_db,
      $_db.userTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TodoTableTableFilterComposer
    extends Composer<_$DbClient, $TodoTableTable> {
  $$TodoTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UserTableTableFilterComposer get userId {
    final $$UserTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserTableTableFilterComposer(
            $db: $db,
            $table: $db.userTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TodoTableTableOrderingComposer
    extends Composer<_$DbClient, $TodoTableTable> {
  $$TodoTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserTableTableOrderingComposer get userId {
    final $$UserTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserTableTableOrderingComposer(
            $db: $db,
            $table: $db.userTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TodoTableTableAnnotationComposer
    extends Composer<_$DbClient, $TodoTableTable> {
  $$TodoTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$UserTableTableAnnotationComposer get userId {
    final $$UserTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserTableTableAnnotationComposer(
            $db: $db,
            $table: $db.userTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TodoTableTableTableManager
    extends
        RootTableManager<
          _$DbClient,
          $TodoTableTable,
          TodoEntry,
          $$TodoTableTableFilterComposer,
          $$TodoTableTableOrderingComposer,
          $$TodoTableTableAnnotationComposer,
          $$TodoTableTableCreateCompanionBuilder,
          $$TodoTableTableUpdateCompanionBuilder,
          (TodoEntry, $$TodoTableTableReferences),
          TodoEntry,
          PrefetchHooks Function({bool userId})
        > {
  $$TodoTableTableTableManager(_$DbClient db, $TodoTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodoTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodoTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodoTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> userId = const Value.absent(),
              }) => TodoTableCompanion(
                id: id,
                title: title,
                description: description,
                completed: completed,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                userId: userId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String description,
                Value<bool> completed = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> userId = const Value.absent(),
              }) => TodoTableCompanion.insert(
                id: id,
                title: title,
                description: description,
                completed: completed,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                userId: userId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TodoTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: $$TodoTableTableReferences
                                    ._userIdTable(db),
                                referencedColumn: $$TodoTableTableReferences
                                    ._userIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TodoTableTableProcessedTableManager =
    ProcessedTableManager<
      _$DbClient,
      $TodoTableTable,
      TodoEntry,
      $$TodoTableTableFilterComposer,
      $$TodoTableTableOrderingComposer,
      $$TodoTableTableAnnotationComposer,
      $$TodoTableTableCreateCompanionBuilder,
      $$TodoTableTableUpdateCompanionBuilder,
      (TodoEntry, $$TodoTableTableReferences),
      TodoEntry,
      PrefetchHooks Function({bool userId})
    >;
typedef $$SessionTableTableCreateCompanionBuilder =
    SessionTableCompanion Function({
      Value<int> id,
      required String token,
      required String userId,
      required DateTime expiryDate,
      required DateTime createdAt,
      required String refreshToken,
      required DateTime refreshTokenExpiry,
      Value<DateTime?> deletedAt,
    });
typedef $$SessionTableTableUpdateCompanionBuilder =
    SessionTableCompanion Function({
      Value<int> id,
      Value<String> token,
      Value<String> userId,
      Value<DateTime> expiryDate,
      Value<DateTime> createdAt,
      Value<String> refreshToken,
      Value<DateTime> refreshTokenExpiry,
      Value<DateTime?> deletedAt,
    });

final class $$SessionTableTableReferences
    extends BaseReferences<_$DbClient, $SessionTableTable, SessionEntry> {
  $$SessionTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UserTableTable _userIdTable(_$DbClient db) =>
      db.userTable.createAlias(
        $_aliasNameGenerator(db.sessionTable.userId, db.userTable.id),
      );

  $$UserTableTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UserTableTableTableManager(
      $_db,
      $_db.userTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SessionTableTableFilterComposer
    extends Composer<_$DbClient, $SessionTableTable> {
  $$SessionTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get refreshTokenExpiry => $composableBuilder(
    column: $table.refreshTokenExpiry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UserTableTableFilterComposer get userId {
    final $$UserTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserTableTableFilterComposer(
            $db: $db,
            $table: $db.userTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionTableTableOrderingComposer
    extends Composer<_$DbClient, $SessionTableTable> {
  $$SessionTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get refreshTokenExpiry => $composableBuilder(
    column: $table.refreshTokenExpiry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserTableTableOrderingComposer get userId {
    final $$UserTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserTableTableOrderingComposer(
            $db: $db,
            $table: $db.userTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionTableTableAnnotationComposer
    extends Composer<_$DbClient, $SessionTableTable> {
  $$SessionTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get token =>
      $composableBuilder(column: $table.token, builder: (column) => column);

  GeneratedColumn<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get refreshTokenExpiry => $composableBuilder(
    column: $table.refreshTokenExpiry,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$UserTableTableAnnotationComposer get userId {
    final $$UserTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserTableTableAnnotationComposer(
            $db: $db,
            $table: $db.userTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionTableTableTableManager
    extends
        RootTableManager<
          _$DbClient,
          $SessionTableTable,
          SessionEntry,
          $$SessionTableTableFilterComposer,
          $$SessionTableTableOrderingComposer,
          $$SessionTableTableAnnotationComposer,
          $$SessionTableTableCreateCompanionBuilder,
          $$SessionTableTableUpdateCompanionBuilder,
          (SessionEntry, $$SessionTableTableReferences),
          SessionEntry,
          PrefetchHooks Function({bool userId})
        > {
  $$SessionTableTableTableManager(_$DbClient db, $SessionTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> token = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> expiryDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> refreshToken = const Value.absent(),
                Value<DateTime> refreshTokenExpiry = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => SessionTableCompanion(
                id: id,
                token: token,
                userId: userId,
                expiryDate: expiryDate,
                createdAt: createdAt,
                refreshToken: refreshToken,
                refreshTokenExpiry: refreshTokenExpiry,
                deletedAt: deletedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String token,
                required String userId,
                required DateTime expiryDate,
                required DateTime createdAt,
                required String refreshToken,
                required DateTime refreshTokenExpiry,
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => SessionTableCompanion.insert(
                id: id,
                token: token,
                userId: userId,
                expiryDate: expiryDate,
                createdAt: createdAt,
                refreshToken: refreshToken,
                refreshTokenExpiry: refreshTokenExpiry,
                deletedAt: deletedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SessionTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: $$SessionTableTableReferences
                                    ._userIdTable(db),
                                referencedColumn: $$SessionTableTableReferences
                                    ._userIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SessionTableTableProcessedTableManager =
    ProcessedTableManager<
      _$DbClient,
      $SessionTableTable,
      SessionEntry,
      $$SessionTableTableFilterComposer,
      $$SessionTableTableOrderingComposer,
      $$SessionTableTableAnnotationComposer,
      $$SessionTableTableCreateCompanionBuilder,
      $$SessionTableTableUpdateCompanionBuilder,
      (SessionEntry, $$SessionTableTableReferences),
      SessionEntry,
      PrefetchHooks Function({bool userId})
    >;
typedef $$MessageTableTableCreateCompanionBuilder =
    MessageTableCompanion Function({
      Value<int> id,
      Value<int?> channelId,
      required int senderId,
      required String content,
      Value<DateTime> createdAt,
    });
typedef $$MessageTableTableUpdateCompanionBuilder =
    MessageTableCompanion Function({
      Value<int> id,
      Value<int?> channelId,
      Value<int> senderId,
      Value<String> content,
      Value<DateTime> createdAt,
    });

final class $$MessageTableTableReferences
    extends BaseReferences<_$DbClient, $MessageTableTable, MessageEntry> {
  $$MessageTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChannelTableTable _channelIdTable(_$DbClient db) =>
      db.channelTable.createAlias(
        $_aliasNameGenerator(db.messageTable.channelId, db.channelTable.id),
      );

  $$ChannelTableTableProcessedTableManager? get channelId {
    final $_column = $_itemColumn<int>('channel_id');
    if ($_column == null) return null;
    final manager = $$ChannelTableTableTableManager(
      $_db,
      $_db.channelTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_channelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MessageTableTableFilterComposer
    extends Composer<_$DbClient, $MessageTableTable> {
  $$MessageTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get senderId => $composableBuilder(
    column: $table.senderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ChannelTableTableFilterComposer get channelId {
    final $$ChannelTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.channelId,
      referencedTable: $db.channelTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChannelTableTableFilterComposer(
            $db: $db,
            $table: $db.channelTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MessageTableTableOrderingComposer
    extends Composer<_$DbClient, $MessageTableTable> {
  $$MessageTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get senderId => $composableBuilder(
    column: $table.senderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChannelTableTableOrderingComposer get channelId {
    final $$ChannelTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.channelId,
      referencedTable: $db.channelTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChannelTableTableOrderingComposer(
            $db: $db,
            $table: $db.channelTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MessageTableTableAnnotationComposer
    extends Composer<_$DbClient, $MessageTableTable> {
  $$MessageTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get senderId =>
      $composableBuilder(column: $table.senderId, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ChannelTableTableAnnotationComposer get channelId {
    final $$ChannelTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.channelId,
      referencedTable: $db.channelTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChannelTableTableAnnotationComposer(
            $db: $db,
            $table: $db.channelTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MessageTableTableTableManager
    extends
        RootTableManager<
          _$DbClient,
          $MessageTableTable,
          MessageEntry,
          $$MessageTableTableFilterComposer,
          $$MessageTableTableOrderingComposer,
          $$MessageTableTableAnnotationComposer,
          $$MessageTableTableCreateCompanionBuilder,
          $$MessageTableTableUpdateCompanionBuilder,
          (MessageEntry, $$MessageTableTableReferences),
          MessageEntry,
          PrefetchHooks Function({bool channelId})
        > {
  $$MessageTableTableTableManager(_$DbClient db, $MessageTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessageTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessageTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessageTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> channelId = const Value.absent(),
                Value<int> senderId = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MessageTableCompanion(
                id: id,
                channelId: channelId,
                senderId: senderId,
                content: content,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> channelId = const Value.absent(),
                required int senderId,
                required String content,
                Value<DateTime> createdAt = const Value.absent(),
              }) => MessageTableCompanion.insert(
                id: id,
                channelId: channelId,
                senderId: senderId,
                content: content,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MessageTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({channelId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (channelId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.channelId,
                                referencedTable: $$MessageTableTableReferences
                                    ._channelIdTable(db),
                                referencedColumn: $$MessageTableTableReferences
                                    ._channelIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MessageTableTableProcessedTableManager =
    ProcessedTableManager<
      _$DbClient,
      $MessageTableTable,
      MessageEntry,
      $$MessageTableTableFilterComposer,
      $$MessageTableTableOrderingComposer,
      $$MessageTableTableAnnotationComposer,
      $$MessageTableTableCreateCompanionBuilder,
      $$MessageTableTableUpdateCompanionBuilder,
      (MessageEntry, $$MessageTableTableReferences),
      MessageEntry,
      PrefetchHooks Function({bool channelId})
    >;

class $DbClientManager {
  final _$DbClient _db;
  $DbClientManager(this._db);
  $$ChannelTableTableTableManager get channelTable =>
      $$ChannelTableTableTableManager(_db, _db.channelTable);
  $$UserTableTableTableManager get userTable =>
      $$UserTableTableTableManager(_db, _db.userTable);
  $$TodoTableTableTableManager get todoTable =>
      $$TodoTableTableTableManager(_db, _db.todoTable);
  $$SessionTableTableTableManager get sessionTable =>
      $$SessionTableTableTableManager(_db, _db.sessionTable);
  $$MessageTableTableTableManager get messageTable =>
      $$MessageTableTableTableManager(_db, _db.messageTable);
}
