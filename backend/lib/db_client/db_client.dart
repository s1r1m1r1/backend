import 'dart:io';
import 'package:backend/db_client/dao/channel_dao.dart';
import 'package:backend/db_client/dao/todo_dao.dart';
import 'package:backend/db_client/tables/channel_table.dart';
import 'package:backend/db_client/tables/refresh_token_table.dart';
import 'package:backend/db_client/tables/todo_table.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

import 'dao/refresh_token_dao.dart';
import 'dao/user_dao.dart';
import 'tables/user_table.dart';

part 'db_client.g.dart';

@DriftDatabase(
  tables: [ChannelTable, TodoTable, UserTable, RefreshTokenTable],
  daos: [ChannelDao, TodoDao, UserDao, RefreshTokenDao],
)
class DbClient extends _$DbClient {
  DbClient(super.e);

  @override
  int get schemaVersion => 1; // Used for migrations

  // You can also write raw SQL queries if needed:
  // Future<List<User>> rawUsers() => customSelect('SELECT * FROM users').map((row) => User.fromData(row.data, this)).get();
  static QueryExecutor openConnection() {
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
