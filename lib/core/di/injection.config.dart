// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:backend/core/app_observer.dart' as _i604;
import 'package:backend/core/server_app_observer.dart' as _i835;
import 'package:backend/core/system_health_service.dart' as _i809;
import 'package:backend/db_client/dao/game_dao.dart' as _i401;
import 'package:backend/db_client/dao/letters_dao.dart' as _i303;
import 'package:backend/db_client/dao/log_dao.dart' as _i822;
import 'package:backend/db_client/dao/room_dao.dart' as _i196;
import 'package:backend/db_client/dao/session_dao.dart' as _i1050;
import 'package:backend/db_client/dao/todo_dao.dart' as _i553;
import 'package:backend/db_client/dao/unit_dao.dart' as _i787;
import 'package:backend/db_client/dao/user_dao.dart' as _i958;
import 'package:backend/db_client/db_client.dart' as _i946;
import 'package:backend/db_client/db_client_module.dart' as _i1064;
import 'package:backend/features/auth/application/online_repository_impl.dart'
    as _i35;
import 'package:backend/features/auth/application/presence_manager.dart'
    as _i158;
import 'package:backend/features/auth/application/system_orchestrator.dart'
    as _i227;
import 'package:backend/features/auth/data/session_repository_impl.dart'
    as _i224;
import 'package:backend/features/auth/data/user_repository_impl.dart' as _i894;
import 'package:backend/features/auth/domain/session_repository.dart' as _i454;
import 'package:backend/features/auth/domain/user_repository.dart' as _i789;
import 'package:backend/features/bot/application/bot_generator.dart' as _i54;
import 'package:backend/features/bot/application/ws_bot_repository.dart'
    as _i781;
import 'package:backend/features/chat/application/letters_broad_manager.dart'
    as _i689;
import 'package:backend/features/chat/data/letters_repository_impl.dart'
    as _i309;
import 'package:backend/features/chat/domain/letters_repository.dart' as _i593;
import 'package:backend/features/game/application/arena_broadcast.dart'
    as _i207;
import 'package:backend/features/game/application/combat_supervisor.dart'
    as _i212;
import 'package:backend/features/game/data/unit_repository_impl.dart' as _i814;
import 'package:backend/features/game/domain/unit_repository.dart' as _i319;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:mailing/application/mailing_service.dart' as _i834;

const String _memory = 'memory';
const String _prod = 'prod';
const String _dev = 'dev';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final dbClientModule = _$DbClientModule();
    gh.lazySingleton<_i35.OnlineRepository>(() => _i35.OnlineRepository());
    gh.lazySingleton<_i946.DbClient>(
      () => dbClientModule.memory(),
      registerFor: {_memory},
    );
    gh.lazySingleton<_i604.AppObserver>(() => const _i835.ServerAppObserver());
    gh.lazySingleton<_i946.DbClient>(
      () => dbClientModule.file(),
      registerFor: {_prod, _dev},
    );
    gh.lazySingleton<_i789.UserRepository>(
      () => _i894.UserRepositoryImpl(
        gh<_i946.DbClient>(),
        gh<_i834.MailingService>(),
      ),
    );
    gh.lazySingleton<_i958.UserDao>(
      () => dbClientModule.userDao(gh<_i946.DbClient>()),
    );
    gh.lazySingleton<_i401.GameDao>(
      () => dbClientModule.gameDao(gh<_i946.DbClient>()),
    );
    gh.lazySingleton<_i553.TodoDao>(
      () => dbClientModule.todoDao(gh<_i946.DbClient>()),
    );
    gh.lazySingleton<_i1050.SessionDao>(
      () => dbClientModule.sessionDao(gh<_i946.DbClient>()),
    );
    gh.lazySingleton<_i303.LettersDao>(
      () => dbClientModule.lettersDao(gh<_i946.DbClient>()),
    );
    gh.lazySingleton<_i196.RoomDao>(
      () => dbClientModule.roomDao(gh<_i946.DbClient>()),
    );
    gh.lazySingleton<_i787.UnitDao>(
      () => dbClientModule.unitDao(gh<_i946.DbClient>()),
    );
    gh.lazySingleton<_i822.LogDao>(
      () => dbClientModule.logDao(gh<_i946.DbClient>()),
    );
    gh.lazySingleton<_i319.UnitRepository>(
      () => _i814.UnitRepositoryImpl(gh<_i946.DbClient>()),
    );
    gh.lazySingleton<_i454.SessionRepository>(
      () => _i224.SessionRepositoryImpl(gh<_i946.DbClient>()),
    );
    gh.lazySingleton<_i593.LettersRepository>(
      () => _i309.LettersRepositoryImpl(gh<_i303.LettersDao>()),
    );
    gh.lazySingleton<_i689.LettersBroadManager>(
      () =>
          _i689.LettersBroadManager(gh<_i593.LettersRepository>())
            ..createRooms(),
    );
    gh.lazySingleton<_i54.BotGenerator>(
      () => _i54.BotGenerator(gh<_i958.UserDao>(), gh<_i787.UnitDao>()),
    );
    gh.lazySingleton<_i212.CombatSupervisor>(
      () => _i212.CombatSupervisor(
        gh<_i35.OnlineRepository>(),
        gh<_i454.SessionRepository>(),
        gh<_i319.UnitRepository>(),
        gh<_i789.UserRepository>(),
      ),
    );
    gh.lazySingleton<_i158.PresenceManager>(
      () => _i158.PresenceManagerImpl(
        gh<_i35.OnlineRepository>(),
        gh<_i319.UnitRepository>(),
        gh<_i454.SessionRepository>(),
      ),
    );
    gh.lazySingleton<_i207.ArenaBroadcast>(
      () => _i207.ArenaBroadcast(gh<_i212.CombatSupervisor>()),
    );
    gh.lazySingleton<_i781.BotRepository>(
      () => _i781.BotRepository(
        gh<_i158.PresenceManager>(),
        gh<_i207.ArenaBroadcast>(),
        gh<_i212.CombatSupervisor>(),
        gh<_i319.UnitRepository>(),
        gh<_i787.UnitDao>(),
        gh<_i689.LettersBroadManager>(),
      ),
    );
    gh.lazySingleton<_i809.SystemHealthService>(
      () => _i809.SystemHealthService(
        gh<_i35.OnlineRepository>(),
        gh<_i212.CombatSupervisor>(),
      ),
    );
    gh.singletonAsync<_i227.SystemOrchestrator>(() {
      final i = _i227.SystemOrchestrator(
        gh<_i789.UserRepository>(),
        gh<_i454.SessionRepository>(),
        gh<_i319.UnitRepository>(),
        gh<_i781.BotRepository>(),
        gh<_i158.PresenceManager>(),
        gh<_i54.BotGenerator>(),
      );
      return i.createBots().then((_) => i);
    });
    return this;
  }
}

class _$DbClientModule extends _i1064.DbClientModule {}
