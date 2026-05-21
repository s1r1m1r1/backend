// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_client.dart';

// ignore_for_file: type=lint
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
    clientDefault: () => const Uuid().v7(),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 6,
      maxTextLength: 254,
    ),
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
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 28),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Role, String> role =
      GeneratedColumn<String>(
        'role',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('user'),
      ).withConverter<Role>($UserTableTable.$converterrole);
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
  static const VerificationMeta _emailVerifiedMeta = const VerificationMeta(
    'emailVerified',
  );
  @override
  late final GeneratedColumn<bool> emailVerified = GeneratedColumn<bool>(
    'email_verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("email_verified" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _confirmationTokenMeta = const VerificationMeta(
    'confirmationToken',
  );
  @override
  late final GeneratedColumn<String> confirmationToken =
      GeneratedColumn<String>(
        'confirmation_token',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    email,
    password,
    role,
    createdAt,
    deletedAt,
    emailVerified,
    confirmationToken,
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
    if (data.containsKey('email_verified')) {
      context.handle(
        _emailVerifiedMeta,
        emailVerified.isAcceptableOrUnknown(
          data['email_verified']!,
          _emailVerifiedMeta,
        ),
      );
    }
    if (data.containsKey('confirmation_token')) {
      context.handle(
        _confirmationTokenMeta,
        confirmationToken.isAcceptableOrUnknown(
          data['confirmation_token']!,
          _confirmationTokenMeta,
        ),
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
      role: $UserTableTable.$converterrole.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}role'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      emailVerified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}email_verified'],
      )!,
      confirmationToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confirmation_token'],
      ),
    );
  }

  @override
  $UserTableTable createAlias(String alias) {
    return $UserTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Role, String, String> $converterrole =
      const EnumNameConverter<Role>(Role.values);
}

