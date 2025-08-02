import 'dart:io';
import 'package:backend/db_client/dao/letters_dao.dart';
import 'package:backend/db_client/dao/session_dao.dart';
import 'package:backend/db_client/dao/todo_dao.dart';
import 'package:backend/db_client/tables/todo_table.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
// import 'package:uuid/uuid.dart';
import 'dao/chat_room_dao.dart';
import 'dao/user_dao.dart';
import 'tables/chat_room_table.dart';
import 'tables/chat_member_table.dart';
import 'tables/letter_table.dart';
import 'tables/session_table.dart';
import 'tables/user_table.dart';

part 'db_client.g.dart';

@DriftDatabase(
  tables: [TodoTable, UserTable, SessionTable, LetterTable, ChatRoomTable, ChatMemberTable],
  daos: [TodoDao, UserDao, SessionDao, LettersDao, ChatRoomDao],
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

      return NativeDatabase(file, setup: (database) {});
    });
  }

  Future<void> validateDatabaseSchema(GeneratedDatabase database) async {
    // This method validates that the actual schema of the opened database matches
    // the tables, views, triggers and indices for which drift_dev has generated
    // code.
    // Validating the database's schema after opening it is generally a good idea,
    // since it allows us to get an early warning if we change a table definition
    // without writing a schema migration for it.
    //
    // For details, see: https://drift.simonbinder.eu/docs/advanced-features/migrations/#verifying-a-database-schema-at-runtime
    final appEnv = Platform.environment['APP_ENV'];
    if (appEnv != 'production') {
      await VerifySelf(database).validateDatabaseSchema();
    }
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        // Make sure that foreign keys are enabled
        await customStatement('PRAGMA foreign_keys = ON');

        if (details.wasCreated) {
          // Create a bunch of default values so the app doesn't look too empty
          // on the first start.
          await batch((b) {
            b.insertAll(chatRoomTable, [
              ChatRoomTableCompanion.insert(name: 'dev'),
              ChatRoomTableCompanion.insert(name: 'test'),
            ]);
          });
        }

        // This follows the recommendation to validate that the database schema
        // matches what drift expects (https://drift.simonbinder.eu/docs/advanced-features/migrations/#verifying-a-database-schema-at-runtime).
        // It allows catching bugs in the migration logic early.
        await validateDatabaseSchema(this);
      },
    );
  }
}
