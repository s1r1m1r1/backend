import 'package:injectable/injectable.dart';
import 'package:get_it/get_it.dart';

import 'inject.config.dart';

///  /\_/\
/// ( o.o )
///  > ^ <

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();
