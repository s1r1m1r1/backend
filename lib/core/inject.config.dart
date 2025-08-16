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
import 'package:backend/user/password_hash_service.dart' as _i405;
import 'package:backend/user/session_datasource.dart' as _i1057;
import 'package:backend/user/session_repository.dart' as _i854;
import 'package:backend/user/user_datasource.dart' as _i625;
import 'package:backend/user/user_repository.dart' as _i470;
import 'package:backend/user/ws_active_sessions.dart' as _i896;
import 'package:backend/ws_/letters_repository.dart' as _i878;
import 'package:backend/ws_/logic/active_users.bloc.dart' as _i159;
import 'package:backend/ws_/logic/letter.bloc_manager.dart' as _i288;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final dbClientModule = _$DbClientModule();
    gh.lazySingleton<_i946.DbClient>(() => dbClientModule.dbClient);
    gh.lazySingleton<_i405.PasswordHasherService>(
      () => const _i405.PasswordHasherService(),
    );
    gh.lazySingleton<_i896.WsActiveSessions>(() => _i896.WsActiveSessions());
    gh.lazySingleton<_i1057.SessionDatasource>(
      () => _i1057.SessionSqliteDatasourceImpl(gh<_i946.DbClient>()),
    );
    gh.lazySingleton<_i878.LettersRepository>(
      () => _i878.LettersRepository(gh<_i946.DbClient>()),
    );
    gh.lazySingleton<_i625.UserDataSource>(
      () => _i625.UserDataSourceImpl(gh<_i946.DbClient>()),
    );
    gh.lazySingleton<_i845.UnitDatasource>(
      () => _i845.UnitDatasourceImpl(gh<_i946.DbClient>()),
    );
    gh.lazySingleton<_i854.SessionRepository>(
      () => _i854.SessionRepositoryImpl(gh<_i1057.SessionDatasource>()),
    );
    gh.lazySingleton<_i850.UnitRepository>(
      () => _i850.UnitRepositoryImpl(gh<_i845.UnitDatasource>()),
    );
    gh.lazySingleton<_i470.UserRepository>(
      () => _i470.UserRepositoryImpl(
        gh<_i625.UserDataSource>(),
        gh<_i405.PasswordHasherService>(),
      ),
    );
    gh.lazySingleton<_i159.ActiveUsersBloc>(
      () => _i159.ActiveUsersBloc(gh<_i896.WsActiveSessions>()),
    );
    gh.lazySingleton<_i288.LetterBlocManager>(
      () => _i288.LetterBlocManager(
        gh<_i878.LettersRepository>(),
        gh<_i896.WsActiveSessions>(),
      ),
    );
    return this;
  }
}

class _$DbClientModule extends _i459.DbClientModule {}
