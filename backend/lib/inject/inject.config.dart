// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:backend/chat/counter_repository.dart' as _i763;
import 'package:backend/config/autostart_manager.dart' as _i887;
import 'package:backend/config/ws_config_datasource.dart' as _i573;
import 'package:backend/config/ws_config_repository.dart' as _i416;
import 'package:backend/db_client/dao/config_dao.dart' as _i667;
import 'package:backend/db_client/dao/letters_dao.dart' as _i303;
import 'package:backend/db_client/dao/room_dao.dart' as _i196;
import 'package:backend/db_client/dao/session_dao.dart' as _i1050;
import 'package:backend/db_client/dao/todo_dao.dart' as _i553;
import 'package:backend/db_client/dao/user_dao.dart' as _i958;
import 'package:backend/db_client/db_client.dart' as _i946;
import 'package:backend/db_client/db_module.dart' as _i459;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    _i526.GetItHelper(this, environment, environmentFilter);
    return this;
  }

  // initializes the registration of backend-scope dependencies inside of GetIt
  _i174.GetIt initBackendScope({_i174.ScopeDisposeFunc? dispose}) {
    return _i526.GetItHelper(this).initScope(
      'backend',
      dispose: dispose,
      init: (_i526.GetItHelper gh) {
        final dbClientModule = _$DbClientModule();
        gh.lazySingleton<_i763.CounterRepository>(
          () => _i763.CounterRepository(),
        );
        gh.lazySingleton<_i946.DbClient>(() => dbClientModule.dbClient);
        gh.lazySingleton<_i553.TodoDao>(
          () => _i553.TodoDao(gh<_i946.DbClient>()),
        );
        gh.lazySingleton<_i958.UserDao>(
          () => _i958.UserDao(gh<_i946.DbClient>()),
        );
        gh.lazySingleton<_i1050.SessionDao>(
          () => _i1050.SessionDao(gh<_i946.DbClient>()),
        );
        gh.lazySingleton<_i196.RoomDao>(
          () => _i196.RoomDao(gh<_i946.DbClient>()),
        );
        gh.lazySingleton<_i303.LettersDao>(
          () => _i303.LettersDao(gh<_i946.DbClient>()),
        );
        gh.lazySingleton<_i667.ConfigDao>(
          () => _i667.ConfigDao(gh<_i946.DbClient>()),
        );
        gh.lazySingleton<_i573.WsConfigDatasource>(
          () => _i573.WsConfigDatasourceImpl(gh<_i667.ConfigDao>()),
        );
        gh.lazySingleton<_i416.WsConfigRepository>(
          () => _i416.WsConfigRepositoryImpl(gh<_i573.WsConfigDatasource>()),
        );
        gh.lazySingleton<_i887.AutostartManager>(
          () => _i887.AutostartManager(
            gh<_i416.WsConfigRepository>(),
            gh<_i763.CounterRepository>(),
          ),
        );
      },
    );
  }
}

class _$DbClientModule extends _i459.DbClientModule {}
