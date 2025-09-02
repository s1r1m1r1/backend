// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:backend/db_client/db_client.dart' as _i946;
import 'package:backend/db_client/db_module.dart' as _i459;
import 'package:backend/game/unit_datasource.dart' as _i845;
import 'package:backend/game/unit_repository.dart' as _i850;
import 'package:backend/modules/auth/mailing_service.dart' as _i562;
import 'package:backend/modules/auth/password_hash_service.dart' as _i636;
import 'package:backend/modules/auth/session_datasource.dart' as _i108;
import 'package:backend/modules/auth/session_repository.dart' as _i314;
import 'package:backend/modules/auth/user_datasource.dart' as _i473;
import 'package:backend/modules/auth/user_repository.dart' as _i605;
import 'package:backend/modules/game/active_users.broadcast.dart' as _i44;
import 'package:backend/modules/game/arena.broadcast.dart' as _i665;
import 'package:backend/modules/game/combat.broadcast.dart' as _i416;
import 'package:backend/modules/game/domain/active_sessions_repository.dart'
    as _i75;
import 'package:backend/modules/game/domain/letters_repository.dart' as _i574;
import 'package:backend/modules/game/domain/ws_bot_repository.dart' as _i1027;
import 'package:backend/modules/game/letters.broad_manager.dart' as _i867;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:sha_red/sha_red.dart' as _i890;

const String _prod = 'prod';
const String _test = 'test';
const String _dev = 'dev';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final dbClientModule = _$DbClientModule();
    final activeSessionsModule = _$ActiveSessionsModule();
    final lettersBroadManagerModule = _$LettersBroadManagerModule();
    final arenaBroadcastModule = _$ArenaBroadcastModule();
    final activeUsersBroadcastModule = _$ActiveUsersBroadcastModule();
    gh.lazySingleton<_i946.DbClient>(() => dbClientModule.dbClient);
    gh.lazySingleton<_i636.PasswordHasherService>(
      () => const _i636.PasswordHasherService(),
    );
    gh.lazySingleton<_i75.ActiveUsersRepository>(
      () => activeSessionsModule.activeUsersRepository(),
    );
    gh.lazySingleton<_i574.LettersRepository>(
      () => _i574.LettersRepository(gh<_i946.DbClient>()),
    );
    gh.lazySingleton<_i473.UserDataSource>(
      () => _i473.UserDataSourceImpl(gh<_i946.DbClient>()),
    );
    gh.lazySingleton<_i108.SessionDatasource>(
      () => _i108.SessionSqliteDatasourceImpl(gh<_i946.DbClient>()),
    );
    gh.lazySingleton<_i845.UnitDatasource>(
      () => _i845.UnitDatasourceImpl(gh<_i946.DbClient>()),
    );
    gh.lazySingleton<_i867.LettersBroadManager>(
      () => lettersBroadManagerModule.prodLettersManager(
        gh<_i574.LettersRepository>(),
      ),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i562.MailingService>(() => _i562.MailingServiceImpl());
    gh.lazySingleton<_i867.LettersBroadManager>(
      () => lettersBroadManagerModule.devLettersManager(
        gh<_i574.LettersRepository>(),
      ),
      registerFor: {_test, _dev},
    );
    gh.lazySingleton<_i605.UserRepository>(
      () => _i605.UserRepositoryImpl(
        gh<_i473.UserDataSource>(),
        gh<_i636.PasswordHasherService>(),
        gh<_i562.MailingService>(),
      ),
    );
    gh.lazySingleton<_i665.ArenaBroadcast>(
      () => arenaBroadcastModule.prodArena(),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i850.UnitRepository>(
      () => _i850.UnitRepositoryImpl(gh<_i845.UnitDatasource>()),
    );
    gh.lazySingleton<_i665.ArenaBroadcast>(
      () => arenaBroadcastModule.devArena(),
      registerFor: {_test, _dev},
    );
    gh.lazySingleton<_i314.SessionRepository>(
      () => _i314.SessionRepositoryImpl(gh<_i108.SessionDatasource>()),
    );
    gh.lazySingleton<_i44.ActiveUsersBroad>(
      () => activeUsersBroadcastModule.prodBroadcast(
        gh<_i75.ActiveUsersRepository>(),
        gh<_i850.UnitRepository>(),
        gh<_i314.SessionRepository>(),
      ),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i44.ActiveUsersBroad>(
      () => activeUsersBroadcastModule.devBroadcast(
        gh<_i75.ActiveUsersRepository>(),
        gh<_i850.UnitRepository>(),
        gh<_i314.SessionRepository>(),
      ),
      registerFor: {_test, _dev},
    );
    gh.factoryParam<_i416.CombatBroadcast, int, _i890.EdictDto>(
      (edictId, edict) => _i416.CombatBroadcast(
        gh<_i75.ActiveUsersRepository>(),
        gh<_i314.SessionRepository>(),
        gh<_i850.UnitRepository>(),
        gh<_i605.UserRepository>(),
        edictId,
        edict,
      ),
    );
    gh.lazySingleton<_i1027.BotRepository>(
      () => _i1027.BotRepository(gh<_i44.ActiveUsersBroad>()),
    );
    return this;
  }
}

class _$DbClientModule extends _i459.DbClientModule {}

class _$ActiveSessionsModule extends _i75.ActiveSessionsModule {}

class _$LettersBroadManagerModule extends _i867.LettersBroadManagerModule {}

class _$ArenaBroadcastModule extends _i665.ArenaBroadcastModule {}

class _$ActiveUsersBroadcastModule extends _i44.ActiveUsersBroadcastModule {}
