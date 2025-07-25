import 'dart:io';
import 'package:backend/db_client/dao/channel_dao.dart';
import 'package:backend/db_client/dao/todo_dao.dart';
import 'package:backend/db_client/tables/channel_table.dart';
import 'package:backend/db_client/tables/todo_table.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

part 'db_client.g.dart';

// These annotations tell drift to prepare a table for us.
@DataClassName('UserEntry')
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get email => text().unique()();
}

@DriftDatabase(tables: [Users, ChannelTable, TodoTable], daos: [ChannelDao, TodoDao])
class DbClient extends _$DbClient {
  DbClient(super.e);

  // Singleton instance for the database
  static DbClient? _instance;
  static DbClient get instance {
    _instance ??= DbClient(_openConnection());
    return _instance!;
  }

  @override
  int get schemaVersion => 1; // Used for migrations

  // Example queries
  Future<List<UserEntry>> getAllUsers() => select(users).get();
  Future<UserEntry?> getUserById(int id) => (select(users)..where((u) => u.id.equals(id))).getSingleOrNull();
  Future<int> createUser(UsersCompanion entry) => into(users).insert(entry);
  Future<int> deleteUser(int id) => (delete(users)..where((u) => u.id.equals(id))).go();

  // You can also write raw SQL queries if needed:
  // Future<List<User>> rawUsers() => customSelect('SELECT * FROM users').map((row) => User.fromData(row.data, this)).get();
  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final appEnv = Platform.environment['APP_ENV'];
      final dbPath = appEnv == 'production'
          // /database/app.db
          ? p.join('/app', 'database', 'app.db') // Docker path
          : p.join(Directory.current.path, 'database', 'app.db'); // Local path

      final file = File(dbPath);
      if (!file.parent.existsSync()) {
        file.parent.createSync(recursive: true);
      }

      // Initialize SQLite if it hasn't been done (important for some platforms)
      sqlite3.open(dbPath); // This line just ensures sqlite3 is loaded

      return NativeDatabase(file);
    });
  }
}
