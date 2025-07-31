import 'dart:io';
import 'package:backend/db_client/dao/channel_dao.dart';
import 'package:backend/db_client/dao/letters_dao.dart';
import 'package:backend/db_client/dao/session_dao.dart';
import 'package:backend/db_client/dao/todo_dao.dart';
import 'package:backend/db_client/tables/channel_table.dart';
import 'package:backend/db_client/tables/todo_table.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:uuid/uuid.dart';
import 'dao/chat_room_dao.dart';
import 'dao/messages_dao.dart';
import 'dao/user_dao.dart';
import 'tables/chat_room_table.dart';
import 'tables/letter_table.dart';
import 'tables/message_table.dart';
import 'tables/session_table.dart';
import 'tables/user_table.dart';

part 'db_client.g.dart';

@DriftDatabase(
  tables: [ChannelTable, TodoTable, UserTable, SessionTable, MessageTable, LetterTable, ChatRoomTable],
  daos: [ChannelDao, TodoDao, UserDao, SessionDao, MessagesDao, LettersDao, ChatRoomDao],
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
