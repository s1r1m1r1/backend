import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'inject.config.dart';

@InjectableInit(preferRelativeImports: false)
configInjector(GetIt getIt, {String? env, EnvironmentFilter? environmentFilter}) {
  return getIt.init(environmentFilter: environmentFilter, environment: env);
}
