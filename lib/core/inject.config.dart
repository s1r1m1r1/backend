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
import 'package:backend/features/arena/arena.broadcast.dart' as _i84;
import 'package:backend/features/auth/mailing_service.dart' as _i871;
import 'package:backend/features/auth/password_hash_service.dart' as _i856;
import 'package:backend/features/auth/session_datasource.dart' as _i983;
import 'package:backend/features/auth/session_repository.dart' as _i154;
import 'package:backend/features/auth/user_datasource.dart' as _i410;
import 'package:backend/features/auth/user_repository.dart' as _i294;
import 'package:backend/features/chat/letters.broad_manager.dart' as _i100;
import 'package:backend/features/chat/letters_repository.dart' as _i278;
import 'package:backend/features/online/active_users/active_users.broadcast.dart'
    as _i569;
import 'package:backend/game/unit_datasource.dart' as _i845;
import 'package:backend/game/unit_repository.dart' as _i850;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

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
    final lettersBroadManagerModule = _$LettersBroadManagerModule();
    final arenaBroadcastModule = _$ArenaBroadcastModule();
    final activeUsersBroadcastModule = _$ActiveUsersBroadcastModule();
    gh.lazySingleton<_i946.DbClient>(() => dbClientModule.dbClient);
    gh.lazySingleton<_i856.PasswordHasherService>(
      () => const _i856.PasswordHasherService(),
    );
    gh.lazySingleton<_i871.MailingService>(() => _i871.MailingServiceImpl());
    gh.lazySingleton<_i278.LettersRepository>(
      () => _i278.LettersRepository(gh<_i946.DbClient>()),
    );
    gh.lazySingleton<_i983.SessionDatasource>(
      () => _i983.SessionSqliteDatasourceImpl(gh<_i946.DbClient>()),
    );
    gh.lazySingleton<_i410.UserDataSource>(
      () => _i410.UserDataSourceImpl(gh<_i946.DbClient>()),
    );
    gh.lazySingleton<_i845.UnitDatasource>(
      () => _i845.UnitDatasourceImpl(gh<_i946.DbClient>()),
    );
    gh.lazySingleton<_i294.UserRepository>(
      () => _i294.UserRepositoryImpl(
        gh<_i410.UserDataSource>(),
        gh<_i856.PasswordHasherService>(),
        gh<_i871.MailingService>(),
      ),
    );
    gh.lazySingleton<_i100.LettersBroadManager>(
      () => lettersBroadManagerModule.prodLettersManager(
        gh<_i278.LettersRepository>(),
      ),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i154.SessionRepository>(
      () => _i154.SessionRepositoryImpl(gh<_i983.SessionDatasource>()),
    );
    gh.lazySingleton<_i100.LettersBroadManager>(
      () => lettersBroadManagerModule.devLettersManager(
        gh<_i278.LettersRepository>(),
      ),
      registerFor: {_test, _dev},
    );
    gh.lazySingleton<_i84.ArenaBroadcast>(
      () => arenaBroadcastModule.prodArena(),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i850.UnitRepository>(
      () => _i850.UnitRepositoryImpl(gh<_i845.UnitDatasource>()),
    );
    gh.lazySingleton<_i84.ArenaBroadcast>(
      () => arenaBroadcastModule.devArena(),
      registerFor: {_test, _dev},
    );
    gh.lazySingleton<_i569.ActiveUsersBroad>(
      () => activeUsersBroadcastModule.devBroadcast(
        gh<_i850.UnitRepository>(),
        gh<_i154.SessionRepository>(),
      ),
      registerFor: {_test, _dev},
    );
    gh.lazySingleton<_i569.ActiveUsersBroad>(
      () => activeUsersBroadcastModule.prodBroadcast(
        gh<_i850.UnitRepository>(),
        gh<_i154.SessionRepository>(),
      ),
      registerFor: {_prod},
    );
    return this;
  }
}

class _$DbClientModule extends _i459.DbClientModule {}

class _$LettersBroadManagerModule extends _i100.LettersBroadManagerModule {}

class _$ArenaBroadcastModule extends _i84.ArenaBroadcastModule {}

class _$ActiveUsersBroadcastModule extends _i569.ActiveUsersBroadcastModule {}