class UserEntry extends DataClass implements Insertable<UserEntry> {
  final String id;
  final String email;
  final String password;
  final Role role;
  final DateTime createdAt;
  final DateTime? deletedAt;
  final bool emailVerified;
  final String? confirmationToken;
  const UserEntry({
    required this.id,
    required this.email,
    required this.password,
    required this.role,
    required this.createdAt,
    this.deletedAt,
    required this.emailVerified,
    this.confirmationToken,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['email'] = Variable<String>(email);
    map['password'] = Variable<String>(password);
    {
      map['role'] = Variable<String>(
        $UserTableTable.$converterrole.toSql(role),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['email_verified'] = Variable<bool>(emailVerified);
    if (!nullToAbsent || confirmationToken != null) {
      map['confirmation_token'] = Variable<String>(confirmationToken);
    }
    return map;
  }

  UserTableCompanion toCompanion(bool nullToAbsent) {
    return UserTableCompanion(
      id: Value(id),
      email: Value(email),
      password: Value(password),
      role: Value(role),
      createdAt: Value(createdAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      emailVerified: Value(emailVerified),
      confirmationToken: confirmationToken == null && nullToAbsent
          ? const Value.absent()
          : Value(confirmationToken),
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
      role: $UserTableTable.$converterrole.fromJson(
        serializer.fromJson<String>(json['role']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      emailVerified: serializer.fromJson<bool>(json['emailVerified']),
      confirmationToken: serializer.fromJson<String?>(
        json['confirmationToken'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'email': serializer.toJson<String>(email),
      'password': serializer.toJson<String>(password),
      'role': serializer.toJson<String>(
        $UserTableTable.$converterrole.toJson(role),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'emailVerified': serializer.toJson<bool>(emailVerified),
      'confirmationToken': serializer.toJson<String?>(confirmationToken),
    };
  }

  UserEntry copyWith({
    String? id,
    String? email,
    String? password,
    Role? role,
    DateTime? createdAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    bool? emailVerified,
    Value<String?> confirmationToken = const Value.absent(),
  }) => UserEntry(
    id: id ?? this.id,
    email: email ?? this.email,
    password: password ?? this.password,
    role: role ?? this.role,
    createdAt: createdAt ?? this.createdAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    emailVerified: emailVerified ?? this.emailVerified,
    confirmationToken: confirmationToken.present
        ? confirmationToken.value
        : this.confirmationToken,
  );
  UserEntry copyWithCompanion(UserTableCompanion data) {
    return UserEntry(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      password: data.password.present ? data.password.value : this.password,
      role: data.role.present ? data.role.value : this.role,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      emailVerified: data.emailVerified.present
          ? data.emailVerified.value
          : this.emailVerified,
      confirmationToken: data.confirmationToken.present
          ? data.confirmationToken.value
          : this.confirmationToken,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserEntry(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('emailVerified: $emailVerified, ')
          ..write('confirmationToken: $confirmationToken')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    email,
    password,
    role,
    createdAt,
    deletedAt,
    emailVerified,
    confirmationToken,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserEntry &&
          other.id == this.id &&
          other.email == this.email &&
          other.password == this.password &&
          other.role == this.role &&
          other.createdAt == this.createdAt &&
          other.deletedAt == this.deletedAt &&
          other.emailVerified == this.emailVerified &&
          other.confirmationToken == this.confirmationToken);
}

class UserTableCompanion extends UpdateCompanion<UserEntry> {
  final Value<String> id;
  final Value<String> email;
  final Value<String> password;
  final Value<Role> role;
  final Value<DateTime> createdAt;
  final Value<DateTime?> deletedAt;
  final Value<bool> emailVerified;
  final Value<String?> confirmationToken;
  final Value<int> rowid;
  const UserTableCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.password = const Value.absent(),
    this.role = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.emailVerified = const Value.absent(),
    this.confirmationToken = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserTableCompanion.insert({
    this.id = const Value.absent(),
    required String email,
    required String password,
    this.role = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.emailVerified = const Value.absent(),
    this.confirmationToken = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : email = Value(email),
       password = Value(password);
  static Insertable<UserEntry> custom({
    Expression<String>? id,
    Expression<String>? email,
    Expression<String>? password,
    Expression<String>? role,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? deletedAt,
    Expression<bool>? emailVerified,
    Expression<String>? confirmationToken,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
      if (role != null) 'role': role,
      if (createdAt != null) 'created_at': createdAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (emailVerified != null) 'email_verified': emailVerified,
      if (confirmationToken != null) 'confirmation_token': confirmationToken,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserTableCompanion copyWith({
    Value<String>? id,
    Value<String>? email,
    Value<String>? password,
    Value<Role>? role,
    Value<DateTime>? createdAt,
    Value<DateTime?>? deletedAt,
    Value<bool>? emailVerified,
    Value<String?>? confirmationToken,
    Value<int>? rowid,
  }) {
    return UserTableCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      emailVerified: emailVerified ?? this.emailVerified,
      confirmationToken: confirmationToken ?? this.confirmationToken,
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
    if (role.present) {
      map['role'] = Variable<String>(
        $UserTableTable.$converterrole.toSql(role.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (emailVerified.present) {
      map['email_verified'] = Variable<bool>(emailVerified.value);
    }
    if (confirmationToken.present) {
      map['confirmation_token'] = Variable<String>(confirmationToken.value);
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
          ..write('role: $role, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('emailVerified: $emailVerified, ')
          ..write('confirmationToken: $confirmationToken, ')
          ..write('rowid: $rowid')
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
  late final GeneratedColumn<String> chatRoomId = GeneratedColumn<String>(
    'chat_room_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _senderIdMeta = const VerificationMeta(
    'senderId',
  );
  @override
  late final GeneratedColumn<String> senderId = GeneratedColumn<String>(
    'sender_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
    } else if (isInserting) {
      context.missing(_chatRoomIdMeta);
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
        DriftSqlType.string,
        data['${effectivePrefix}chat_room_id'],
      )!,
      senderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
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
  final String chatRoomId;
  final String senderId;
  final String content;
  final DateTime createdAt;
  const LetterEntry({
    required this.id,
    required this.chatRoomId,
    required this.senderId,
    required this.content,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['chat_room_id'] = Variable<String>(chatRoomId);
    map['sender_id'] = Variable<String>(senderId);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LetterTableCompanion toCompanion(bool nullToAbsent) {
    return LetterTableCompanion(
      id: Value(id),
      chatRoomId: Value(chatRoomId),
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
      chatRoomId: serializer.fromJson<String>(json['chatRoomId']),
      senderId: serializer.fromJson<String>(json['senderId']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'chatRoomId': serializer.toJson<String>(chatRoomId),
      'senderId': serializer.toJson<String>(senderId),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LetterEntry copyWith({
    int? id,
    String? chatRoomId,
    String? senderId,
    String? content,
    DateTime? createdAt,
  }) => LetterEntry(
    id: id ?? this.id,
    chatRoomId: chatRoomId ?? this.chatRoomId,
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
  final Value<String> chatRoomId;
  final Value<String> senderId;
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
    required String chatRoomId,
    required String senderId,
    required String content,
    this.createdAt = const Value.absent(),
  }) : chatRoomId = Value(chatRoomId),
       senderId = Value(senderId),
       content = Value(content);
  static Insertable<LetterEntry> custom({
    Expression<int>? id,
    Expression<String>? chatRoomId,
    Expression<String>? senderId,
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
    Value<String>? chatRoomId,
    Value<String>? senderId,
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
      map['chat_room_id'] = Variable<String>(chatRoomId.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<String>(senderId.value);
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

class $RoomTableTable extends RoomTable
    with TableInfo<$RoomTableTable, RoomEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoomTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const String $name = 'room_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoomEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
  RoomEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoomEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
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
  $RoomTableTable createAlias(String alias) {
    return $RoomTableTable(attachedDatabase, alias);
  }
}

class RoomEntry extends DataClass implements Insertable<RoomEntry> {
  final String id;
  final String name;
  final DateTime? deletedAt;
  const RoomEntry({required this.id, required this.name, this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  RoomTableCompanion toCompanion(bool nullToAbsent) {
    return RoomTableCompanion(
      id: Value(id),
      name: Value(name),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory RoomEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoomEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  RoomEntry copyWith({
    String? id,
    String? name,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => RoomEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  RoomEntry copyWithCompanion(RoomTableCompanion data) {
    return RoomEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoomEntry(')
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
      (other is RoomEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.deletedAt == this.deletedAt);
}

class RoomTableCompanion extends UpdateCompanion<RoomEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const RoomTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoomTableCompanion.insert({
    required String id,
    required String name,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<RoomEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoomTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return RoomTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
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
    return (StringBuffer('RoomTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoomMemberTableTable extends RoomMemberTable
    with TableInfo<$RoomMemberTableTable, RoomMemberEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoomMemberTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _chatRoomIdMeta = const VerificationMeta(
    'chatRoomId',
  );
  @override
  late final GeneratedColumn<String> chatRoomId = GeneratedColumn<String>(
    'chat_room_id',
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
  );
  @override
  List<GeneratedColumn> get $columns => [chatRoomId, userId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'room_member_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoomMemberEntry> instance, {
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
  RoomMemberEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoomMemberEntry(
      chatRoomId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chat_room_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
    );
  }

  @override
  $RoomMemberTableTable createAlias(String alias) {
    return $RoomMemberTableTable(attachedDatabase, alias);
  }
}

class RoomMemberEntry extends DataClass implements Insertable<RoomMemberEntry> {
  final String chatRoomId;
  final String userId;
  const RoomMemberEntry({required this.chatRoomId, required this.userId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['chat_room_id'] = Variable<String>(chatRoomId);
    map['user_id'] = Variable<String>(userId);
    return map;
  }

  RoomMemberTableCompanion toCompanion(bool nullToAbsent) {
    return RoomMemberTableCompanion(
      chatRoomId: Value(chatRoomId),
      userId: Value(userId),
    );
  }

  factory RoomMemberEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoomMemberEntry(
      chatRoomId: serializer.fromJson<String>(json['chatRoomId']),
      userId: serializer.fromJson<String>(json['userId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'chatRoomId': serializer.toJson<String>(chatRoomId),
      'userId': serializer.toJson<String>(userId),
    };
  }

  RoomMemberEntry copyWith({String? chatRoomId, String? userId}) =>
      RoomMemberEntry(
        chatRoomId: chatRoomId ?? this.chatRoomId,
        userId: userId ?? this.userId,
      );
  RoomMemberEntry copyWithCompanion(RoomMemberTableCompanion data) {
    return RoomMemberEntry(
      chatRoomId: data.chatRoomId.present
          ? data.chatRoomId.value
          : this.chatRoomId,
      userId: data.userId.present ? data.userId.value : this.userId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoomMemberEntry(')
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
      (other is RoomMemberEntry &&
          other.chatRoomId == this.chatRoomId &&
          other.userId == this.userId);
}

class RoomMemberTableCompanion extends UpdateCompanion<RoomMemberEntry> {
  final Value<String> chatRoomId;
  final Value<String> userId;
  final Value<int> rowid;
  const RoomMemberTableCompanion({
    this.chatRoomId = const Value.absent(),
    this.userId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoomMemberTableCompanion.insert({
    required String chatRoomId,
    required String userId,
    this.rowid = const Value.absent(),
  }) : chatRoomId = Value(chatRoomId),
       userId = Value(userId);
  static Insertable<RoomMemberEntry> custom({
    Expression<String>? chatRoomId,
    Expression<String>? userId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (chatRoomId != null) 'chat_room_id': chatRoomId,
      if (userId != null) 'user_id': userId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoomMemberTableCompanion copyWith({
    Value<String>? chatRoomId,
    Value<String>? userId,
    Value<int>? rowid,
  }) {
    return RoomMemberTableCompanion(
      chatRoomId: chatRoomId ?? this.chatRoomId,
      userId: userId ?? this.userId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (chatRoomId.present) {
      map['chat_room_id'] = Variable<String>(chatRoomId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoomMemberTableCompanion(')
          ..write('chatRoomId: $chatRoomId, ')
          ..write('userId: $userId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CharacterTableTable extends CharacterTable
    with TableInfo<$CharacterTableTable, CharacterEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharacterTableTable(this.attachedDatabase, [this._alias]);
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
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atkMeta = const VerificationMeta('atk');
  @override
  late final GeneratedColumn<int> atk = GeneratedColumn<int>(
    'atk',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defMeta = const VerificationMeta('def');
  @override
  late final GeneratedColumn<int> def = GeneratedColumn<int>(
    'def',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mindMeta = const VerificationMeta('mind');
  @override
  late final GeneratedColumn<int> mind = GeneratedColumn<int>(
    'mind',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resistanceMeta = const VerificationMeta(
    'resistance',
  );
  @override
  late final GeneratedColumn<int> resistance = GeneratedColumn<int>(
    'resistance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vitalityMeta = const VerificationMeta(
    'vitality',
  );
  @override
  late final GeneratedColumn<int> vitality = GeneratedColumn<int>(
    'vitality',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _criticalChanceMeta = const VerificationMeta(
    'criticalChance',
  );
  @override
  late final GeneratedColumn<double> criticalChance = GeneratedColumn<double>(
    'critical_chance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _criticalDamageMeta = const VerificationMeta(
    'criticalDamage',
  );
  @override
  late final GeneratedColumn<double> criticalDamage = GeneratedColumn<double>(
    'critical_damage',
    aliasedName,
    false,
    type: DriftSqlType.double,
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
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
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
    name,
    atk,
    def,
    mind,
    resistance,
    vitality,
    criticalChance,
    criticalDamage,
    userId,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'character_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CharacterEntry> instance, {
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
    if (data.containsKey('atk')) {
      context.handle(
        _atkMeta,
        atk.isAcceptableOrUnknown(data['atk']!, _atkMeta),
      );
    } else if (isInserting) {
      context.missing(_atkMeta);
    }
    if (data.containsKey('def')) {
      context.handle(
        _defMeta,
        def.isAcceptableOrUnknown(data['def']!, _defMeta),
      );
    } else if (isInserting) {
      context.missing(_defMeta);
    }
    if (data.containsKey('mind')) {
      context.handle(
        _mindMeta,
        mind.isAcceptableOrUnknown(data['mind']!, _mindMeta),
      );
    } else if (isInserting) {
      context.missing(_mindMeta);
    }
    if (data.containsKey('resistance')) {
      context.handle(
        _resistanceMeta,
        resistance.isAcceptableOrUnknown(data['resistance']!, _resistanceMeta),
      );
    } else if (isInserting) {
      context.missing(_resistanceMeta);
    }
    if (data.containsKey('vitality')) {
      context.handle(
        _vitalityMeta,
        vitality.isAcceptableOrUnknown(data['vitality']!, _vitalityMeta),
      );
    } else if (isInserting) {
      context.missing(_vitalityMeta);
    }
    if (data.containsKey('critical_chance')) {
      context.handle(
        _criticalChanceMeta,
        criticalChance.isAcceptableOrUnknown(
          data['critical_chance']!,
          _criticalChanceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_criticalChanceMeta);
    }
    if (data.containsKey('critical_damage')) {
      context.handle(
        _criticalDamageMeta,
        criticalDamage.isAcceptableOrUnknown(
          data['critical_damage']!,
          _criticalDamageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_criticalDamageMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CharacterEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CharacterEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      atk: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}atk'],
      )!,
      def: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}def'],
      )!,
      mind: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mind'],
      )!,
      resistance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}resistance'],
      )!,
      vitality: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vitality'],
      )!,
      criticalChance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}critical_chance'],
      )!,
      criticalDamage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}critical_damage'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $CharacterTableTable createAlias(String alias) {
    return $CharacterTableTable(attachedDatabase, alias);
  }
}

class CharacterEntry extends DataClass implements Insertable<CharacterEntry> {
  final int id;
  final String name;
  final int atk;
  final int def;
  final int mind;
  final int resistance;
  final int vitality;
  final double criticalChance;
  final double criticalDamage;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const CharacterEntry({
    required this.id,
    required this.name,
    required this.atk,
    required this.def,
    required this.mind,
    required this.resistance,
    required this.vitality,
    required this.criticalChance,
    required this.criticalDamage,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['atk'] = Variable<int>(atk);
    map['def'] = Variable<int>(def);
    map['mind'] = Variable<int>(mind);
    map['resistance'] = Variable<int>(resistance);
    map['vitality'] = Variable<int>(vitality);
    map['critical_chance'] = Variable<double>(criticalChance);
    map['critical_damage'] = Variable<double>(criticalDamage);
    map['user_id'] = Variable<String>(userId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  CharacterTableCompanion toCompanion(bool nullToAbsent) {
    return CharacterTableCompanion(
      id: Value(id),
      name: Value(name),
      atk: Value(atk),
      def: Value(def),
      mind: Value(mind),
      resistance: Value(resistance),
      vitality: Value(vitality),
      criticalChance: Value(criticalChance),
      criticalDamage: Value(criticalDamage),
      userId: Value(userId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory CharacterEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CharacterEntry(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      atk: serializer.fromJson<int>(json['atk']),
      def: serializer.fromJson<int>(json['def']),
      mind: serializer.fromJson<int>(json['mind']),
      resistance: serializer.fromJson<int>(json['resistance']),
      vitality: serializer.fromJson<int>(json['vitality']),
      criticalChance: serializer.fromJson<double>(json['criticalChance']),
      criticalDamage: serializer.fromJson<double>(json['criticalDamage']),
      userId: serializer.fromJson<String>(json['userId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'atk': serializer.toJson<int>(atk),
      'def': serializer.toJson<int>(def),
      'mind': serializer.toJson<int>(mind),
      'resistance': serializer.toJson<int>(resistance),
      'vitality': serializer.toJson<int>(vitality),
      'criticalChance': serializer.toJson<double>(criticalChance),
      'criticalDamage': serializer.toJson<double>(criticalDamage),
      'userId': serializer.toJson<String>(userId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  CharacterEntry copyWith({
    int? id,
    String? name,
    int? atk,
    int? def,
    int? mind,
    int? resistance,
    int? vitality,
    double? criticalChance,
    double? criticalDamage,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => CharacterEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    atk: atk ?? this.atk,
    def: def ?? this.def,
    mind: mind ?? this.mind,
    resistance: resistance ?? this.resistance,
    vitality: vitality ?? this.vitality,
    criticalChance: criticalChance ?? this.criticalChance,
    criticalDamage: criticalDamage ?? this.criticalDamage,
    userId: userId ?? this.userId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  CharacterEntry copyWithCompanion(CharacterTableCompanion data) {
    return CharacterEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      atk: data.atk.present ? data.atk.value : this.atk,
      def: data.def.present ? data.def.value : this.def,
      mind: data.mind.present ? data.mind.value : this.mind,
      resistance: data.resistance.present
          ? data.resistance.value
          : this.resistance,
      vitality: data.vitality.present ? data.vitality.value : this.vitality,
      criticalChance: data.criticalChance.present
          ? data.criticalChance.value
          : this.criticalChance,
      criticalDamage: data.criticalDamage.present
          ? data.criticalDamage.value
          : this.criticalDamage,
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CharacterEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('atk: $atk, ')
          ..write('def: $def, ')
          ..write('mind: $mind, ')
          ..write('resistance: $resistance, ')
          ..write('vitality: $vitality, ')
          ..write('criticalChance: $criticalChance, ')
          ..write('criticalDamage: $criticalDamage, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    atk,
    def,
    mind,
    resistance,
    vitality,
    criticalChance,
    criticalDamage,
    userId,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CharacterEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.atk == this.atk &&
          other.def == this.def &&
          other.mind == this.mind &&
          other.resistance == this.resistance &&
          other.vitality == this.vitality &&
          other.criticalChance == this.criticalChance &&
          other.criticalDamage == this.criticalDamage &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class CharacterTableCompanion extends UpdateCompanion<CharacterEntry> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> atk;
  final Value<int> def;
  final Value<int> mind;
  final Value<int> resistance;
  final Value<int> vitality;
  final Value<double> criticalChance;
  final Value<double> criticalDamage;
  final Value<String> userId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  const CharacterTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.atk = const Value.absent(),
    this.def = const Value.absent(),
    this.mind = const Value.absent(),
    this.resistance = const Value.absent(),
    this.vitality = const Value.absent(),
    this.criticalChance = const Value.absent(),
    this.criticalDamage = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  CharacterTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int atk,
    required int def,
    required int mind,
    required int resistance,
    required int vitality,
    required double criticalChance,
    required double criticalDamage,
    required String userId,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  }) : name = Value(name),
       atk = Value(atk),
       def = Value(def),
       mind = Value(mind),
       resistance = Value(resistance),
       vitality = Value(vitality),
       criticalChance = Value(criticalChance),
       criticalDamage = Value(criticalDamage),
       userId = Value(userId);
  static Insertable<CharacterEntry> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? atk,
    Expression<int>? def,
    Expression<int>? mind,
    Expression<int>? resistance,
    Expression<int>? vitality,
    Expression<double>? criticalChance,
    Expression<double>? criticalDamage,
    Expression<String>? userId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (atk != null) 'atk': atk,
      if (def != null) 'def': def,
      if (mind != null) 'mind': mind,
      if (resistance != null) 'resistance': resistance,
      if (vitality != null) 'vitality': vitality,
      if (criticalChance != null) 'critical_chance': criticalChance,
      if (criticalDamage != null) 'critical_damage': criticalDamage,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  CharacterTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? atk,
    Value<int>? def,
    Value<int>? mind,
    Value<int>? resistance,
    Value<int>? vitality,
    Value<double>? criticalChance,
    Value<double>? criticalDamage,
    Value<String>? userId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
  }) {
    return CharacterTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      atk: atk ?? this.atk,
      def: def ?? this.def,
      mind: mind ?? this.mind,
      resistance: resistance ?? this.resistance,
      vitality: vitality ?? this.vitality,
      criticalChance: criticalChance ?? this.criticalChance,
      criticalDamage: criticalDamage ?? this.criticalDamage,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (atk.present) {
      map['atk'] = Variable<int>(atk.value);
    }
    if (def.present) {
      map['def'] = Variable<int>(def.value);
    }
    if (mind.present) {
      map['mind'] = Variable<int>(mind.value);
    }
    if (resistance.present) {
      map['resistance'] = Variable<int>(resistance.value);
    }
    if (vitality.present) {
      map['vitality'] = Variable<int>(vitality.value);
    }
    if (criticalChance.present) {
      map['critical_chance'] = Variable<double>(criticalChance.value);
    }
    if (criticalDamage.present) {
      map['critical_damage'] = Variable<double>(criticalDamage.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharacterTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('atk: $atk, ')
          ..write('def: $def, ')
          ..write('mind: $mind, ')
          ..write('resistance: $resistance, ')
          ..write('vitality: $vitality, ')
          ..write('criticalChance: $criticalChance, ')
          ..write('criticalDamage: $criticalDamage, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }
}

class $UnitTableTable extends UnitTable
    with TableInfo<$UnitTableTable, UnitEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnitTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v7(),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 12,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atkMeta = const VerificationMeta('atk');
  @override
  late final GeneratedColumn<int> atk = GeneratedColumn<int>(
    'atk',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defMeta = const VerificationMeta('def');
  @override
  late final GeneratedColumn<int> def = GeneratedColumn<int>(
    'def',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vitalityMeta = const VerificationMeta(
    'vitality',
  );
  @override
  late final GeneratedColumn<int> vitality = GeneratedColumn<int>(
    'vitality',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _winsMeta = const VerificationMeta('wins');
  @override
  late final GeneratedColumn<int> wins = GeneratedColumn<int>(
    'wins',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lossesMeta = const VerificationMeta('losses');
  @override
  late final GeneratedColumn<int> losses = GeneratedColumn<int>(
    'losses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _coinsMeta = const VerificationMeta('coins');
  @override
  late final GeneratedColumn<int> coins = GeneratedColumn<int>(
    'coins',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _statPointsMeta = const VerificationMeta(
    'statPoints',
  );
  @override
  late final GeneratedColumn<int> statPoints = GeneratedColumn<int>(
    'stat_points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _expMeta = const VerificationMeta('exp');
  @override
  late final GeneratedColumn<int> exp = GeneratedColumn<int>(
    'exp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
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
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
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
    name,
    atk,
    def,
    vitality,
    wins,
    losses,
    coins,
    level,
    statPoints,
    exp,
    userId,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'unit_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UnitEntry> instance, {
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
    if (data.containsKey('atk')) {
      context.handle(
        _atkMeta,
        atk.isAcceptableOrUnknown(data['atk']!, _atkMeta),
      );
    } else if (isInserting) {
      context.missing(_atkMeta);
    }
    if (data.containsKey('def')) {
      context.handle(
        _defMeta,
        def.isAcceptableOrUnknown(data['def']!, _defMeta),
      );
    } else if (isInserting) {
      context.missing(_defMeta);
    }
    if (data.containsKey('vitality')) {
      context.handle(
        _vitalityMeta,
        vitality.isAcceptableOrUnknown(data['vitality']!, _vitalityMeta),
      );
    } else if (isInserting) {
      context.missing(_vitalityMeta);
    }
    if (data.containsKey('wins')) {
      context.handle(
        _winsMeta,
        wins.isAcceptableOrUnknown(data['wins']!, _winsMeta),
      );
    }
    if (data.containsKey('losses')) {
      context.handle(
        _lossesMeta,
        losses.isAcceptableOrUnknown(data['losses']!, _lossesMeta),
      );
    }
    if (data.containsKey('coins')) {
      context.handle(
        _coinsMeta,
        coins.isAcceptableOrUnknown(data['coins']!, _coinsMeta),
      );
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    if (data.containsKey('stat_points')) {
      context.handle(
        _statPointsMeta,
        statPoints.isAcceptableOrUnknown(data['stat_points']!, _statPointsMeta),
      );
    }
    if (data.containsKey('exp')) {
      context.handle(
        _expMeta,
        exp.isAcceptableOrUnknown(data['exp']!, _expMeta),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UnitEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnitEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      atk: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}atk'],
      )!,
      def: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}def'],
      )!,
      vitality: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vitality'],
      )!,
      wins: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wins'],
      )!,
      losses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}losses'],
      )!,
      coins: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}coins'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      statPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stat_points'],
      )!,
      exp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exp'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $UnitTableTable createAlias(String alias) {
    return $UnitTableTable(attachedDatabase, alias);
  }
}

class UnitEntry extends DataClass implements Insertable<UnitEntry> {
  final String id;
  final String name;
  final int atk;
  final int def;
  final int vitality;
  final int wins;
  final int losses;
  final int coins;
  final int level;
  final int statPoints;
  final int exp;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const UnitEntry({
    required this.id,
    required this.name,
    required this.atk,
    required this.def,
    required this.vitality,
    required this.wins,
    required this.losses,
    required this.coins,
    required this.level,
    required this.statPoints,
    required this.exp,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['atk'] = Variable<int>(atk);
    map['def'] = Variable<int>(def);
    map['vitality'] = Variable<int>(vitality);
    map['wins'] = Variable<int>(wins);
    map['losses'] = Variable<int>(losses);
    map['coins'] = Variable<int>(coins);
    map['level'] = Variable<int>(level);
    map['stat_points'] = Variable<int>(statPoints);
    map['exp'] = Variable<int>(exp);
    map['user_id'] = Variable<String>(userId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  UnitTableCompanion toCompanion(bool nullToAbsent) {
    return UnitTableCompanion(
      id: Value(id),
      name: Value(name),
      atk: Value(atk),
      def: Value(def),
      vitality: Value(vitality),
      wins: Value(wins),
      losses: Value(losses),
      coins: Value(coins),
      level: Value(level),
      statPoints: Value(statPoints),
      exp: Value(exp),
      userId: Value(userId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory UnitEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnitEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      atk: serializer.fromJson<int>(json['atk']),
      def: serializer.fromJson<int>(json['def']),
      vitality: serializer.fromJson<int>(json['vitality']),
      wins: serializer.fromJson<int>(json['wins']),
      losses: serializer.fromJson<int>(json['losses']),
      coins: serializer.fromJson<int>(json['coins']),
      level: serializer.fromJson<int>(json['level']),
      statPoints: serializer.fromJson<int>(json['statPoints']),
      exp: serializer.fromJson<int>(json['exp']),
      userId: serializer.fromJson<String>(json['userId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'atk': serializer.toJson<int>(atk),
      'def': serializer.toJson<int>(def),
      'vitality': serializer.toJson<int>(vitality),
      'wins': serializer.toJson<int>(wins),
      'losses': serializer.toJson<int>(losses),
      'coins': serializer.toJson<int>(coins),
      'level': serializer.toJson<int>(level),
      'statPoints': serializer.toJson<int>(statPoints),
      'exp': serializer.toJson<int>(exp),
      'userId': serializer.toJson<String>(userId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  UnitEntry copyWith({
    String? id,
    String? name,
    int? atk,
    int? def,
    int? vitality,
    int? wins,
    int? losses,
    int? coins,
    int? level,
    int? statPoints,
    int? exp,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => UnitEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    atk: atk ?? this.atk,
    def: def ?? this.def,
    vitality: vitality ?? this.vitality,
    wins: wins ?? this.wins,
    losses: losses ?? this.losses,
    coins: coins ?? this.coins,
    level: level ?? this.level,
    statPoints: statPoints ?? this.statPoints,
    exp: exp ?? this.exp,
    userId: userId ?? this.userId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  UnitEntry copyWithCompanion(UnitTableCompanion data) {
    return UnitEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      atk: data.atk.present ? data.atk.value : this.atk,
      def: data.def.present ? data.def.value : this.def,
      vitality: data.vitality.present ? data.vitality.value : this.vitality,
      wins: data.wins.present ? data.wins.value : this.wins,
      losses: data.losses.present ? data.losses.value : this.losses,
      coins: data.coins.present ? data.coins.value : this.coins,
      level: data.level.present ? data.level.value : this.level,
      statPoints: data.statPoints.present
          ? data.statPoints.value
          : this.statPoints,
      exp: data.exp.present ? data.exp.value : this.exp,
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnitEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('atk: $atk, ')
          ..write('def: $def, ')
          ..write('vitality: $vitality, ')
          ..write('wins: $wins, ')
          ..write('losses: $losses, ')
          ..write('coins: $coins, ')
          ..write('level: $level, ')
          ..write('statPoints: $statPoints, ')
          ..write('exp: $exp, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    atk,
    def,
    vitality,
    wins,
    losses,
    coins,
    level,
    statPoints,
    exp,
    userId,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnitEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.atk == this.atk &&
          other.def == this.def &&
          other.vitality == this.vitality &&
          other.wins == this.wins &&
          other.losses == this.losses &&
          other.coins == this.coins &&
          other.level == this.level &&
          other.statPoints == this.statPoints &&
          other.exp == this.exp &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class UnitTableCompanion extends UpdateCompanion<UnitEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> atk;
  final Value<int> def;
  final Value<int> vitality;
  final Value<int> wins;
  final Value<int> losses;
  final Value<int> coins;
  final Value<int> level;
  final Value<int> statPoints;
  final Value<int> exp;
  final Value<String> userId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const UnitTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.atk = const Value.absent(),
    this.def = const Value.absent(),
    this.vitality = const Value.absent(),
    this.wins = const Value.absent(),
    this.losses = const Value.absent(),
    this.coins = const Value.absent(),
    this.level = const Value.absent(),
    this.statPoints = const Value.absent(),
    this.exp = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UnitTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int atk,
    required int def,
    required int vitality,
    this.wins = const Value.absent(),
    this.losses = const Value.absent(),
    this.coins = const Value.absent(),
    this.level = const Value.absent(),
    this.statPoints = const Value.absent(),
    this.exp = const Value.absent(),
    required String userId,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       atk = Value(atk),
       def = Value(def),
       vitality = Value(vitality),
       userId = Value(userId);
  static Insertable<UnitEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? atk,
    Expression<int>? def,
    Expression<int>? vitality,
    Expression<int>? wins,
    Expression<int>? losses,
    Expression<int>? coins,
    Expression<int>? level,
    Expression<int>? statPoints,
    Expression<int>? exp,
    Expression<String>? userId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (atk != null) 'atk': atk,
      if (def != null) 'def': def,
      if (vitality != null) 'vitality': vitality,
      if (wins != null) 'wins': wins,
      if (losses != null) 'losses': losses,
      if (coins != null) 'coins': coins,
      if (level != null) 'level': level,
      if (statPoints != null) 'stat_points': statPoints,
      if (exp != null) 'exp': exp,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UnitTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? atk,
    Value<int>? def,
    Value<int>? vitality,
    Value<int>? wins,
    Value<int>? losses,
    Value<int>? coins,
    Value<int>? level,
    Value<int>? statPoints,
    Value<int>? exp,
    Value<String>? userId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return UnitTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      atk: atk ?? this.atk,
      def: def ?? this.def,
      vitality: vitality ?? this.vitality,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      coins: coins ?? this.coins,
      level: level ?? this.level,
      statPoints: statPoints ?? this.statPoints,
      exp: exp ?? this.exp,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (atk.present) {
      map['atk'] = Variable<int>(atk.value);
    }
    if (def.present) {
      map['def'] = Variable<int>(def.value);
    }
    if (vitality.present) {
      map['vitality'] = Variable<int>(vitality.value);
    }
    if (wins.present) {
      map['wins'] = Variable<int>(wins.value);
    }
    if (losses.present) {
      map['losses'] = Variable<int>(losses.value);
    }
    if (coins.present) {
      map['coins'] = Variable<int>(coins.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (statPoints.present) {
      map['stat_points'] = Variable<int>(statPoints.value);
    }
    if (exp.present) {
      map['exp'] = Variable<int>(exp.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('atk: $atk, ')
          ..write('def: $def, ')
          ..write('vitality: $vitality, ')
          ..write('wins: $wins, ')
          ..write('losses: $losses, ')
          ..write('coins: $coins, ')
          ..write('level: $level, ')
          ..write('statPoints: $statPoints, ')
          ..write('exp: $exp, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SelectedUnitTableTable extends SelectedUnitTable
    with TableInfo<$SelectedUnitTableTable, SelectedUnitEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SelectedUnitTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<String> unitId = GeneratedColumn<String>(
    'unit_id',
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
  );
  @override
  List<GeneratedColumn> get $columns => [unitId, userId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'selected_unit_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SelectedUnitEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('unit_id')) {
      context.handle(
        _unitIdMeta,
        unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_unitIdMeta);
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
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  SelectedUnitEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SelectedUnitEntry(
      unitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
    );
  }

  @override
  $SelectedUnitTableTable createAlias(String alias) {
    return $SelectedUnitTableTable(attachedDatabase, alias);
  }
}

class SelectedUnitEntry extends DataClass
    implements Insertable<SelectedUnitEntry> {
  final String unitId;
  final String userId;
  const SelectedUnitEntry({required this.unitId, required this.userId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['unit_id'] = Variable<String>(unitId);
    map['user_id'] = Variable<String>(userId);
    return map;
  }

  SelectedUnitTableCompanion toCompanion(bool nullToAbsent) {
    return SelectedUnitTableCompanion(
      unitId: Value(unitId),
      userId: Value(userId),
    );
  }

  factory SelectedUnitEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SelectedUnitEntry(
      unitId: serializer.fromJson<String>(json['unitId']),
      userId: serializer.fromJson<String>(json['userId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'unitId': serializer.toJson<String>(unitId),
      'userId': serializer.toJson<String>(userId),
    };
  }

  SelectedUnitEntry copyWith({String? unitId, String? userId}) =>
      SelectedUnitEntry(
        unitId: unitId ?? this.unitId,
        userId: userId ?? this.userId,
      );
  SelectedUnitEntry copyWithCompanion(SelectedUnitTableCompanion data) {
    return SelectedUnitEntry(
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      userId: data.userId.present ? data.userId.value : this.userId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SelectedUnitEntry(')
          ..write('unitId: $unitId, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(unitId, userId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SelectedUnitEntry &&
          other.unitId == this.unitId &&
          other.userId == this.userId);
}

class SelectedUnitTableCompanion extends UpdateCompanion<SelectedUnitEntry> {
  final Value<String> unitId;
  final Value<String> userId;
  final Value<int> rowid;
  const SelectedUnitTableCompanion({
    this.unitId = const Value.absent(),
    this.userId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SelectedUnitTableCompanion.insert({
    required String unitId,
    required String userId,
    this.rowid = const Value.absent(),
  }) : unitId = Value(unitId),
       userId = Value(userId);
  static Insertable<SelectedUnitEntry> custom({
    Expression<String>? unitId,
    Expression<String>? userId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (unitId != null) 'unit_id': unitId,
      if (userId != null) 'user_id': userId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SelectedUnitTableCompanion copyWith({
    Value<String>? unitId,
    Value<String>? userId,
    Value<int>? rowid,
  }) {
    return SelectedUnitTableCompanion(
      unitId: unitId ?? this.unitId,
      userId: userId ?? this.userId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (unitId.present) {
      map['unit_id'] = Variable<String>(unitId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SelectedUnitTableCompanion(')
          ..write('unitId: $unitId, ')
          ..write('userId: $userId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LogEntriesTable extends LogEntries
    with TableInfo<$LogEntriesTable, LogEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LogEntriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loggerNameMeta = const VerificationMeta(
    'loggerName',
  );
  @override
  late final GeneratedColumn<String> loggerName = GeneratedColumn<String>(
    'logger_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
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
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  @override
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
    'error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stackTraceMeta = const VerificationMeta(
    'stackTrace',
  );
  @override
  late final GeneratedColumn<String> stackTrace = GeneratedColumn<String>(
    'stack_trace',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    level,
    loggerName,
    message,
    createdAt,
    error,
    stackTrace,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'log_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<LogEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('logger_name')) {
      context.handle(
        _loggerNameMeta,
        loggerName.isAcceptableOrUnknown(data['logger_name']!, _loggerNameMeta),
      );
    } else if (isInserting) {
      context.missing(_loggerNameMeta);
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('error')) {
      context.handle(
        _errorMeta,
        error.isAcceptableOrUnknown(data['error']!, _errorMeta),
      );
    }
    if (data.containsKey('stack_trace')) {
      context.handle(
        _stackTraceMeta,
        stackTrace.isAcceptableOrUnknown(data['stack_trace']!, _stackTraceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LogEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LogEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level'],
      )!,
      loggerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logger_name'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      error: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error'],
      ),
      stackTrace: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stack_trace'],
      ),
    );
  }

  @override
  $LogEntriesTable createAlias(String alias) {
    return $LogEntriesTable(attachedDatabase, alias);
  }
}

class LogEntry extends DataClass implements Insertable<LogEntry> {
  final int id;
  final String level;
  final String loggerName;
  final String message;
  final DateTime createdAt;
  final String? error;
  final String? stackTrace;
  const LogEntry({
    required this.id,
    required this.level,
    required this.loggerName,
    required this.message,
    required this.createdAt,
    this.error,
    this.stackTrace,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['level'] = Variable<String>(level);
    map['logger_name'] = Variable<String>(loggerName);
    map['message'] = Variable<String>(message);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    if (!nullToAbsent || stackTrace != null) {
      map['stack_trace'] = Variable<String>(stackTrace);
    }
    return map;
  }

  LogEntriesCompanion toCompanion(bool nullToAbsent) {
    return LogEntriesCompanion(
      id: Value(id),
      level: Value(level),
      loggerName: Value(loggerName),
      message: Value(message),
      createdAt: Value(createdAt),
      error: error == null && nullToAbsent
          ? const Value.absent()
          : Value(error),
      stackTrace: stackTrace == null && nullToAbsent
          ? const Value.absent()
          : Value(stackTrace),
    );
  }

  factory LogEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LogEntry(
      id: serializer.fromJson<int>(json['id']),
      level: serializer.fromJson<String>(json['level']),
      loggerName: serializer.fromJson<String>(json['loggerName']),
      message: serializer.fromJson<String>(json['message']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      error: serializer.fromJson<String?>(json['error']),
      stackTrace: serializer.fromJson<String?>(json['stackTrace']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'level': serializer.toJson<String>(level),
      'loggerName': serializer.toJson<String>(loggerName),
      'message': serializer.toJson<String>(message),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'error': serializer.toJson<String?>(error),
      'stackTrace': serializer.toJson<String?>(stackTrace),
    };
  }

  LogEntry copyWith({
    int? id,
    String? level,
    String? loggerName,
    String? message,
    DateTime? createdAt,
    Value<String?> error = const Value.absent(),
    Value<String?> stackTrace = const Value.absent(),
  }) => LogEntry(
    id: id ?? this.id,
    level: level ?? this.level,
    loggerName: loggerName ?? this.loggerName,
    message: message ?? this.message,
    createdAt: createdAt ?? this.createdAt,
    error: error.present ? error.value : this.error,
    stackTrace: stackTrace.present ? stackTrace.value : this.stackTrace,
  );
  LogEntry copyWithCompanion(LogEntriesCompanion data) {
    return LogEntry(
      id: data.id.present ? data.id.value : this.id,
      level: data.level.present ? data.level.value : this.level,
      loggerName: data.loggerName.present
          ? data.loggerName.value
          : this.loggerName,
      message: data.message.present ? data.message.value : this.message,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      error: data.error.present ? data.error.value : this.error,
      stackTrace: data.stackTrace.present
          ? data.stackTrace.value
          : this.stackTrace,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LogEntry(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('loggerName: $loggerName, ')
          ..write('message: $message, ')
          ..write('createdAt: $createdAt, ')
          ..write('error: $error, ')
          ..write('stackTrace: $stackTrace')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, level, loggerName, message, createdAt, error, stackTrace);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LogEntry &&
          other.id == this.id &&
          other.level == this.level &&
          other.loggerName == this.loggerName &&
          other.message == this.message &&
          other.createdAt == this.createdAt &&
          other.error == this.error &&
          other.stackTrace == this.stackTrace);
}

class LogEntriesCompanion extends UpdateCompanion<LogEntry> {
  final Value<int> id;
  final Value<String> level;
  final Value<String> loggerName;
  final Value<String> message;
  final Value<DateTime> createdAt;
  final Value<String?> error;
  final Value<String?> stackTrace;
  const LogEntriesCompanion({
    this.id = const Value.absent(),
    this.level = const Value.absent(),
    this.loggerName = const Value.absent(),
    this.message = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.error = const Value.absent(),
    this.stackTrace = const Value.absent(),
  });
  LogEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String level,
    required String loggerName,
    required String message,
    this.createdAt = const Value.absent(),
    this.error = const Value.absent(),
    this.stackTrace = const Value.absent(),
  }) : level = Value(level),
       loggerName = Value(loggerName),
       message = Value(message);
  static Insertable<LogEntry> custom({
    Expression<int>? id,
    Expression<String>? level,
    Expression<String>? loggerName,
    Expression<String>? message,
    Expression<DateTime>? createdAt,
    Expression<String>? error,
    Expression<String>? stackTrace,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (level != null) 'level': level,
      if (loggerName != null) 'logger_name': loggerName,
      if (message != null) 'message': message,
      if (createdAt != null) 'created_at': createdAt,
      if (error != null) 'error': error,
      if (stackTrace != null) 'stack_trace': stackTrace,
    });
  }

  LogEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? level,
    Value<String>? loggerName,
    Value<String>? message,
    Value<DateTime>? createdAt,
    Value<String?>? error,
    Value<String?>? stackTrace,
  }) {
    return LogEntriesCompanion(
      id: id ?? this.id,
      level: level ?? this.level,
      loggerName: loggerName ?? this.loggerName,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (loggerName.present) {
      map['logger_name'] = Variable<String>(loggerName.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    if (stackTrace.present) {
      map['stack_trace'] = Variable<String>(stackTrace.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LogEntriesCompanion(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('loggerName: $loggerName, ')
          ..write('message: $message, ')
          ..write('createdAt: $createdAt, ')
          ..write('error: $error, ')
          ..write('stackTrace: $stackTrace')
          ..write(')'))
        .toString();
  }
}

abstract class _$DbClient extends GeneratedDatabase {
  _$DbClient(QueryExecutor e) : super(e);
  $DbClientManager get managers => $DbClientManager(this);
  late final $TodoTableTable todoTable = $TodoTableTable(this);
  late final $UserTableTable userTable = $UserTableTable(this);
  late final $SessionTableTable sessionTable = $SessionTableTable(this);
  late final $LetterTableTable letterTable = $LetterTableTable(this);
  late final $RoomTableTable roomTable = $RoomTableTable(this);
  late final $RoomMemberTableTable roomMemberTable = $RoomMemberTableTable(
    this,
  );
  late final $CharacterTableTable characterTable = $CharacterTableTable(this);
  late final $UnitTableTable unitTable = $UnitTableTable(this);
  late final $SelectedUnitTableTable selectedUnitTable =
      $SelectedUnitTableTable(this);
  late final $LogEntriesTable logEntries = $LogEntriesTable(this);
  late final TodoDao todoDao = TodoDao(this as DbClient);
  late final UserDao userDao = UserDao(this as DbClient);
  late final SessionDao sessionDao = SessionDao(this as DbClient);
  late final LettersDao lettersDao = LettersDao(this as DbClient);
  late final RoomDao roomDao = RoomDao(this as DbClient);
  late final GameDao gameDao = GameDao(this as DbClient);
  late final UnitDao unitDao = UnitDao(this as DbClient);
  late final LogDao logDao = LogDao(this as DbClient);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    todoTable,
    userTable,
    sessionTable,
    letterTable,
    roomTable,
    roomMemberTable,
    characterTable,
    unitTable,
    selectedUnitTable,
    logEntries,
  ];
}

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

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );
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

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );
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

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);
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
          (TodoEntry, BaseReferences<_$DbClient, $TodoTableTable, TodoEntry>),
          TodoEntry,
          PrefetchHooks Function()
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
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
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
      (TodoEntry, BaseReferences<_$DbClient, $TodoTableTable, TodoEntry>),
      TodoEntry,
      PrefetchHooks Function()
    >;
typedef $$UserTableTableCreateCompanionBuilder =
    UserTableCompanion Function({
      Value<String> id,
      required String email,
      required String password,
      Value<Role> role,
      Value<DateTime> createdAt,
      Value<DateTime?> deletedAt,
      Value<bool> emailVerified,
      Value<String?> confirmationToken,
      Value<int> rowid,
    });
typedef $$UserTableTableUpdateCompanionBuilder =
    UserTableCompanion Function({
      Value<String> id,
      Value<String> email,
      Value<String> password,
      Value<Role> role,
      Value<DateTime> createdAt,
      Value<DateTime?> deletedAt,
      Value<bool> emailVerified,
      Value<String?> confirmationToken,
      Value<int> rowid,
    });

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

  ColumnWithTypeConverterFilters<Role, Role, String> get role =>
      $composableBuilder(
        column: $table.role,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get emailVerified => $composableBuilder(
    column: $table.emailVerified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confirmationToken => $composableBuilder(
    column: $table.confirmationToken,
    builder: (column) => ColumnFilters(column),
  );
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

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
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

  ColumnOrderings<bool> get emailVerified => $composableBuilder(
    column: $table.emailVerified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confirmationToken => $composableBuilder(
    column: $table.confirmationToken,
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

  GeneratedColumnWithTypeConverter<Role, String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get emailVerified => $composableBuilder(
    column: $table.emailVerified,
    builder: (column) => column,
  );

  GeneratedColumn<String> get confirmationToken => $composableBuilder(
    column: $table.confirmationToken,
    builder: (column) => column,
  );
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
          (UserEntry, BaseReferences<_$DbClient, $UserTableTable, UserEntry>),
          UserEntry,
          PrefetchHooks Function()
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
                Value<Role> role = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<bool> emailVerified = const Value.absent(),
                Value<String?> confirmationToken = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserTableCompanion(
                id: id,
                email: email,
                password: password,
                role: role,
                createdAt: createdAt,
                deletedAt: deletedAt,
                emailVerified: emailVerified,
                confirmationToken: confirmationToken,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String email,
                required String password,
                Value<Role> role = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<bool> emailVerified = const Value.absent(),
                Value<String?> confirmationToken = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserTableCompanion.insert(
                id: id,
                email: email,
                password: password,
                role: role,
                createdAt: createdAt,
                deletedAt: deletedAt,
                emailVerified: emailVerified,
                confirmationToken: confirmationToken,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
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
      (UserEntry, BaseReferences<_$DbClient, $UserTableTable, UserEntry>),
      UserEntry,
      PrefetchHooks Function()
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

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
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

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
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

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

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
          (
            SessionEntry,
            BaseReferences<_$DbClient, $SessionTableTable, SessionEntry>,
          ),
          SessionEntry,
          PrefetchHooks Function()
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
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
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
      (
        SessionEntry,
        BaseReferences<_$DbClient, $SessionTableTable, SessionEntry>,
      ),
      SessionEntry,
      PrefetchHooks Function()
    >;
typedef $$LetterTableTableCreateCompanionBuilder =
    LetterTableCompanion Function({
      Value<int> id,
      required String chatRoomId,
      required String senderId,
      required String content,
      Value<DateTime> createdAt,
    });
typedef $$LetterTableTableUpdateCompanionBuilder =
    LetterTableCompanion Function({
      Value<int> id,
      Value<String> chatRoomId,
      Value<String> senderId,
      Value<String> content,
      Value<DateTime> createdAt,
    });

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

  ColumnFilters<String> get chatRoomId => $composableBuilder(
    column: $table.chatRoomId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get senderId => $composableBuilder(
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

  ColumnOrderings<String> get chatRoomId => $composableBuilder(
    column: $table.chatRoomId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get senderId => $composableBuilder(
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

  GeneratedColumn<String> get chatRoomId => $composableBuilder(
    column: $table.chatRoomId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get senderId =>
      $composableBuilder(column: $table.senderId, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
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
          (
            LetterEntry,
            BaseReferences<_$DbClient, $LetterTableTable, LetterEntry>,
          ),
          LetterEntry,
          PrefetchHooks Function()
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
                Value<String> chatRoomId = const Value.absent(),
                Value<String> senderId = const Value.absent(),
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
                required String chatRoomId,
                required String senderId,
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
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
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
      (LetterEntry, BaseReferences<_$DbClient, $LetterTableTable, LetterEntry>),
      LetterEntry,
      PrefetchHooks Function()
    >;
typedef $$RoomTableTableCreateCompanionBuilder =
    RoomTableCompanion Function({
      required String id,
      required String name,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$RoomTableTableUpdateCompanionBuilder =
    RoomTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$RoomTableTableFilterComposer
    extends Composer<_$DbClient, $RoomTableTable> {
  $$RoomTableTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RoomTableTableOrderingComposer
    extends Composer<_$DbClient, $RoomTableTable> {
  $$RoomTableTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoomTableTableAnnotationComposer
    extends Composer<_$DbClient, $RoomTableTable> {
  $$RoomTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$RoomTableTableTableManager
    extends
        RootTableManager<
          _$DbClient,
          $RoomTableTable,
          RoomEntry,
          $$RoomTableTableFilterComposer,
          $$RoomTableTableOrderingComposer,
          $$RoomTableTableAnnotationComposer,
          $$RoomTableTableCreateCompanionBuilder,
          $$RoomTableTableUpdateCompanionBuilder,
          (RoomEntry, BaseReferences<_$DbClient, $RoomTableTable, RoomEntry>),
          RoomEntry,
          PrefetchHooks Function()
        > {
  $$RoomTableTableTableManager(_$DbClient db, $RoomTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoomTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoomTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoomTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoomTableCompanion(
                id: id,
                name: name,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoomTableCompanion.insert(
                id: id,
                name: name,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RoomTableTableProcessedTableManager =
    ProcessedTableManager<
      _$DbClient,
      $RoomTableTable,
      RoomEntry,
      $$RoomTableTableFilterComposer,
      $$RoomTableTableOrderingComposer,
      $$RoomTableTableAnnotationComposer,
      $$RoomTableTableCreateCompanionBuilder,
      $$RoomTableTableUpdateCompanionBuilder,
      (RoomEntry, BaseReferences<_$DbClient, $RoomTableTable, RoomEntry>),
      RoomEntry,
      PrefetchHooks Function()
    >;
typedef $$RoomMemberTableTableCreateCompanionBuilder =
    RoomMemberTableCompanion Function({
      required String chatRoomId,
      required String userId,
      Value<int> rowid,
    });
typedef $$RoomMemberTableTableUpdateCompanionBuilder =
    RoomMemberTableCompanion Function({
      Value<String> chatRoomId,
      Value<String> userId,
      Value<int> rowid,
    });

class $$RoomMemberTableTableFilterComposer
    extends Composer<_$DbClient, $RoomMemberTableTable> {
  $$RoomMemberTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get chatRoomId => $composableBuilder(
    column: $table.chatRoomId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RoomMemberTableTableOrderingComposer
    extends Composer<_$DbClient, $RoomMemberTableTable> {
  $$RoomMemberTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get chatRoomId => $composableBuilder(
    column: $table.chatRoomId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoomMemberTableTableAnnotationComposer
    extends Composer<_$DbClient, $RoomMemberTableTable> {
  $$RoomMemberTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get chatRoomId => $composableBuilder(
    column: $table.chatRoomId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);
}

class $$RoomMemberTableTableTableManager
    extends
        RootTableManager<
          _$DbClient,
          $RoomMemberTableTable,
          RoomMemberEntry,
          $$RoomMemberTableTableFilterComposer,
          $$RoomMemberTableTableOrderingComposer,
          $$RoomMemberTableTableAnnotationComposer,
          $$RoomMemberTableTableCreateCompanionBuilder,
          $$RoomMemberTableTableUpdateCompanionBuilder,
          (
            RoomMemberEntry,
            BaseReferences<_$DbClient, $RoomMemberTableTable, RoomMemberEntry>,
          ),
          RoomMemberEntry,
          PrefetchHooks Function()
        > {
  $$RoomMemberTableTableTableManager(_$DbClient db, $RoomMemberTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoomMemberTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoomMemberTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoomMemberTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> chatRoomId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoomMemberTableCompanion(
                chatRoomId: chatRoomId,
                userId: userId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String chatRoomId,
                required String userId,
                Value<int> rowid = const Value.absent(),
              }) => RoomMemberTableCompanion.insert(
                chatRoomId: chatRoomId,
                userId: userId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RoomMemberTableTableProcessedTableManager =
    ProcessedTableManager<
      _$DbClient,
      $RoomMemberTableTable,
      RoomMemberEntry,
      $$RoomMemberTableTableFilterComposer,
      $$RoomMemberTableTableOrderingComposer,
      $$RoomMemberTableTableAnnotationComposer,
      $$RoomMemberTableTableCreateCompanionBuilder,
      $$RoomMemberTableTableUpdateCompanionBuilder,
      (
        RoomMemberEntry,
        BaseReferences<_$DbClient, $RoomMemberTableTable, RoomMemberEntry>,
      ),
      RoomMemberEntry,
      PrefetchHooks Function()
    >;
typedef $$CharacterTableTableCreateCompanionBuilder =
    CharacterTableCompanion Function({
      Value<int> id,
      required String name,
      required int atk,
      required int def,
      required int mind,
      required int resistance,
      required int vitality,
      required double criticalChance,
      required double criticalDamage,
      required String userId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
    });
typedef $$CharacterTableTableUpdateCompanionBuilder =
    CharacterTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> atk,
      Value<int> def,
      Value<int> mind,
      Value<int> resistance,
      Value<int> vitality,
      Value<double> criticalChance,
      Value<double> criticalDamage,
      Value<String> userId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
    });

class $$CharacterTableTableFilterComposer
    extends Composer<_$DbClient, $CharacterTableTable> {
  $$CharacterTableTableFilterComposer({
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

  ColumnFilters<int> get atk => $composableBuilder(
    column: $table.atk,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get def => $composableBuilder(
    column: $table.def,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mind => $composableBuilder(
    column: $table.mind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get resistance => $composableBuilder(
    column: $table.resistance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get vitality => $composableBuilder(
    column: $table.vitality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get criticalChance => $composableBuilder(
    column: $table.criticalChance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get criticalDamage => $composableBuilder(
    column: $table.criticalDamage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
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
}

class $$CharacterTableTableOrderingComposer
    extends Composer<_$DbClient, $CharacterTableTable> {
  $$CharacterTableTableOrderingComposer({
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

  ColumnOrderings<int> get atk => $composableBuilder(
    column: $table.atk,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get def => $composableBuilder(
    column: $table.def,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mind => $composableBuilder(
    column: $table.mind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get resistance => $composableBuilder(
    column: $table.resistance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get vitality => $composableBuilder(
    column: $table.vitality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get criticalChance => $composableBuilder(
    column: $table.criticalChance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get criticalDamage => $composableBuilder(
    column: $table.criticalDamage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
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
}

class $$CharacterTableTableAnnotationComposer
    extends Composer<_$DbClient, $CharacterTableTable> {
  $$CharacterTableTableAnnotationComposer({
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

  GeneratedColumn<int> get atk =>
      $composableBuilder(column: $table.atk, builder: (column) => column);

  GeneratedColumn<int> get def =>
      $composableBuilder(column: $table.def, builder: (column) => column);

  GeneratedColumn<int> get mind =>
      $composableBuilder(column: $table.mind, builder: (column) => column);

  GeneratedColumn<int> get resistance => $composableBuilder(
    column: $table.resistance,
    builder: (column) => column,
  );

  GeneratedColumn<int> get vitality =>
      $composableBuilder(column: $table.vitality, builder: (column) => column);

  GeneratedColumn<double> get criticalChance => $composableBuilder(
    column: $table.criticalChance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get criticalDamage => $composableBuilder(
    column: $table.criticalDamage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$CharacterTableTableTableManager
    extends
        RootTableManager<
          _$DbClient,
          $CharacterTableTable,
          CharacterEntry,
          $$CharacterTableTableFilterComposer,
          $$CharacterTableTableOrderingComposer,
          $$CharacterTableTableAnnotationComposer,
          $$CharacterTableTableCreateCompanionBuilder,
          $$CharacterTableTableUpdateCompanionBuilder,
          (
            CharacterEntry,
            BaseReferences<_$DbClient, $CharacterTableTable, CharacterEntry>,
          ),
          CharacterEntry,
          PrefetchHooks Function()
        > {
  $$CharacterTableTableTableManager(_$DbClient db, $CharacterTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharacterTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharacterTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CharacterTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> atk = const Value.absent(),
                Value<int> def = const Value.absent(),
                Value<int> mind = const Value.absent(),
                Value<int> resistance = const Value.absent(),
                Value<int> vitality = const Value.absent(),
                Value<double> criticalChance = const Value.absent(),
                Value<double> criticalDamage = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => CharacterTableCompanion(
                id: id,
                name: name,
                atk: atk,
                def: def,
                mind: mind,
                resistance: resistance,
                vitality: vitality,
                criticalChance: criticalChance,
                criticalDamage: criticalDamage,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int atk,
                required int def,
                required int mind,
                required int resistance,
                required int vitality,
                required double criticalChance,
                required double criticalDamage,
                required String userId,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => CharacterTableCompanion.insert(
                id: id,
                name: name,
                atk: atk,
                def: def,
                mind: mind,
                resistance: resistance,
                vitality: vitality,
                criticalChance: criticalChance,
                criticalDamage: criticalDamage,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CharacterTableTableProcessedTableManager =
    ProcessedTableManager<
      _$DbClient,
      $CharacterTableTable,
      CharacterEntry,
      $$CharacterTableTableFilterComposer,
      $$CharacterTableTableOrderingComposer,
      $$CharacterTableTableAnnotationComposer,
      $$CharacterTableTableCreateCompanionBuilder,
      $$CharacterTableTableUpdateCompanionBuilder,
      (
        CharacterEntry,
        BaseReferences<_$DbClient, $CharacterTableTable, CharacterEntry>,
      ),
      CharacterEntry,
      PrefetchHooks Function()
    >;
typedef $$UnitTableTableCreateCompanionBuilder =
    UnitTableCompanion Function({
      Value<String> id,
      required String name,
      required int atk,
      required int def,
      required int vitality,
      Value<int> wins,
      Value<int> losses,
      Value<int> coins,
      Value<int> level,
      Value<int> statPoints,
      Value<int> exp,
      required String userId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$UnitTableTableUpdateCompanionBuilder =
    UnitTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> atk,
      Value<int> def,
      Value<int> vitality,
      Value<int> wins,
      Value<int> losses,
      Value<int> coins,
      Value<int> level,
      Value<int> statPoints,
      Value<int> exp,
      Value<String> userId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$UnitTableTableFilterComposer
    extends Composer<_$DbClient, $UnitTableTable> {
  $$UnitTableTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get atk => $composableBuilder(
    column: $table.atk,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get def => $composableBuilder(
    column: $table.def,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get vitality => $composableBuilder(
    column: $table.vitality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wins => $composableBuilder(
    column: $table.wins,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get losses => $composableBuilder(
    column: $table.losses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get coins => $composableBuilder(
    column: $table.coins,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get statPoints => $composableBuilder(
    column: $table.statPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get exp => $composableBuilder(
    column: $table.exp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
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
}

class $$UnitTableTableOrderingComposer
    extends Composer<_$DbClient, $UnitTableTable> {
  $$UnitTableTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get atk => $composableBuilder(
    column: $table.atk,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get def => $composableBuilder(
    column: $table.def,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get vitality => $composableBuilder(
    column: $table.vitality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wins => $composableBuilder(
    column: $table.wins,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get losses => $composableBuilder(
    column: $table.losses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get coins => $composableBuilder(
    column: $table.coins,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get statPoints => $composableBuilder(
    column: $table.statPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exp => $composableBuilder(
    column: $table.exp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
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
}

class $$UnitTableTableAnnotationComposer
    extends Composer<_$DbClient, $UnitTableTable> {
  $$UnitTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get atk =>
      $composableBuilder(column: $table.atk, builder: (column) => column);

  GeneratedColumn<int> get def =>
      $composableBuilder(column: $table.def, builder: (column) => column);

  GeneratedColumn<int> get vitality =>
      $composableBuilder(column: $table.vitality, builder: (column) => column);

  GeneratedColumn<int> get wins =>
      $composableBuilder(column: $table.wins, builder: (column) => column);

  GeneratedColumn<int> get losses =>
      $composableBuilder(column: $table.losses, builder: (column) => column);

  GeneratedColumn<int> get coins =>
      $composableBuilder(column: $table.coins, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get statPoints => $composableBuilder(
    column: $table.statPoints,
    builder: (column) => column,
  );

  GeneratedColumn<int> get exp =>
      $composableBuilder(column: $table.exp, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$UnitTableTableTableManager
    extends
        RootTableManager<
          _$DbClient,
          $UnitTableTable,
          UnitEntry,
          $$UnitTableTableFilterComposer,
          $$UnitTableTableOrderingComposer,
          $$UnitTableTableAnnotationComposer,
          $$UnitTableTableCreateCompanionBuilder,
          $$UnitTableTableUpdateCompanionBuilder,
          (UnitEntry, BaseReferences<_$DbClient, $UnitTableTable, UnitEntry>),
          UnitEntry,
          PrefetchHooks Function()
        > {
  $$UnitTableTableTableManager(_$DbClient db, $UnitTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnitTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnitTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnitTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> atk = const Value.absent(),
                Value<int> def = const Value.absent(),
                Value<int> vitality = const Value.absent(),
                Value<int> wins = const Value.absent(),
                Value<int> losses = const Value.absent(),
                Value<int> coins = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<int> statPoints = const Value.absent(),
                Value<int> exp = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UnitTableCompanion(
                id: id,
                name: name,
                atk: atk,
                def: def,
                vitality: vitality,
                wins: wins,
                losses: losses,
                coins: coins,
                level: level,
                statPoints: statPoints,
                exp: exp,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String name,
                required int atk,
                required int def,
                required int vitality,
                Value<int> wins = const Value.absent(),
                Value<int> losses = const Value.absent(),
                Value<int> coins = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<int> statPoints = const Value.absent(),
                Value<int> exp = const Value.absent(),
                required String userId,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UnitTableCompanion.insert(
                id: id,
                name: name,
                atk: atk,
                def: def,
                vitality: vitality,
                wins: wins,
                losses: losses,
                coins: coins,
                level: level,
                statPoints: statPoints,
                exp: exp,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UnitTableTableProcessedTableManager =
    ProcessedTableManager<
      _$DbClient,
      $UnitTableTable,
      UnitEntry,
      $$UnitTableTableFilterComposer,
      $$UnitTableTableOrderingComposer,
      $$UnitTableTableAnnotationComposer,
      $$UnitTableTableCreateCompanionBuilder,
      $$UnitTableTableUpdateCompanionBuilder,
      (UnitEntry, BaseReferences<_$DbClient, $UnitTableTable, UnitEntry>),
      UnitEntry,
      PrefetchHooks Function()
    >;
typedef $$SelectedUnitTableTableCreateCompanionBuilder =
    SelectedUnitTableCompanion Function({
      required String unitId,
      required String userId,
      Value<int> rowid,
    });
typedef $$SelectedUnitTableTableUpdateCompanionBuilder =
    SelectedUnitTableCompanion Function({
      Value<String> unitId,
      Value<String> userId,
      Value<int> rowid,
    });

class $$SelectedUnitTableTableFilterComposer
    extends Composer<_$DbClient, $SelectedUnitTableTable> {
  $$SelectedUnitTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get unitId => $composableBuilder(
    column: $table.unitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SelectedUnitTableTableOrderingComposer
    extends Composer<_$DbClient, $SelectedUnitTableTable> {
  $$SelectedUnitTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get unitId => $composableBuilder(
    column: $table.unitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SelectedUnitTableTableAnnotationComposer
    extends Composer<_$DbClient, $SelectedUnitTableTable> {
  $$SelectedUnitTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get unitId =>
      $composableBuilder(column: $table.unitId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);
}

class $$SelectedUnitTableTableTableManager
    extends
        RootTableManager<
          _$DbClient,
          $SelectedUnitTableTable,
          SelectedUnitEntry,
          $$SelectedUnitTableTableFilterComposer,
          $$SelectedUnitTableTableOrderingComposer,
          $$SelectedUnitTableTableAnnotationComposer,
          $$SelectedUnitTableTableCreateCompanionBuilder,
          $$SelectedUnitTableTableUpdateCompanionBuilder,
          (
            SelectedUnitEntry,
            BaseReferences<
              _$DbClient,
              $SelectedUnitTableTable,
              SelectedUnitEntry
            >,
          ),
          SelectedUnitEntry,
          PrefetchHooks Function()
        > {
  $$SelectedUnitTableTableTableManager(
    _$DbClient db,
    $SelectedUnitTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SelectedUnitTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SelectedUnitTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SelectedUnitTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> unitId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SelectedUnitTableCompanion(
                unitId: unitId,
                userId: userId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String unitId,
                required String userId,
                Value<int> rowid = const Value.absent(),
              }) => SelectedUnitTableCompanion.insert(
                unitId: unitId,
                userId: userId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SelectedUnitTableTableProcessedTableManager =
    ProcessedTableManager<
      _$DbClient,
      $SelectedUnitTableTable,
      SelectedUnitEntry,
      $$SelectedUnitTableTableFilterComposer,
      $$SelectedUnitTableTableOrderingComposer,
      $$SelectedUnitTableTableAnnotationComposer,
      $$SelectedUnitTableTableCreateCompanionBuilder,
      $$SelectedUnitTableTableUpdateCompanionBuilder,
      (
        SelectedUnitEntry,
        BaseReferences<_$DbClient, $SelectedUnitTableTable, SelectedUnitEntry>,
      ),
      SelectedUnitEntry,
      PrefetchHooks Function()
    >;
typedef $$LogEntriesTableCreateCompanionBuilder =
    LogEntriesCompanion Function({
      Value<int> id,
      required String level,
      required String loggerName,
      required String message,
      Value<DateTime> createdAt,
      Value<String?> error,
      Value<String?> stackTrace,
    });
typedef $$LogEntriesTableUpdateCompanionBuilder =
    LogEntriesCompanion Function({
      Value<int> id,
      Value<String> level,
      Value<String> loggerName,
      Value<String> message,
      Value<DateTime> createdAt,
      Value<String?> error,
      Value<String?> stackTrace,
    });

class $$LogEntriesTableFilterComposer
    extends Composer<_$DbClient, $LogEntriesTable> {
  $$LogEntriesTableFilterComposer({
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

  ColumnFilters<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get loggerName => $composableBuilder(
    column: $table.loggerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stackTrace => $composableBuilder(
    column: $table.stackTrace,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LogEntriesTableOrderingComposer
    extends Composer<_$DbClient, $LogEntriesTable> {
  $$LogEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get loggerName => $composableBuilder(
    column: $table.loggerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stackTrace => $composableBuilder(
    column: $table.stackTrace,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LogEntriesTableAnnotationComposer
    extends Composer<_$DbClient, $LogEntriesTable> {
  $$LogEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get loggerName => $composableBuilder(
    column: $table.loggerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => column);

  GeneratedColumn<String> get stackTrace => $composableBuilder(
    column: $table.stackTrace,
    builder: (column) => column,
  );
}

class $$LogEntriesTableTableManager
    extends
        RootTableManager<
          _$DbClient,
          $LogEntriesTable,
          LogEntry,
          $$LogEntriesTableFilterComposer,
          $$LogEntriesTableOrderingComposer,
          $$LogEntriesTableAnnotationComposer,
          $$LogEntriesTableCreateCompanionBuilder,
          $$LogEntriesTableUpdateCompanionBuilder,
          (LogEntry, BaseReferences<_$DbClient, $LogEntriesTable, LogEntry>),
          LogEntry,
          PrefetchHooks Function()
        > {
  $$LogEntriesTableTableManager(_$DbClient db, $LogEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LogEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LogEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LogEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<String> loggerName = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> error = const Value.absent(),
                Value<String?> stackTrace = const Value.absent(),
              }) => LogEntriesCompanion(
                id: id,
                level: level,
                loggerName: loggerName,
                message: message,
                createdAt: createdAt,
                error: error,
                stackTrace: stackTrace,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String level,
                required String loggerName,
                required String message,
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> error = const Value.absent(),
                Value<String?> stackTrace = const Value.absent(),
              }) => LogEntriesCompanion.insert(
                id: id,
                level: level,
                loggerName: loggerName,
                message: message,
                createdAt: createdAt,
                error: error,
                stackTrace: stackTrace,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LogEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$DbClient,
      $LogEntriesTable,
      LogEntry,
      $$LogEntriesTableFilterComposer,
      $$LogEntriesTableOrderingComposer,
      $$LogEntriesTableAnnotationComposer,
      $$LogEntriesTableCreateCompanionBuilder,
      $$LogEntriesTableUpdateCompanionBuilder,
      (LogEntry, BaseReferences<_$DbClient, $LogEntriesTable, LogEntry>),
      LogEntry,
      PrefetchHooks Function()
    >;

class $DbClientManager {
  final _$DbClient _db;
  $DbClientManager(this._db);
  $$TodoTableTableTableManager get todoTable =>
      $$TodoTableTableTableManager(_db, _db.todoTable);
  $$UserTableTableTableManager get userTable =>
      $$UserTableTableTableManager(_db, _db.userTable);
  $$SessionTableTableTableManager get sessionTable =>
      $$SessionTableTableTableManager(_db, _db.sessionTable);
  $$LetterTableTableTableManager get letterTable =>
      $$LetterTableTableTableManager(_db, _db.letterTable);
  $$RoomTableTableTableManager get roomTable =>
      $$RoomTableTableTableManager(_db, _db.roomTable);
  $$RoomMemberTableTableTableManager get roomMemberTable =>
      $$RoomMemberTableTableTableManager(_db, _db.roomMemberTable);
  $$CharacterTableTableTableManager get characterTable =>
      $$CharacterTableTableTableManager(_db, _db.characterTable);
  $$UnitTableTableTableManager get unitTable =>
      $$UnitTableTableTableManager(_db, _db.unitTable);
  $$SelectedUnitTableTableTableManager get selectedUnitTable =>
      $$SelectedUnitTableTableTableManager(_db, _db.selectedUnitTable);
  $$LogEntriesTableTableManager get logEntries =>
      $$LogEntriesTableTableManager(_db, _db.logEntries);
}
