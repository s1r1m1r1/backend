import 'package:drift/native.dart';
import 'package:injectable/injectable.dart';

import 'dao/game_dao.dart';
import 'dao/letters_dao.dart';
import 'dao/log_dao.dart';
import 'dao/room_dao.dart';
import 'dao/session_dao.dart';
import 'dao/todo_dao.dart';
import 'dao/unit_dao.dart';
import 'dao/user_dao.dart';
import 'db_client.dart';

@module
abstract class DbClientModule {
  @Environment('memory')
  @lazySingleton
  DbClient memory() => DbClient(NativeDatabase.memory());

  @prod
  @dev
  @lazySingleton
  DbClient file() => DbClient(DbClient.openConnection());

  @lazySingleton
  UserDao userDao(DbClient db) => db.userDao;

  @lazySingleton
  GameDao gameDao(DbClient db) => db.gameDao;

  @lazySingleton
  TodoDao todoDao(DbClient db) => db.todoDao;

  @lazySingleton
  SessionDao sessionDao(DbClient db) => db.sessionDao;

  @lazySingleton
  LettersDao lettersDao(DbClient db) => db.lettersDao;

  @lazySingleton
  RoomDao roomDao(DbClient db) => db.roomDao;

  @lazySingleton
  UnitDao unitDao(DbClient db) => db.unitDao;

  @lazySingleton
  LogDao logDao(DbClient db) => db.logDao;
}
