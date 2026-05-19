import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
// ignore: depend_on_referenced_packages
import 'package:drift_dev/api/migrations_native.dart';
import 'package:dto/dto.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';

import '../core/constants.dart';
import '../features/auth/application/password_utils.dart';
import 'dao/game_dao.dart';
import 'dao/letters_dao.dart';
import 'dao/log_dao.dart';
import 'dao/room_dao.dart';
import 'dao/session_dao.dart';
import 'dao/todo_dao.dart';
import 'dao/unit_dao.dart';
import 'dao/user_dao.dart';
import 'tables/character_table.dart';
import 'tables/letter_table.dart';
import 'tables/log_entry_table.dart';
import 'tables/room_member_table.dart';
import 'tables/room_table.dart';
import 'tables/selected_unit_table.dart';
import 'tables/session_table.dart';
import 'tables/todo_table.dart';
import 'tables/unit_table.dart';
import 'tables/user_table.dart';

part 'db_client.g.dart';

@DriftDatabase(
  tables: [
    TodoTable,
    UserTable,
    SessionTable,
    LetterTable,
    RoomTable,
    RoomMemberTable,
    CharacterTable,
    UnitTable,
    SelectedUnitTable,
    LogEntries,
  ],
  daos: [
    TodoDao,
    UserDao,
    SessionDao,
    LettersDao,
    RoomDao,
    GameDao,
    UnitDao,
    LogDao,
  ],
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
        // Enable WAL mode for better concurrent read/write performance
        await customStatement('PRAGMA journal_mode = WAL');
        // Balance between speed and safety (safe with WAL mode)
        await customStatement('PRAGMA synchronous = NORMAL');
        // Increase cache size to 64MB (default is 2MB)
        await customStatement('PRAGMA cache_size = -64000');
        // Store temporary tables in memory instead of disk
        await customStatement('PRAGMA temp_store = MEMORY');
        // Enable memory-mapped I/O for faster reads (256MB)
        await customStatement('PRAGMA mmap_size = 268435456');
        // Set busy timeout to 5 seconds instead of failing immediately
        await customStatement('PRAGMA busy_timeout = 5000');

        if (details.wasCreated) {
          // Create a bunch of default values so the app doesn't look too empty
          // on the first start.
          await into(roomTable).insertReturning(
            RoomTableCompanion.insert(
              id: BroadcastKeys.publicLetters,
              name: 'public-chat',
            ),
          );
          await into(roomTable).insertReturning(
            RoomTableCompanion.insert(
              id: BroadcastKeys.developLetters,
              name: 'develop-chat',
            ),
          );

          await into(userTable).insert(
            UserTableCompanion.insert(
              email: 'qq@qq.qq',
              role: const Value(Role.develop),
              password: PasswordUtils.hashPassword('12wqAS'),
            ),
          );
          final wwwUser = await into(userTable).insertReturning(
            UserTableCompanion.insert(
              email: 'ww@ww.ww',
              role: const Value(Role.develop),
              password: PasswordUtils.hashPassword('12wqAS'),
            ),
          );

          final wwwUnit = await into(unitTable).insertReturning(
            UnitTableCompanion.insert(
              name: 'wwwUnit',
              atk: 9,
              def: 2,
              vitality: 50,
              userId: wwwUser.id,
            ),
          );

          await into(selectedUnitTable).insert(
            SelectedUnitTableCompanion.insert(
              userId: wwwUser.id,
              unitId: wwwUnit.id,
            ),
          );
        }

        // This follows the recommendation to validate that the database schema
        // matches what drift expects (https://drift.simonbinder.eu/docs/advanced-features/migrations/#verifying-a-database-schema-at-runtime).
        // It allows catching bugs in the migration logic early.
        await validateDatabaseSchema(this);
      },
    );
  }
}
