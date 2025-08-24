import 'dart:io';
import 'package:backend/db_client/dao/game_dao.dart';
import 'package:backend/db_client/dao/unit_dao.dart';
import 'package:backend/db_client/tables/character_table.dart';
import 'package:backend/db_client/tables/selected_unit_table.dart';
import 'package:backend/db_client/tables/unit_table.dart';
import 'package:backend/user/password_hash_service.dart';
import 'package:get_it/get_it.dart';

import 'dao/letters_dao.dart';
import 'dao/session_dao.dart';
import 'dao/todo_dao.dart';
import 'tables/fake_user_table.dart';
import 'tables/todo_table.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;

import 'package:sha_red/sha_red.dart';
import 'package:sqlite3/sqlite3.dart';
// import 'package:uuid/uuid.dart';
import 'package:backend/db_client/dao/config_dao.dart';
import 'package:backend/db_client/dao/room_dao.dart';
import 'package:backend/db_client/dao/user_dao.dart';
import 'package:backend/db_client/tables/ws_config_table.dart';
import 'package:backend/db_client/tables/room_table.dart';
import 'package:backend/db_client/tables/room_member_table.dart';
import 'package:backend/db_client/tables/letter_table.dart';
import 'package:backend/db_client/tables/session_table.dart';
import 'package:backend/db_client/tables/user_table.dart';

part 'db_client.g.dart';

@DriftDatabase(
  tables: [
    TodoTable,
    UserTable,
    FakeUserTable,
    SessionTable,
    LetterTable,
    RoomTable,
    RoomMemberTable,
    WsConfigTable,
    CharacterTable,
    UnitTable,
    SelectedUnitTable,
  ],
  daos: [
    TodoDao,
    UserDao,
    SessionDao,
    LettersDao,
    RoomDao,
    ConfigDao,
    GameDao,
    UnitDao,
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

        if (details.wasCreated) {
          // Create a bunch of default values so the app doesn't look too empty
          // on the first start.
          final devChat = await into(
            roomTable,
          ).insertReturning(RoomTableCompanion.insert(name: 'dev-chat'));
          final testChat = await into(
            roomTable,
          ).insertReturning(RoomTableCompanion.insert(name: 'test-chat'));
          await into(wsConfigTable).insert(
            WsConfigTableCompanion.insert(
              name: 'user',
              role: Value(Role.user),
              letterRoom: devChat.name,
              version: 1,
            ),
          );
          await into(wsConfigTable).insert(
            WsConfigTableCompanion.insert(
              name: 'test',
              role: Value(Role.tester),
              letterRoom: testChat.name,
              version: 1,
            ),
          );
          await into(userTable).insert(
            UserTableCompanion.insert(
              email: 'admin@admin.dev',
              role: Value(Role.admin),
              password: GetIt.I.get<PasswordHasherService>().hashPassword(
                'admin_password',
              ),
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
