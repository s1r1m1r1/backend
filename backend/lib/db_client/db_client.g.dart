// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_client.dart';

// ignore_for_file: type=lint
class $UserTableTable extends UserTable
    with TableInfo<$UserTableTable, UserEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserTableTable(this.attachedDatabase, [this._alias]);
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
        DriftSqlType.int,
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
  final int id;
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
    map['id'] = Variable<int>(id);
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
      id: serializer.fromJson<int>(json['id']),
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
      'id': serializer.toJson<int>(id),
      'email': serializer.toJson<String>(email),
      'password': serializer.toJson<String>(password),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  UserEntry copyWith({
    int? id,
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
  final Value<int> id;
  final Value<String> email;
  final Value<String> password;
  final Value<DateTime> createdAt;
  final Value<DateTime?> deletedAt;
  const UserTableCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.password = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  UserTableCompanion.insert({
    this.id = const Value.absent(),
    required String email,
    required String password,
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  }) : email = Value(email),
       password = Value(password);
  static Insertable<UserEntry> custom({
    Expression<int>? id,
    Expression<String>? email,
    Expression<String>? password,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
      if (createdAt != null) 'created_at': createdAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  UserTableCompanion copyWith({
    Value<int>? id,
    Value<String>? email,
    Value<String>? password,
    Value<DateTime>? createdAt,
    Value<DateTime?>? deletedAt,
  }) {
    return UserTableCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserTableCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt')
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
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
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
        DriftSqlType.int,
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
  final int? userId;
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
      map['user_id'] = Variable<int>(userId);
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
      userId: serializer.fromJson<int?>(json['userId']),
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
      'userId': serializer.toJson<int?>(userId),
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
    Value<int?> userId = const Value.absent(),
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
  final Value<int?> userId;
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
    Expression<int>? userId,
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
    Value<int?>? userId,
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
      map['user_id'] = Variable<int>(userId.value);
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
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
        DriftSqlType.int,
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
  final int userId;
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
    map['user_id'] = Variable<int>(userId);
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
      userId: serializer.fromJson<int>(json['userId']),
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
      'userId': serializer.toJson<int>(userId),
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
    int? userId,
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
  final Value<int> userId;
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
    required int userId,
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
    Expression<int>? userId,
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
    Value<int>? userId,
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
      map['user_id'] = Variable<int>(userId.value);
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

class $ChatRoomTableTable extends ChatRoomTable
    with TableInfo<$ChatRoomTableTable, ChatRoomEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatRoomTableTable(this.attachedDatabase, [this._alias]);
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
      maxTextLength: 100,
    ),
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
  List<GeneratedColumn> get $columns => [id, name, deletedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_room_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatRoomEntry> instance, {
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
  ChatRoomEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatRoomEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $ChatRoomTableTable createAlias(String alias) {
    return $ChatRoomTableTable(attachedDatabase, alias);
  }
}

class ChatRoomEntry extends DataClass implements Insertable<ChatRoomEntry> {
  final int id;
  final String name;
  final DateTime? deletedAt;
  const ChatRoomEntry({required this.id, required this.name, this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  ChatRoomTableCompanion toCompanion(bool nullToAbsent) {
    return ChatRoomTableCompanion(
      id: Value(id),
      name: Value(name),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory ChatRoomEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatRoomEntry(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  ChatRoomEntry copyWith({
    int? id,
    String? name,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => ChatRoomEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  ChatRoomEntry copyWithCompanion(ChatRoomTableCompanion data) {
    return ChatRoomEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatRoomEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatRoomEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.deletedAt == this.deletedAt);
}

class ChatRoomTableCompanion extends UpdateCompanion<ChatRoomEntry> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime?> deletedAt;
  const ChatRoomTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  ChatRoomTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.deletedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<ChatRoomEntry> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  ChatRoomTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime?>? deletedAt,
  }) {
    return ChatRoomTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      deletedAt: deletedAt ?? this.deletedAt,
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
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatRoomTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }
}

class $LetterTableTable extends LetterTable
    with TableInfo<$LetterTableTable, LetterEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LetterTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _chatRoomIdMeta = const VerificationMeta(
    'chatRoomId',
  );
  @override
  late final GeneratedColumn<int> chatRoomId = GeneratedColumn<int>(
    'chat_room_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES chat_room_table (id)',
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
    chatRoomId,
    senderId,
    content,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'letter_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<LetterEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('chat_room_id')) {
      context.handle(
        _chatRoomIdMeta,
        chatRoomId.isAcceptableOrUnknown(
          data['chat_room_id']!,
          _chatRoomIdMeta,
        ),
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
  LetterEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LetterEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      chatRoomId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chat_room_id'],
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
  $LetterTableTable createAlias(String alias) {
    return $LetterTableTable(attachedDatabase, alias);
  }
}

class LetterEntry extends DataClass implements Insertable<LetterEntry> {
  final int id;
  final int? chatRoomId;
  final int senderId;
  final String content;
  final DateTime createdAt;
  const LetterEntry({
    required this.id,
    this.chatRoomId,
    required this.senderId,
    required this.content,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || chatRoomId != null) {
      map['chat_room_id'] = Variable<int>(chatRoomId);
    }
    map['sender_id'] = Variable<int>(senderId);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LetterTableCompanion toCompanion(bool nullToAbsent) {
    return LetterTableCompanion(
      id: Value(id),
      chatRoomId: chatRoomId == null && nullToAbsent
          ? const Value.absent()
          : Value(chatRoomId),
      senderId: Value(senderId),
      content: Value(content),
      createdAt: Value(createdAt),
    );
  }

  factory LetterEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LetterEntry(
      id: serializer.fromJson<int>(json['id']),
      chatRoomId: serializer.fromJson<int?>(json['chatRoomId']),
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
      'chatRoomId': serializer.toJson<int?>(chatRoomId),
      'senderId': serializer.toJson<int>(senderId),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LetterEntry copyWith({
    int? id,
    Value<int?> chatRoomId = const Value.absent(),
    int? senderId,
    String? content,
    DateTime? createdAt,
  }) => LetterEntry(
    id: id ?? this.id,
    chatRoomId: chatRoomId.present ? chatRoomId.value : this.chatRoomId,
    senderId: senderId ?? this.senderId,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
  );
  LetterEntry copyWithCompanion(LetterTableCompanion data) {
    return LetterEntry(
      id: data.id.present ? data.id.value : this.id,
      chatRoomId: data.chatRoomId.present
          ? data.chatRoomId.value
          : this.chatRoomId,
      senderId: data.senderId.present ? data.senderId.value : this.senderId,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LetterEntry(')
          ..write('id: $id, ')
          ..write('chatRoomId: $chatRoomId, ')
          ..write('senderId: $senderId, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, chatRoomId, senderId, content, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LetterEntry &&
          other.id == this.id &&
          other.chatRoomId == this.chatRoomId &&
          other.senderId == this.senderId &&
          other.content == this.content &&
          other.createdAt == this.createdAt);
}

class LetterTableCompanion extends UpdateCompanion<LetterEntry> {
  final Value<int> id;
  final Value<int?> chatRoomId;
  final Value<int> senderId;
  final Value<String> content;
  final Value<DateTime> createdAt;
  const LetterTableCompanion({
    this.id = const Value.absent(),
    this.chatRoomId = const Value.absent(),
    this.senderId = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  LetterTableCompanion.insert({
    this.id = const Value.absent(),
    this.chatRoomId = const Value.absent(),
    required int senderId,
    required String content,
    this.createdAt = const Value.absent(),
  }) : senderId = Value(senderId),
       content = Value(content);
  static Insertable<LetterEntry> custom({
    Expression<int>? id,
    Expression<int>? chatRoomId,
    Expression<int>? senderId,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chatRoomId != null) 'chat_room_id': chatRoomId,
      if (senderId != null) 'sender_id': senderId,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  LetterTableCompanion copyWith({
    Value<int>? id,
    Value<int?>? chatRoomId,
    Value<int>? senderId,
    Value<String>? content,
    Value<DateTime>? createdAt,
  }) {
    return LetterTableCompanion(
      id: id ?? this.id,
      chatRoomId: chatRoomId ?? this.chatRoomId,
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
    if (chatRoomId.present) {
      map['chat_room_id'] = Variable<int>(chatRoomId.value);
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
    return (StringBuffer('LetterTableCompanion(')
          ..write('id: $id, ')
          ..write('chatRoomId: $chatRoomId, ')
          ..write('senderId: $senderId, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ChatMemberTableTable extends ChatMemberTable
    with TableInfo<$ChatMemberTableTable, ChatMemberEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatMemberTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _chatRoomIdMeta = const VerificationMeta(
    'chatRoomId',
  );
  @override
  late final GeneratedColumn<int> chatRoomId = GeneratedColumn<int>(
    'chat_room_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES chat_room_table (id) ON UPDATE CASCADE ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_table (id) ON UPDATE CASCADE ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [chatRoomId, userId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_member_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatMemberEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('chat_room_id')) {
      context.handle(
        _chatRoomIdMeta,
        chatRoomId.isAcceptableOrUnknown(
          data['chat_room_id']!,
          _chatRoomIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_chatRoomIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {chatRoomId, userId};
  @override
  ChatMemberEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatMemberEntry(
      chatRoomId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chat_room_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
    );
  }

  @override
  $ChatMemberTableTable createAlias(String alias) {
    return $ChatMemberTableTable(attachedDatabase, alias);
  }
}

class ChatMemberEntry extends DataClass implements Insertable<ChatMemberEntry> {
  final int chatRoomId;
  final int userId;
  const ChatMemberEntry({required this.chatRoomId, required this.userId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['chat_room_id'] = Variable<int>(chatRoomId);
    map['user_id'] = Variable<int>(userId);
    return map;
  }

  ChatMemberTableCompanion toCompanion(bool nullToAbsent) {
    return ChatMemberTableCompanion(
      chatRoomId: Value(chatRoomId),
      userId: Value(userId),
    );
  }

  factory ChatMemberEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatMemberEntry(
      chatRoomId: serializer.fromJson<int>(json['chatRoomId']),
      userId: serializer.fromJson<int>(json['userId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'chatRoomId': serializer.toJson<int>(chatRoomId),
      'userId': serializer.toJson<int>(userId),
    };
  }

  ChatMemberEntry copyWith({int? chatRoomId, int? userId}) => ChatMemberEntry(
    chatRoomId: chatRoomId ?? this.chatRoomId,
    userId: userId ?? this.userId,
  );
  ChatMemberEntry copyWithCompanion(ChatMemberTableCompanion data) {
    return ChatMemberEntry(
      chatRoomId: data.chatRoomId.present
          ? data.chatRoomId.value
          : this.chatRoomId,
      userId: data.userId.present ? data.userId.value : this.userId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatMemberEntry(')
          ..write('chatRoomId: $chatRoomId, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(chatRoomId, userId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMemberEntry &&
          other.chatRoomId == this.chatRoomId &&
          other.userId == this.userId);
}

class ChatMemberTableCompanion extends UpdateCompanion<ChatMemberEntry> {
  final Value<int> chatRoomId;
  final Value<int> userId;
  final Value<int> rowid;
  const ChatMemberTableCompanion({
    this.chatRoomId = const Value.absent(),
    this.userId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatMemberTableCompanion.insert({
    required int chatRoomId,
    required int userId,
    this.rowid = const Value.absent(),
  }) : chatRoomId = Value(chatRoomId),
       userId = Value(userId);
  static Insertable<ChatMemberEntry> custom({
    Expression<int>? chatRoomId,
    Expression<int>? userId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (chatRoomId != null) 'chat_room_id': chatRoomId,
      if (userId != null) 'user_id': userId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatMemberTableCompanion copyWith({
    Value<int>? chatRoomId,
    Value<int>? userId,
    Value<int>? rowid,
  }) {
    return ChatMemberTableCompanion(
      chatRoomId: chatRoomId ?? this.chatRoomId,
      userId: userId ?? this.userId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (chatRoomId.present) {
      map['chat_room_id'] = Variable<int>(chatRoomId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatMemberTableCompanion(')
          ..write('chatRoomId: $chatRoomId, ')
          ..write('userId: $userId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$DbClient extends GeneratedDatabase {
  _$DbClient(QueryExecutor e) : super(e);
  $DbClientManager get managers => $DbClientManager(this);
  late final $UserTableTable userTable = $UserTableTable(this);
  late final $TodoTableTable todoTable = $TodoTableTable(this);
  late final $SessionTableTable sessionTable = $SessionTableTable(this);
  late final $ChatRoomTableTable chatRoomTable = $ChatRoomTableTable(this);
  late final $LetterTableTable letterTable = $LetterTableTable(this);
  late final $ChatMemberTableTable chatMemberTable = $ChatMemberTableTable(
    this,
  );
  late final TodoDao todoDao = TodoDao(this as DbClient);
  late final UserDao userDao = UserDao(this as DbClient);
  late final SessionDao sessionDao = SessionDao(this as DbClient);
  late final LettersDao lettersDao = LettersDao(this as DbClient);
  late final ChatRoomDao chatRoomDao = ChatRoomDao(this as DbClient);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userTable,
    todoTable,
    sessionTable,
    chatRoomTable,
    letterTable,
    chatMemberTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'chat_room_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('chat_member_table', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'chat_room_table',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('chat_member_table', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'user_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('chat_member_table', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'user_table',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('chat_member_table', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$UserTableTableCreateCompanionBuilder =
    UserTableCompanion Function({
      Value<int> id,
      required String email,
      required String password,
      Value<DateTime> createdAt,
      Value<DateTime?> deletedAt,
    });
typedef $$UserTableTableUpdateCompanionBuilder =
    UserTableCompanion Function({
      Value<int> id,
      Value<String> email,
      Value<String> password,
      Value<DateTime> createdAt,
      Value<DateTime?> deletedAt,
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
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

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
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ChatMemberTableTable, List<ChatMemberEntry>>
  _chatMemberTableRefsTable(_$DbClient db) => MultiTypedResultKey.fromTable(
    db.chatMemberTable,
    aliasName: $_aliasNameGenerator(db.userTable.id, db.chatMemberTable.userId),
  );

  $$ChatMemberTableTableProcessedTableManager get chatMemberTableRefs {
    final manager = $$ChatMemberTableTableTableManager(
      $_db,
      $_db.chatMemberTable,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _chatMemberTableRefsTable($_db),
    );
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
  ColumnFilters<int> get id => $composableBuilder(
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

  Expression<bool> chatMemberTableRefs(
    Expression<bool> Function($$ChatMemberTableTableFilterComposer f) f,
  ) {
    final $$ChatMemberTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chatMemberTable,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatMemberTableTableFilterComposer(
            $db: $db,
            $table: $db.chatMemberTable,
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
  ColumnOrderings<int> get id => $composableBuilder(
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
  GeneratedColumn<int> get id =>
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

  Expression<T> chatMemberTableRefs<T extends Object>(
    Expression<T> Function($$ChatMemberTableTableAnnotationComposer a) f,
  ) {
    final $$ChatMemberTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chatMemberTable,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatMemberTableTableAnnotationComposer(
            $db: $db,
            $table: $db.chatMemberTable,
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
          PrefetchHooks Function({
            bool todoTableRefs,
            bool sessionTableRefs,
            bool chatMemberTableRefs,
          })
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
                Value<int> id = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> password = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => UserTableCompanion(
                id: id,
                email: email,
                password: password,
                createdAt: createdAt,
                deletedAt: deletedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String email,
                required String password,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => UserTableCompanion.insert(
                id: id,
                email: email,
                password: password,
                createdAt: createdAt,
                deletedAt: deletedAt,
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
              ({
                todoTableRefs = false,
                sessionTableRefs = false,
                chatMemberTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (todoTableRefs) db.todoTable,
                    if (sessionTableRefs) db.sessionTable,
                    if (chatMemberTableRefs) db.chatMemberTable,
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
                      if (chatMemberTableRefs)
                        await $_getPrefetchedData<
                          UserEntry,
                          $UserTableTable,
                          ChatMemberEntry
                        >(
                          currentTable: table,
                          referencedTable: $$UserTableTableReferences
                              ._chatMemberTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UserTableTableReferences(
                                db,
                                table,
                                p0,
                              ).chatMemberTableRefs,
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
      PrefetchHooks Function({
        bool todoTableRefs,
        bool sessionTableRefs,
        bool chatMemberTableRefs,
      })
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
      Value<int?> userId,
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
      Value<int?> userId,
    });

final class $$TodoTableTableReferences
    extends BaseReferences<_$DbClient, $TodoTableTable, TodoEntry> {
  $$TodoTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UserTableTable _userIdTable(_$DbClient db) => db.userTable
      .createAlias($_aliasNameGenerator(db.todoTable.userId, db.userTable.id));

  $$UserTableTableProcessedTableManager? get userId {
    final $_column = $_itemColumn<int>('user_id');
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
                Value<int?> userId = const Value.absent(),
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
                Value<int?> userId = const Value.absent(),
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
      required int userId,
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
      Value<int> userId,
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
    final $_column = $_itemColumn<int>('user_id')!;

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
                Value<int> userId = const Value.absent(),
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
                required int userId,
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
typedef $$ChatRoomTableTableCreateCompanionBuilder =
    ChatRoomTableCompanion Function({
      Value<int> id,
      required String name,
      Value<DateTime?> deletedAt,
    });
typedef $$ChatRoomTableTableUpdateCompanionBuilder =
    ChatRoomTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime?> deletedAt,
    });

final class $$ChatRoomTableTableReferences
    extends BaseReferences<_$DbClient, $ChatRoomTableTable, ChatRoomEntry> {
  $$ChatRoomTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$LetterTableTable, List<LetterEntry>>
  _letterTableRefsTable(_$DbClient db) => MultiTypedResultKey.fromTable(
    db.letterTable,
    aliasName: $_aliasNameGenerator(
      db.chatRoomTable.id,
      db.letterTable.chatRoomId,
    ),
  );

  $$LetterTableTableProcessedTableManager get letterTableRefs {
    final manager = $$LetterTableTableTableManager(
      $_db,
      $_db.letterTable,
    ).filter((f) => f.chatRoomId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_letterTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ChatMemberTableTable, List<ChatMemberEntry>>
  _chatMemberTableRefsTable(_$DbClient db) => MultiTypedResultKey.fromTable(
    db.chatMemberTable,
    aliasName: $_aliasNameGenerator(
      db.chatRoomTable.id,
      db.chatMemberTable.chatRoomId,
    ),
  );

  $$ChatMemberTableTableProcessedTableManager get chatMemberTableRefs {
    final manager = $$ChatMemberTableTableTableManager(
      $_db,
      $_db.chatMemberTable,
    ).filter((f) => f.chatRoomId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _chatMemberTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ChatRoomTableTableFilterComposer
    extends Composer<_$DbClient, $ChatRoomTableTable> {
  $$ChatRoomTableTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> letterTableRefs(
    Expression<bool> Function($$LetterTableTableFilterComposer f) f,
  ) {
    final $$LetterTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.letterTable,
      getReferencedColumn: (t) => t.chatRoomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LetterTableTableFilterComposer(
            $db: $db,
            $table: $db.letterTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> chatMemberTableRefs(
    Expression<bool> Function($$ChatMemberTableTableFilterComposer f) f,
  ) {
    final $$ChatMemberTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chatMemberTable,
      getReferencedColumn: (t) => t.chatRoomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatMemberTableTableFilterComposer(
            $db: $db,
            $table: $db.chatMemberTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChatRoomTableTableOrderingComposer
    extends Composer<_$DbClient, $ChatRoomTableTable> {
  $$ChatRoomTableTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChatRoomTableTableAnnotationComposer
    extends Composer<_$DbClient, $ChatRoomTableTable> {
  $$ChatRoomTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  Expression<T> letterTableRefs<T extends Object>(
    Expression<T> Function($$LetterTableTableAnnotationComposer a) f,
  ) {
    final $$LetterTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.letterTable,
      getReferencedColumn: (t) => t.chatRoomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LetterTableTableAnnotationComposer(
            $db: $db,
            $table: $db.letterTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> chatMemberTableRefs<T extends Object>(
    Expression<T> Function($$ChatMemberTableTableAnnotationComposer a) f,
  ) {
    final $$ChatMemberTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chatMemberTable,
      getReferencedColumn: (t) => t.chatRoomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatMemberTableTableAnnotationComposer(
            $db: $db,
            $table: $db.chatMemberTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChatRoomTableTableTableManager
    extends
        RootTableManager<
          _$DbClient,
          $ChatRoomTableTable,
          ChatRoomEntry,
          $$ChatRoomTableTableFilterComposer,
          $$ChatRoomTableTableOrderingComposer,
          $$ChatRoomTableTableAnnotationComposer,
          $$ChatRoomTableTableCreateCompanionBuilder,
          $$ChatRoomTableTableUpdateCompanionBuilder,
          (ChatRoomEntry, $$ChatRoomTableTableReferences),
          ChatRoomEntry,
          PrefetchHooks Function({
            bool letterTableRefs,
            bool chatMemberTableRefs,
          })
        > {
  $$ChatRoomTableTableTableManager(_$DbClient db, $ChatRoomTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatRoomTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatRoomTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatRoomTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => ChatRoomTableCompanion(
                id: id,
                name: name,
                deletedAt: deletedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => ChatRoomTableCompanion.insert(
                id: id,
                name: name,
                deletedAt: deletedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChatRoomTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({letterTableRefs = false, chatMemberTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (letterTableRefs) db.letterTable,
                    if (chatMemberTableRefs) db.chatMemberTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (letterTableRefs)
                        await $_getPrefetchedData<
                          ChatRoomEntry,
                          $ChatRoomTableTable,
                          LetterEntry
                        >(
                          currentTable: table,
                          referencedTable: $$ChatRoomTableTableReferences
                              ._letterTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChatRoomTableTableReferences(
                                db,
                                table,
                                p0,
                              ).letterTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.chatRoomId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (chatMemberTableRefs)
                        await $_getPrefetchedData<
                          ChatRoomEntry,
                          $ChatRoomTableTable,
                          ChatMemberEntry
                        >(
                          currentTable: table,
                          referencedTable: $$ChatRoomTableTableReferences
                              ._chatMemberTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChatRoomTableTableReferences(
                                db,
                                table,
                                p0,
                              ).chatMemberTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.chatRoomId == item.id,
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

typedef $$ChatRoomTableTableProcessedTableManager =
    ProcessedTableManager<
      _$DbClient,
      $ChatRoomTableTable,
      ChatRoomEntry,
      $$ChatRoomTableTableFilterComposer,
      $$ChatRoomTableTableOrderingComposer,
      $$ChatRoomTableTableAnnotationComposer,
      $$ChatRoomTableTableCreateCompanionBuilder,
      $$ChatRoomTableTableUpdateCompanionBuilder,
      (ChatRoomEntry, $$ChatRoomTableTableReferences),
      ChatRoomEntry,
      PrefetchHooks Function({bool letterTableRefs, bool chatMemberTableRefs})
    >;
typedef $$LetterTableTableCreateCompanionBuilder =
    LetterTableCompanion Function({
      Value<int> id,
      Value<int?> chatRoomId,
      required int senderId,
      required String content,
      Value<DateTime> createdAt,
    });
typedef $$LetterTableTableUpdateCompanionBuilder =
    LetterTableCompanion Function({
      Value<int> id,
      Value<int?> chatRoomId,
      Value<int> senderId,
      Value<String> content,
      Value<DateTime> createdAt,
    });

final class $$LetterTableTableReferences
    extends BaseReferences<_$DbClient, $LetterTableTable, LetterEntry> {
  $$LetterTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChatRoomTableTable _chatRoomIdTable(_$DbClient db) =>
      db.chatRoomTable.createAlias(
        $_aliasNameGenerator(db.letterTable.chatRoomId, db.chatRoomTable.id),
      );

  $$ChatRoomTableTableProcessedTableManager? get chatRoomId {
    final $_column = $_itemColumn<int>('chat_room_id');
    if ($_column == null) return null;
    final manager = $$ChatRoomTableTableTableManager(
      $_db,
      $_db.chatRoomTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chatRoomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LetterTableTableFilterComposer
    extends Composer<_$DbClient, $LetterTableTable> {
  $$LetterTableTableFilterComposer({
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

  $$ChatRoomTableTableFilterComposer get chatRoomId {
    final $$ChatRoomTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chatRoomId,
      referencedTable: $db.chatRoomTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatRoomTableTableFilterComposer(
            $db: $db,
            $table: $db.chatRoomTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LetterTableTableOrderingComposer
    extends Composer<_$DbClient, $LetterTableTable> {
  $$LetterTableTableOrderingComposer({
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

  $$ChatRoomTableTableOrderingComposer get chatRoomId {
    final $$ChatRoomTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chatRoomId,
      referencedTable: $db.chatRoomTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatRoomTableTableOrderingComposer(
            $db: $db,
            $table: $db.chatRoomTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LetterTableTableAnnotationComposer
    extends Composer<_$DbClient, $LetterTableTable> {
  $$LetterTableTableAnnotationComposer({
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

  $$ChatRoomTableTableAnnotationComposer get chatRoomId {
    final $$ChatRoomTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chatRoomId,
      referencedTable: $db.chatRoomTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatRoomTableTableAnnotationComposer(
            $db: $db,
            $table: $db.chatRoomTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LetterTableTableTableManager
    extends
        RootTableManager<
          _$DbClient,
          $LetterTableTable,
          LetterEntry,
          $$LetterTableTableFilterComposer,
          $$LetterTableTableOrderingComposer,
          $$LetterTableTableAnnotationComposer,
          $$LetterTableTableCreateCompanionBuilder,
          $$LetterTableTableUpdateCompanionBuilder,
          (LetterEntry, $$LetterTableTableReferences),
          LetterEntry,
          PrefetchHooks Function({bool chatRoomId})
        > {
  $$LetterTableTableTableManager(_$DbClient db, $LetterTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LetterTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LetterTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LetterTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> chatRoomId = const Value.absent(),
                Value<int> senderId = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => LetterTableCompanion(
                id: id,
                chatRoomId: chatRoomId,
                senderId: senderId,
                content: content,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> chatRoomId = const Value.absent(),
                required int senderId,
                required String content,
                Value<DateTime> createdAt = const Value.absent(),
              }) => LetterTableCompanion.insert(
                id: id,
                chatRoomId: chatRoomId,
                senderId: senderId,
                content: content,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LetterTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({chatRoomId = false}) {
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
                    if (chatRoomId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.chatRoomId,
                                referencedTable: $$LetterTableTableReferences
                                    ._chatRoomIdTable(db),
                                referencedColumn: $$LetterTableTableReferences
                                    ._chatRoomIdTable(db)
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

typedef $$LetterTableTableProcessedTableManager =
    ProcessedTableManager<
      _$DbClient,
      $LetterTableTable,
      LetterEntry,
      $$LetterTableTableFilterComposer,
      $$LetterTableTableOrderingComposer,
      $$LetterTableTableAnnotationComposer,
      $$LetterTableTableCreateCompanionBuilder,
      $$LetterTableTableUpdateCompanionBuilder,
      (LetterEntry, $$LetterTableTableReferences),
      LetterEntry,
      PrefetchHooks Function({bool chatRoomId})
    >;
typedef $$ChatMemberTableTableCreateCompanionBuilder =
    ChatMemberTableCompanion Function({
      required int chatRoomId,
      required int userId,
      Value<int> rowid,
    });
typedef $$ChatMemberTableTableUpdateCompanionBuilder =
    ChatMemberTableCompanion Function({
      Value<int> chatRoomId,
      Value<int> userId,
      Value<int> rowid,
    });

final class $$ChatMemberTableTableReferences
    extends BaseReferences<_$DbClient, $ChatMemberTableTable, ChatMemberEntry> {
  $$ChatMemberTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ChatRoomTableTable _chatRoomIdTable(_$DbClient db) =>
      db.chatRoomTable.createAlias(
        $_aliasNameGenerator(
          db.chatMemberTable.chatRoomId,
          db.chatRoomTable.id,
        ),
      );

  $$ChatRoomTableTableProcessedTableManager get chatRoomId {
    final $_column = $_itemColumn<int>('chat_room_id')!;

    final manager = $$ChatRoomTableTableTableManager(
      $_db,
      $_db.chatRoomTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chatRoomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UserTableTable _userIdTable(_$DbClient db) =>
      db.userTable.createAlias(
        $_aliasNameGenerator(db.chatMemberTable.userId, db.userTable.id),
      );

  $$UserTableTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

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

class $$ChatMemberTableTableFilterComposer
    extends Composer<_$DbClient, $ChatMemberTableTable> {
  $$ChatMemberTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ChatRoomTableTableFilterComposer get chatRoomId {
    final $$ChatRoomTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chatRoomId,
      referencedTable: $db.chatRoomTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatRoomTableTableFilterComposer(
            $db: $db,
            $table: $db.chatRoomTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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

class $$ChatMemberTableTableOrderingComposer
    extends Composer<_$DbClient, $ChatMemberTableTable> {
  $$ChatMemberTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ChatRoomTableTableOrderingComposer get chatRoomId {
    final $$ChatRoomTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chatRoomId,
      referencedTable: $db.chatRoomTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatRoomTableTableOrderingComposer(
            $db: $db,
            $table: $db.chatRoomTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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

class $$ChatMemberTableTableAnnotationComposer
    extends Composer<_$DbClient, $ChatMemberTableTable> {
  $$ChatMemberTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ChatRoomTableTableAnnotationComposer get chatRoomId {
    final $$ChatRoomTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chatRoomId,
      referencedTable: $db.chatRoomTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatRoomTableTableAnnotationComposer(
            $db: $db,
            $table: $db.chatRoomTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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

class $$ChatMemberTableTableTableManager
    extends
        RootTableManager<
          _$DbClient,
          $ChatMemberTableTable,
          ChatMemberEntry,
          $$ChatMemberTableTableFilterComposer,
          $$ChatMemberTableTableOrderingComposer,
          $$ChatMemberTableTableAnnotationComposer,
          $$ChatMemberTableTableCreateCompanionBuilder,
          $$ChatMemberTableTableUpdateCompanionBuilder,
          (ChatMemberEntry, $$ChatMemberTableTableReferences),
          ChatMemberEntry,
          PrefetchHooks Function({bool chatRoomId, bool userId})
        > {
  $$ChatMemberTableTableTableManager(_$DbClient db, $ChatMemberTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatMemberTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatMemberTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatMemberTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> chatRoomId = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChatMemberTableCompanion(
                chatRoomId: chatRoomId,
                userId: userId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int chatRoomId,
                required int userId,
                Value<int> rowid = const Value.absent(),
              }) => ChatMemberTableCompanion.insert(
                chatRoomId: chatRoomId,
                userId: userId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChatMemberTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({chatRoomId = false, userId = false}) {
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
                    if (chatRoomId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.chatRoomId,
                                referencedTable:
                                    $$ChatMemberTableTableReferences
                                        ._chatRoomIdTable(db),
                                referencedColumn:
                                    $$ChatMemberTableTableReferences
                                        ._chatRoomIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable:
                                    $$ChatMemberTableTableReferences
                                        ._userIdTable(db),
                                referencedColumn:
                                    $$ChatMemberTableTableReferences
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

typedef $$ChatMemberTableTableProcessedTableManager =
    ProcessedTableManager<
      _$DbClient,
      $ChatMemberTableTable,
      ChatMemberEntry,
      $$ChatMemberTableTableFilterComposer,
      $$ChatMemberTableTableOrderingComposer,
      $$ChatMemberTableTableAnnotationComposer,
      $$ChatMemberTableTableCreateCompanionBuilder,
      $$ChatMemberTableTableUpdateCompanionBuilder,
      (ChatMemberEntry, $$ChatMemberTableTableReferences),
      ChatMemberEntry,
      PrefetchHooks Function({bool chatRoomId, bool userId})
    >;

class $DbClientManager {
  final _$DbClient _db;
  $DbClientManager(this._db);
  $$UserTableTableTableManager get userTable =>
      $$UserTableTableTableManager(_db, _db.userTable);
  $$TodoTableTableTableManager get todoTable =>
      $$TodoTableTableTableManager(_db, _db.todoTable);
  $$SessionTableTableTableManager get sessionTable =>
      $$SessionTableTableTableManager(_db, _db.sessionTable);
  $$ChatRoomTableTableTableManager get chatRoomTable =>
      $$ChatRoomTableTableTableManager(_db, _db.chatRoomTable);
  $$LetterTableTableTableManager get letterTable =>
      $$LetterTableTableTableManager(_db, _db.letterTable);
  $$ChatMemberTableTableTableManager get chatMemberTable =>
      $$ChatMemberTableTableTableManager(_db, _db.chatMemberTable);
}
