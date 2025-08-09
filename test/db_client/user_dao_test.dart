import '../../lib/db_client/dao/user_dao.dart';
import '../../lib/db_client/db_client.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

class TestDbClient extends DbClient {
  TestDbClient() : super(NativeDatabase.memory());
}

void main() {
  late TestDbClient db;
  late UserDao dao;

  setUp(() async {
    db = TestDbClient();
    dao = UserDao(db);
    // Ensure tables are created
    await db.customStatement('PRAGMA foreign_keys = ON');
  });

  tearDown(() async {
    await db.close();
  });
}
