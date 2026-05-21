import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:mailing/mailing.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  externalPackageModulesBefore: [ExternalModule(MailingPackageModule)],
)
Future<void> configureDependencies({String? environment}) =>
    getIt.init(environment: environment);
